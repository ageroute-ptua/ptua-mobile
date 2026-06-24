import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/enquete.dart';
import '../models/pap.dart';
import '../models/bien_impacte.dart';
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
    String path = join(await getDatabasesPath(), 'ptua_database_v9.db');
    return await openDatabase(
      path,
      version: 10,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 10) {
      try {
        await db.execute('ALTER TABLE biens_impactes ADD COLUMN idPap TEXT;');
      } catch (e) {
        // Ignorer si la colonne existe déjà
      }
    }
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE enquetes ADD COLUMN photoPath TEXT;');
      await db.execute('ALTER TABLE enquetes ADD COLUMN signaturePath TEXT;');
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE paps ADD COLUMN statutBien TEXT;');
    }
    if (oldVersion < 6) {
      // Add missing menage fields
      await db.execute('ALTER TABLE menages ADD COLUMN typeMenage TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN isMembreOrganisation INTEGER DEFAULT 0;');
      await db.execute('ALTER TABLE menages ADD COLUMN typeOrganisation TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN toucheRetraite INTEGER DEFAULT 0;');
      await db.execute('ALTER TABLE menages ADD COLUMN montantRetraite REAL;');
    }
    if (oldVersion < 7) {
      // Add missing activite fields
      await db.execute('ALTER TABLE activites ADD COLUMN activiteSecondaire TEXT;');
      await db.execute('ALTER TABLE activites ADD COLUMN aEmployes INTEGER DEFAULT 0;');
      await db.execute('ALTER TABLE activites ADD COLUMN nbEmployes INTEGER;');
      await db.execute('ALTER TABLE activites ADD COLUMN payeTaxes INTEGER DEFAULT 0;');
      await db.execute('ALTER TABLE activites ADD COLUMN quellesTaxes TEXT;');
      await db.execute('ALTER TABLE activites ADD COLUMN frequenceTaxes TEXT;');
    }
    if (oldVersion < 8) {
      await db.execute('ALTER TABLE paps ADD COLUMN prenomPap TEXT;');
      await db.execute('ALTER TABLE paps ADD COLUMN surnom TEXT;');
      await db.execute('ALTER TABLE paps ADD COLUMN religion TEXT;');
      await db.execute('ALTER TABLE paps ADD COLUMN telephone2 TEXT;');
      
      await db.execute('ALTER TABLE activites ADD COLUMN revenuMoyeActPrinMauvaise REAL;');
      await db.execute('ALTER TABLE activites ADD COLUMN revenuMoyeActPrinBonne REAL;');
      await db.execute('ALTER TABLE activites ADD COLUMN statutActivite TEXT;');
      await db.execute('ALTER TABLE activites ADD COLUMN nbMoisActivite INTEGER;');
      
      await db.execute('ALTER TABLE finances ADD COLUMN sourcePrincipaleRevenus TEXT;');
      await db.execute('ALTER TABLE finances ADD COLUMN postesDepenses TEXT;');
      await db.execute('ALTER TABLE finances ADD COLUMN aChargeHorsMenage INTEGER DEFAULT 0;');
      await db.execute('ALTER TABLE finances ADD COLUMN nbTransfertsEnvoyes INTEGER;');
      await db.execute('ALTER TABLE finances ADD COLUMN montantTransfertsEnvoyes REAL;');

      await db.execute('''
        CREATE TABLE membres_menage(
          idMembre INTEGER PRIMARY KEY AUTOINCREMENT,
          idPap TEXT,
          nomPrenom TEXT,
          lienChefMenage TEXT,
          estEnfantMoins5 INTEGER DEFAULT 0,
          age INTEGER,
          estPap INTEGER DEFAULT 0,
          numPiecePap TEXT,
          telephonePap TEXT,
          sexe TEXT,
          nationalite TEXT,
          ethnie TEXT,
          handicap TEXT,
          saitLireEcrire INTEGER DEFAULT 0,
          langueLecture TEXT,
          niveauEtude TEXT,
          vaAEcole INTEGER DEFAULT 0,
          travaille INTEGER DEFAULT 0,
          activitePrincipale TEXT,
          statutActivite TEXT,
          nbMoisActivite INTEGER,
          revenuMensuel REAL,
          activiteSecondaire TEXT,
          statutActiviteSec TEXT,
          nbMoisActiviteSec INTEGER,
          
          revenuMensuelSec REAL,
          sitEmploiMembreMen TEXT,
          autreSituationEmploi TEXT,

          createdAt TEXT,
          syncStatus TEXT,
          deviceId TEXT,
          FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE plans_restauration(
          idPlan INTEGER PRIMARY KEY AUTOINCREMENT,
          idPap TEXT UNIQUE,
          souhaitRestauration TEXT,
          typeCompensation TEXT,
          continuerActivite INTEGER DEFAULT 0,
          nouvelleActivite TEXT,
          appuiSouhaite TEXT,
          typeFormation TEXT,
          besoinAppuiEquipement INTEGER DEFAULT 0,
          typeEquipement TEXT,
          createdAt TEXT,
          syncStatus TEXT,
          deviceId TEXT,
          FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
        )
      ''');

    if (oldVersion < 9) {
      // PAP updates
      await db.execute('ALTER TABLE paps ADD COLUMN email TEXT;');
      await db.execute('ALTER TABLE paps ADD COLUMN nomPrenomPersContacter TEXT;');
      await db.execute('ALTER TABLE paps ADD COLUMN telephonePersContacter TEXT;');
      await db.execute('ALTER TABLE paps ADD COLUMN photoPieceRecto TEXT;');
      await db.execute('ALTER TABLE paps ADD COLUMN photoPieceVerso TEXT;');
      await db.execute('ALTER TABLE paps ADD COLUMN photoPap TEXT;');

      // Menage updates
      await db.execute('ALTER TABLE menages ADD COLUMN situationSocialeMenage TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN nomPrenomMen TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN parenteMen TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN autreLienParente TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN telephoneMen TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN enfVulMenage INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN persAgeeVulMenage INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN handicapephysmentMenage INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN femGrossessMenage INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN orphelinMenage INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN femChefMenage INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN persMaladieMetaMenage INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN nbrePersVulnMenage INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN declarationOrgQuartier TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN statutAssociation TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN autreOrganisation TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN typeRelaMemOrg TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN avantageAssocOrg TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN indiqNbrEquip TEXT;');
      await db.execute('ALTER TABLE menages ADD COLUMN voiture INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN moto INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN velo INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN salon INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN television INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN radio INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN ordinateur INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN portable INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN cuisiniere INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN congelateur INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN fer INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN clim INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN machine INTEGER;');
      await db.execute('ALTER TABLE menages ADD COLUMN biblio INTEGER;');

      // Logement updates
      await db.execute('ALTER TABLE logements ADD COLUMN autreSanitaire TEXT;');
      await db.execute('ALTER TABLE logements ADD COLUMN srcCombustion TEXT;');
      await db.execute('ALTER TABLE logements ADD COLUMN autreSourceCombustion TEXT;');
      await db.execute('ALTER TABLE logements ADD COLUMN srcEau TEXT;');
      await db.execute('ALTER TABLE logements ADD COLUMN anneeUtilEau INTEGER;');
      await db.execute('ALTER TABLE logements ADD COLUMN distMoyDomEau REAL;');
      await db.execute('ALTER TABLE logements ADD COLUMN montantDepEau REAL;');
      await db.execute('ALTER TABLE logements ADD COLUMN principaleSrcEclair TEXT;');
      await db.execute('ALTER TABLE logements ADD COLUMN typeReseauElec TEXT;');
      await db.execute('ALTER TABLE logements ADD COLUMN autreTypeReseauElec TEXT;');
      await db.execute('ALTER TABLE logements ADD COLUMN anConReseauElec INTEGER;');
      await db.execute('ALTER TABLE logements ADD COLUMN montantDepConsoEnergie REAL;');
      await db.execute('ALTER TABLE logements ADD COLUMN periodeAnCoupure INTEGER;');

      // Sante updates
      await db.execute('ALTER TABLE santes ADD COLUMN autreTauxCouverture TEXT;');
      await db.execute('ALTER TABLE santes ADD COLUMN autreTypeSoin TEXT;');
      await db.execute('ALTER TABLE santes ADD COLUMN autreJustifTypeSoin TEXT;');

      // Activite updates
      await db.execute('ALTER TABLE activites ADD COLUMN situationEconoMenage TEXT;');
      await db.execute('ALTER TABLE activites ADD COLUMN autreActivitePrinc TEXT;');
      await db.execute('ALTER TABLE activites ADD COLUMN autreLieuTravail TEXT;');
      await db.execute('ALTER TABLE activites ADD COLUMN revenuMoyeActSeco REAL;');

      // Finance updates
      await db.execute('ALTER TABLE finances ADD COLUMN consomAlimentaire REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN logement REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN education REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN sante REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN habillement REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN transport REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN communication REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN entretienEquip REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN autreCharge REAL;');
      await db.execute('ALTER TABLE finances ADD COLUMN coutTotalChargeMenage REAL;');
      
      // Avis Projet
      await db.execute('ALTER TABLE avis_projets ADD COLUMN ouiRecommandation TEXT;');
      
      // Membres Menage
      await db.execute('ALTER TABLE membres_menage ADD COLUMN sitEmploiMembreMen TEXT;');
      await db.execute('ALTER TABLE membres_menage ADD COLUMN autreSituationEmploi TEXT;');

      // New Tables
      await db.execute('''
        CREATE TABLE biens_impactes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idPap TEXT,
          categorie TEXT,
          caracBienImpactes TEXT,
          proprioFonc TEXT,
          typeFoncier TEXT,
          typeLotissement TEXT,
          titrePropriete TEXT,
          autreTitreProp TEXT,
          numIlot INTEGER,
          numLot INTEGER,
          surfaceLotParcelle REAL,
          surfaceImpactee REAL,
          statutOccupation TEXT,
          modeAcquisition TEXT,
          autreModeAcqFonc TEXT,
          anneeAcqFonc INTEGER,
          montantAcqFonc REAL,
          loyerMens TEXT,
          loyerMensPercuBail TEXT,
          nomPropEnLocationFonc TEXT,
          contactPropEnLocation TEXT,
          photoDocFoncier TEXT,
          photoDocFoncierUrl TEXT,
          numBati INTEGER,
          identifiantBati TEXT,
          typeConstruction TEXT,
          statutOccBati TEXT,
          modeAcqBati TEXT,
          nbreNiveau INTEGER,
          nbreAppart INTEGER,
          materiauConst TEXT,
          partieBatiImpact TEXT,
          niveauAch TEXT,
          nbrePieceBati INTEGER,
          typeComodite TEXT,
          typeComoditeassainissementAutonome TEXT,
          typeComoditeassainissementCollectif TEXT,
          typeComoditeeauPotable TEXT,
          typeComoditeelectricite TEXT,
          typeComoditegroupeElectrogene TEXT,
          typeComoditeinstallationEnergieSolaire TEXT,
          typeComoditeinstallationInternet TEXT,
          typeComoditepuits TEXT,
          typeComoditetelephone TEXT,
          typeComoditeautreComodite TEXT,
          modeEvacEauUsees TEXT,
          autreGestEauxUsees TEXT,
          modeRamOrdures TEXT,
          autreGestRamasOrdure TEXT,
          autreFctBati TEXT,
          anneeConstBati INTEGER,
          coutConstBati REAL,
          loyerMensPaye TEXT,
          loyerMensPercu TEXT,
          photoQuittance TEXT,
          photoQuittanceUrl TEXT,
          nomPropEnLocation TEXT,
          numeroPropEnLocationBati INTEGER,
          isActiviteFormelle INTEGER,
          typeActExer TEXT,
          autreActImpactee TEXT,
          lieuExcerActi TEXT,
          anneeInstallSite INTEGER,
          lieuPrincApprovi TEXT,
          origineClient TEXT,
          revenuMensuelTire REAL,
          totalSalEmp TEXT,
          isPayeTaxe INTEGER,
          lesquellesTaxes TEXT,
          autreTaxe TEXT,
          freqPayeTaxe TEXT,
          montantPayeActivComm REAL,
          denominatiEntreprise TEXT,
          presenceEnseigne TEXT,
          formJuridiq TEXT,
          numRccm INTEGER,
          ncc TEXT,
          regimeImposition TEXT,
          situationGeo TEXT,
          produitService TEXT,
          dateCreaEntre TEXT,
          totalSalaireEmployeEntrep TEXT,
          dateDebutActi TEXT,
          chifAffaiMensuel TEXT,
          localEntDetruit TEXT,
          localPartDetruit TEXT,
          travauxImpact TEXT,
          nbrePersTravailleur INTEGER,
          imgActivite TEXT,
          imgActiviteUrl TEXT,
          typeCulture TEXT,
          ageCulture INTEGER,
          statuFoncAgricole TEXT,
          modeAcquisitionFonc TEXT,
          autreModeAcquisFonc TEXT,
          supParcelleAgricoleOuPied TEXT,
          supImpacteAgric TEXT,
          maturiteSaisonRecolt TEXT,
          rendCultuDernRecolte TEXT,
          revenuCommercialisation REAL,
          destinProduit TEXT,
          lieuCommercialisation TEXT,
          autreLieuCommerce TEXT,
          montantCommercialisation REAL,
          isParcelle INTEGER,
          superfParcelDispo TEXT,
          nbrEmplyeAgricole INTEGER,
          totalSalaireEmployeAgricole TEXT,
          denomiEquipCollec TEXT,
          statuEquipCollec TEXT,
          autreStatutEquipement TEXT,
          caractEquipCollec TEXT,
          autreCaracEquipement TEXT,
          anneeInstSite INTEGER,
          nbrePersFreq INTEGER,
          lieuProvPers TEXT,
          nbrEmplyeEquip INTEGER,
          revenuMensuelEquipLucratif REAL,
          preferenceIndemn TEXT,
          continuerMemActivite TEXT,
          ouiAppuiSouhaite TEXT,
          autreAppuiSouhaite TEXT,
          nonAppuiNvlleActiv TEXT,
          isConnaisance INTEGER,
          appuiDuProj TEXT,
          domaineFormation TEXT,
          listerTypeIntrant TEXT,
          photoRecu TEXT,
          photoRecuUrl TEXT,
          createdAt TEXT,
          syncStatus TEXT,
          deviceId TEXT,
          FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE employes_commercial(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idPap TEXT,
          employeurActCom TEXT,
          nomPrenomEmpActCom TEXT,
          typePieceEmp TEXT,
          numPieceEmpActCom TEXT,
          lieuResiEmpActCom TEXT,
          contactEmpActCom TEXT,
          salaireEmpActCom REAL,
          createdAt TEXT,
          syncStatus TEXT,
          deviceId TEXT,
          FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE photos_batiments(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idPap TEXT,
          photoBati TEXT,
          photoBatiUrl TEXT,
          createdAt TEXT,
          syncStatus TEXT,
          deviceId TEXT,
          FOREIGN KEY (idPap) REFERENCES paps (identifiantPap) ON DELETE CASCADE
        )
      ''');
    }
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
        prenomPap TEXT,
        surnom TEXT,
        nomProprio TEXT,
        dateNaissance TEXT,
        genre TEXT,
        nationalite TEXT,
        ethnie TEXT,
        niveauInstruc TEXT,
        typePiece TEXT,
        numPiece TEXT,
        situationMat TEXT,
        religion TEXT,
        anneeInst INTEGER,
        appCulture TEXT,
        motifInstall TEXT,
        lieuResidenceAct TEXT,
        telephone1 TEXT,
        
        telephone2 TEXT,
        email TEXT,
        nomPrenomPersContacter TEXT,
        telephonePersContacter TEXT,
        photoPieceRecto TEXT,
        photoPieceVerso TEXT,
        photoPap TEXT,

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
        typeMenage TEXT,
        appartenanceOrg TEXT,
        isPersonneVulMenage INTEGER,
        typeSanitaire TEXT,
        isMembreOrganisation INTEGER DEFAULT 0,
        typeOrganisation TEXT,
        toucheRetraite INTEGER DEFAULT 0,
        
        montantRetraite REAL,
        situationSocialeMenage TEXT,
        nomPrenomMen TEXT,
        parenteMen TEXT,
        autreLienParente TEXT,
        telephoneMen TEXT,
        enfVulMenage INTEGER,
        persAgeeVulMenage INTEGER,
        handicapephysmentMenage INTEGER,
        femGrossessMenage INTEGER,
        orphelinMenage INTEGER,
        femChefMenage INTEGER,
        persMaladieMetaMenage INTEGER,
        nbrePersVulnMenage INTEGER,
        declarationOrgQuartier TEXT,
        statutAssociation TEXT,
        autreOrganisation TEXT,
        typeRelaMemOrg TEXT,
        avantageAssocOrg TEXT,
        indiqNbrEquip TEXT,
        voiture INTEGER,
        moto INTEGER,
        velo INTEGER,
        salon INTEGER,
        television INTEGER,
        radio INTEGER,
        ordinateur INTEGER,
        portable INTEGER,
        cuisiniere INTEGER,
        congelateur INTEGER,
        fer INTEGER,
        clim INTEGER,
        machine INTEGER,
        biblio INTEGER,

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
        revenuMoyeActPrinMauvaise REAL,
        revenuMoyeActPrinBonne REAL,
        statutActivite TEXT,
        nbMoisActivite INTEGER,
        transferArg INTEGER,
        lieuTravail TEXT,
        presenceActivSecondMenage INTEGER,
        activiteSecondaire TEXT,
        revenuCumul REAL,
        isParcelleHorsEmprise INTEGER,
        aEmployes INTEGER DEFAULT 0,
        nbEmployes INTEGER,
        payeTaxes INTEGER DEFAULT 0,
        quellesTaxes TEXT,
        
        frequenceTaxes TEXT,
        situationEconoMenage TEXT,
        autreActivitePrinc TEXT,
        autreLieuTravail TEXT,
        revenuMoyeActSeco REAL,

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
        autreTauxCouverture TEXT,
        autreTypeSoin TEXT,
        autreJustifTypeSoin TEXT,

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
        ouiRecommandation TEXT,

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
        sourcePrincipaleRevenus TEXT,
        postesDepenses TEXT,
        aChargeHorsMenage INTEGER DEFAULT 0,
        nbTransfertsEnvoyes INTEGER,
        
        montantTransfertsEnvoyes REAL,
        consomAlimentaire REAL,
        logement REAL,
        education REAL,
        sante REAL,
        habillement REAL,
        transport REAL,
        communication REAL,
        entretienEquip REAL,
        autreCharge REAL,
        coutTotalChargeMenage REAL,

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
        autreSanitaire TEXT,
        srcCombustion TEXT,
        autreSourceCombustion TEXT,
        srcEau TEXT,
        anneeUtilEau INTEGER,
        distMoyDomEau REAL,
        montantDepEau REAL,
        principaleSrcEclair TEXT,
        typeReseauElec TEXT,
        autreTypeReseauElec TEXT,
        anConReseauElec INTEGER,
        montantDepConsoEnergie REAL,
        periodeAnCoupure INTEGER,

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
  
  Future<int> insertBienImpacte(BienImpacte bien) async {
    final db = await database;
    return await db.insert('biens_impactes', bien.toMap());
  }

  
  Future<List<Map<String, dynamic>>> getBiensImpactes(String idPap) async {
    final db = await database;
    return await db.query('biens_impactes', where: 'idPap = ?', whereArgs: [idPap]);
  }

  Future<int> deleteBienImpacte(int id) async {
    final db = await database;
    return await db.delete('biens_impactes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateBienImpacte(BienImpacte bien) async {
    final db = await database;
    return await db.update('biens_impactes', bien.toMap(),
        where: 'id = ?', whereArgs: [bien.id]);
  }

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

  // --- CRUD MEMBRES MENAGE ---
  Future<int> insertMembreMenage(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('membres_menage', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getMembresMenageByPap(String idPap) async {
    final db = await database;
    return await db.query('membres_menage', where: 'idPap = ?', whereArgs: [idPap]);
  }

  Future<int> deleteMembreMenage(int idMembre) async {
    final db = await database;
    return await db.delete('membres_menage', where: 'idMembre = ?', whereArgs: [idMembre]);
  }

  // --- CRUD PLAN RESTAURATION ---
  Future<int> insertPlanRestauration(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('plans_restauration', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getPlanRestaurationByPap(String idPap) async {
    final db = await database;
    final maps = await db.query('plans_restauration', where: 'idPap = ?', whereArgs: [idPap]);
    return maps.isNotEmpty ? maps.first : null;
  }
}
