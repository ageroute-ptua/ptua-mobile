import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/enquete.dart';
import '../models/pap.dart';
import '../models/menage.dart';
import '../models/activite.dart';
import '../models/sante.dart';
import '../models/education.dart';
import '../models/avis_projet.dart';
import '../models/localisation.dart';
import '../models/document.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // v4: fixed FOREIGN KEY bug in localisations table
    String path = join(await getDatabasesPath(), 'ptua_database_v4.db');
    return await openDatabase(
      path,
      version: 5,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE enquetes ADD COLUMN photoPath TEXT;');
      await db.execute('ALTER TABLE enquetes ADD COLUMN signaturePath TEXT;');
    }
    if (oldVersion < 5) {
      // Add statutBien column which was missing
      await db.execute('ALTER TABLE paps ADD COLUMN statutBien TEXT;');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // ENQUETE
    await db.execute('''
      CREATE TABLE enquetes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idEnquete TEXT UNIQUE,
        enqueteur TEXT,
        dateEnquete TEXT,
        communeCode TEXT,
        quartierCode TEXT,
        contact TEXT,
        projetCode TEXT,
        sectionCode TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        deviceId TEXT,
        photoPath TEXT,
        signaturePath TEXT
      )
    ''');

    // PAP
    await db.execute('''
      CREATE TABLE paps(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idEnquete TEXT,
        idPapMetier TEXT,
        identifiantPap TEXT UNIQUE,
        nomPap TEXT,
        nomProprio TEXT,
        dateNaissance TEXT,
        genre TEXT,
        nationalite TEXT,
        ethnie TEXT,
        niveauInstruc TEXT,
        typePiece TEXT,
        numPiece TEXT,
        situationMat TEXT,
        anneeInst INTEGER,
        appCulture TEXT,
        motifInstall TEXT,
        lieuResidenceAct TEXT,
        telephone1 TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        deviceId TEXT,
        statutBien TEXT,
        FOREIGN KEY (idEnquete) REFERENCES enquetes (idEnquete) ON DELETE CASCADE
      )
    ''');

    // MENAGE
    await db.execute('''
      CREATE TABLE menages(
        idMenage INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        nbrePersonnesMenage INTEGER,
        isChefMen INTEGER,
        appartenanceOrg TEXT,
        isPersonneVulMenage INTEGER,
        typeSanitaire TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        deviceId TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // ACTIVITE
    await db.execute('''
      CREATE TABLE activites(
        idActivite INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        activitePrincipMenage TEXT,
        revenuMoyeActPrin REAL,
        transferArg INTEGER,
        lieuTravail TEXT,
        presenceActivSecondMenage INTEGER,
        revenuCumul REAL,
        isParcelleHorsEmprise INTEGER,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        deviceId TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // SANTE
    await db.execute('''
      CREATE TABLE santes(
        idSante INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        distanceDomSante INTEGER,
        isAssurance INTEGER,
        nbrPersCouvAssurance INTEGER,
        assureur TEXT,
        tauxCouverture REAL,
        nbrPersMalade INTEGER,
        typeSoinMen TEXT,
        justifReponse TEXT,
        periodeAnMalade INTEGER,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        deviceId TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // EDUCATION
    await db.execute('''
      CREATE TABLE educations(
        idEducation INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        nbrEnf0_14 INTEGER,
        nbrJeun15_59 INTEGER,
        nbrPersAge60 INTEGER,
        maternelle INTEGER,
        primaire INTEGER,
        secondaire INTEGER,
        superieur INTEGER,
        nbEnftScolarise INTEGER,
        distanceDomEcolePrim INTEGER,
        distanceDomEcoleSec INTEGER,
        nbrEnfScolarisable INTEGER,
        nbrEnfScolarise7_18 INTEGER,
        francoArabe INTEGER,
        nbrElevMangCantine INTEGER,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        deviceId TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // AVIS PROJET
    await db.execute('''
      CREATE TABLE avis_projets(
        idAvis INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        isAvezCraintes INTEGER,
        isAvezAttentes INTEGER,
        isRecommandation INTEGER,
        penseePrj TEXT,
        ouiCraintes TEXT,
        informationProjet TEXT,
        sourceInfor TEXT,
        prjInfoRecues TEXT,
        justiAvis TEXT,
        ouiAttentes TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        deviceId TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // LOCALISATION
    await db.execute('''
      CREATE TABLE localisations(
        idLocalisation INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT NOT NULL UNIQUE,
        latitude REAL,
        longitude REAL,
        altitude REAL,
        precisionGps REAL,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // DOCUMENT
    await db.execute('''
      CREATE TABLE documents(
        idDocument INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT,
        codeTypeDoc TEXT,
        cheminFichier TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        syncStatus TEXT,
        deviceId TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // AGRICULTURE / PARCELLE
    await db.execute('''
      CREATE TABLE agricultures(
        idAgriculture INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        aParcelles INTEGER,
        typeCulture TEXT,
        modeAcquisition TEXT,
        exploiteSoiMeme INTEGER,
        localisationParcelles TEXT,
        aAnimaux INTEGER,
        nbBovins INTEGER,
        nbOvins INTEGER,
        nbVolailles INTEGER,
        elevageCommercial INTEGER,
        createdAt TEXT,
        syncStatus TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // FINANCE
    await db.execute('''
      CREATE TABLE finances(
        idFinance INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        aCompteBanque INTEGER,
        pratiqueTontine INTEGER,
        recoitAideFinanciere INTEGER,
        montantAide REAL,
        aDesCredits INTEGER,
        institutionCredit TEXT,
        raisonCredit TEXT,
        statutCredit TEXT,
        montantCredit REAL,
        createdAt TEXT,
        syncStatus TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');

    // SECURITE ALIMENTAIRE
    await db.execute('''
      CREATE TABLE securite_alimentaires(
        idSecAlim INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        joursAlimentsMoinsChers INTEGER,
        joursEmprunterNourriture INTEGER,
        joursLimiterQuantite INTEGER,
        joursRestreindreAdultes INTEGER,
        joursReduireRepas INTEGER,
        joursManquerNourriture INTEGER,
        createdAt TEXT,
        syncStatus TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');
    // LOGEMENT
    await db.execute('''
      CREATE TABLE logements(
        idLogement INTEGER PRIMARY KEY AUTOINCREMENT,
        idPap TEXT UNIQUE,
        statutOccupation TEXT,
        typeBatiment TEXT,
        materiauMur TEXT,
        materiauSol TEXT,
        materiauToit TEXT,
        sourceEau TEXT,
        typeToilette TEXT,
        energieCuisson TEXT,
        energieEclairage TEXT,
        nbPieces INTEGER,
        montantLoyer REAL,
        nomProprietaire TEXT,
        contactProprietaire TEXT,
        dureeLocation TEXT,
        aPayeCaution INTEGER,
        moisCaution INTEGER,
        montantCaution REAL,
        modeAcquisitionTerrain TEXT,
        aMisEnLocation TEXT,
        nbMoisLocation INTEGER,
        revenusLocation REAL,
        createdAt TEXT,
        syncStatus TEXT,
        FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
      )
    ''');
  }

  // --- CRUD ENQUETES ---
  Future<int> insertEnquete(Enquete enquete) async {
    final db = await database;
    return await db.insert('enquetes', enquete.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Enquete>> getEnquetes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('enquetes', orderBy: 'id DESC');
    return maps.map((map) => Enquete.fromMap(map)).toList();
  }

  Future<List<Enquete>> getUnsyncedEnquetes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('enquetes', where: 'syncStatus = ?', whereArgs: ['local']);
    return maps.map((map) => Enquete.fromMap(map)).toList();
  }

  Future<int> updateEnquete(Enquete enquete) async {
    final db = await database;
    return await db.update('enquetes', enquete.toMap(), where: 'id = ?', whereArgs: [enquete.id]);
  }

  Future<int> deleteEnquete(int id) async {
    final db = await database;
    return await db.delete('enquetes', where: 'id = ?', whereArgs: [id]);
  }

  // --- CRUD PAPS ---
  Future<int> insertPap(Pap pap) async {
    final db = await database;
    return await db.insert('paps', pap.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Pap>> getPapsForEnquete(String idEnquete) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('paps', where: 'idEnquete = ?', whereArgs: [idEnquete]);
    return maps.map((map) => Pap.fromMap(map)).toList();
  }

  Future<List<Pap>> getPaps() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('paps');
    return maps.map((map) => Pap.fromMap(map)).toList();
  }

  Future<List<Pap>> getUnsyncedPaps() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('paps', where: 'syncStatus = ?', whereArgs: ['local']);
    return maps.map((map) => Pap.fromMap(map)).toList();
  }

  Future<int> updatePap(Pap pap) async {
    final db = await database;
    return await db.update('paps', pap.toMap(), where: 'id = ?', whereArgs: [pap.id]);
  }

  Future<int> deletePap(int id) async {
    final db = await database;
    return await db.delete('paps', where: 'id = ?', whereArgs: [id]);
  }

  // --- CRUD AUTRES ENTITES (MENAGE, ACTIVITE, etc.) ---
  Future<int> insertMenage(Menage menage) async {
    final db = await database;
    return await db.insert('menages', menage.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Menage?> getMenageByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('menages', where: 'idPap = ?', whereArgs: [idPap]);
    if (maps.isNotEmpty) return Menage.fromMap(maps.first);
    return null;
  }

  Future<int> insertActivite(Activite activite) async {
    final db = await database;
    return await db.insert('activites', activite.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Activite?> getActiviteByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('activites', where: 'idPap = ?', whereArgs: [idPap]);
    if (maps.isNotEmpty) return Activite.fromMap(maps.first);
    return null;
  }

  Future<int> insertSante(Sante sante) async {
    final db = await database;
    return await db.insert('santes', sante.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Sante?> getSanteByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('santes', where: 'idPap = ?', whereArgs: [idPap]);
    if (maps.isNotEmpty) return Sante.fromMap(maps.first);
    return null;
  }

  Future<int> insertEducation(Education education) async {
    final db = await database;
    return await db.insert('educations', education.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Education?> getEducationByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('educations', where: 'idPap = ?', whereArgs: [idPap]);
    if (maps.isNotEmpty) return Education.fromMap(maps.first);
    return null;
  }

  Future<int> insertAvisProjet(AvisProjet avisProjet) async {
    final db = await database;
    return await db.insert('avis_projets', avisProjet.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<AvisProjet?> getAvisProjetByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('avis_projets', where: 'idPap = ?', whereArgs: [idPap]);
    if (maps.isNotEmpty) return AvisProjet.fromMap(maps.first);
    return null;
  }

  Future<int> insertLocalisation(Localisation loc) async {
    final db = await database;
    return await db.insert('localisations', loc.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Localisation?> getLocalisationByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('localisations', where: 'idPap = ?', whereArgs: [idPap]);
    if (maps.isNotEmpty) return Localisation.fromMap(maps.first);
    return null;
  }

  Future<List<Localisation>> getAllLocalisations() async {
    final db = await database;
    final maps = await db.query('localisations');
    return maps.map((map) => Localisation.fromMap(map)).toList();
  }

  Future<int> insertDocument(Document doc) async {
    final db = await database;
    return await db.insert('documents', doc.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Document>> getDocumentsByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('documents', where: 'idPap = ?', whereArgs: [idPap]);
    return maps.map((map) => Document.fromMap(map)).toList();
  }

  // --- CRUD AGRICULTURE ---
  Future<int> insertAgriculture(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('agricultures', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getAgricultureByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('agricultures', where: 'idPap = ?', whereArgs: [idPap]);
    return maps.isNotEmpty ? maps.first : null;
  }

  // --- CRUD FINANCE ---
  Future<int> insertFinance(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('finances', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getFinanceByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('finances', where: 'idPap = ?', whereArgs: [idPap]);
    return maps.isNotEmpty ? maps.first : null;
  }

  // --- CRUD SECURITE ALIMENTAIRE ---
  Future<int> insertSecuriteAlimentaire(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('securite_alimentaires', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getSecuriteAlimentaireByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('securite_alimentaires', where: 'idPap = ?', whereArgs: [idPap]);
    return maps.isNotEmpty ? maps.first : null;
  }

  // --- CRUD LOGEMENT ---
  Future<int> insertLogement(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('logements', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getLogementByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('logements', where: 'idPap = ?', whereArgs: [idPap]);
    return maps.isNotEmpty ? maps.first : null;
  }

  // --- Completion check ---
  Future<Map<String, bool>> getPapCompletionStatus(String idPap) async {
    final menage = await getMenageByPap(idPap);
    final logement = await getLogementByPap(idPap);
    final activite = await getActiviteByPap(idPap);
    final sante = await getSanteByPap(idPap);
    final education = await getEducationByPap(idPap);
    final avis = await getAvisProjetByPap(idPap);
    final agriculture = await getAgricultureByPap(idPap);
    final finance = await getFinanceByPap(idPap);
    return {
      'menage': menage != null,
      'logement': logement != null,
      'activite': activite != null,
      'sante': sante != null,
      'education': education != null,
      'avis': avis != null,
      'agriculture': agriculture != null,
      'finance': finance != null,
    };
  }
}
