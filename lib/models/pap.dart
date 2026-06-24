class Pap {
  final int? id; // SQLite ID
  final String? idEnquete; // Foreign key to Enquete
  final String? idPapMetier;
  final String? identifiantPap;
  final String nomPap;
  final String? prenomPap;
  final String? surnom;
  final String? religion;
  final String? nomProprio;
  final DateTime? dateNaissance;
  final String? genre;
  final String? nationalite;
  final String? ethnie;
  final String? niveauInstruc;
  final String? typePiece;
  final String? numPiece;
  final String? situationMat;
  final int? anneeInst;
  final String? appCulture;
  final String? motifInstall;
  final String? lieuResidenceAct;
  final String? telephone1;
  final String? telephone2;
  final String? email;
  final String? nomPrenomPersContacter;
  final String? telephonePersContacter;
  final String? photoPieceRecto;
  final String? photoPieceVerso;
  final String? photoPap;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;
  final String? statutBien;

  Pap({
    this.id,
    required this.idEnquete,
    this.idPapMetier,
    this.identifiantPap,
    required this.nomPap,
    this.prenomPap,
    this.surnom,
    this.religion,
    this.nomProprio,
    this.dateNaissance,
    this.genre,
    this.nationalite,
    this.ethnie,
    this.niveauInstruc,
    this.typePiece,
    this.numPiece,
    this.situationMat,
    this.anneeInst,
    this.appCulture,
    this.motifInstall,
    this.lieuResidenceAct,
    this.telephone1,
    this.telephone2,
    this.email,
    this.nomPrenomPersContacter,
    this.telephonePersContacter,
    this.photoPieceRecto,
    this.photoPieceVerso,
    this.photoPap,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
    this.deviceId,
    this.statutBien,
  });

  factory Pap.fromMap(Map<String, dynamic> map) {
    return Pap(
      id: map['id'],
      idEnquete: map['idEnquete'],
      idPapMetier: map['idPapMetier'],
      identifiantPap: map['identifiantPap'],
      nomPap: map['nomPap'],
      prenomPap: map['prenomPap'],
      surnom: map['surnom'],
      religion: map['religion'],
      nomProprio: map['nomProprio'],
      dateNaissance: map['dateNaissance'] != null ? DateTime.parse(map['dateNaissance']) : null,
      genre: map['genre'],
      nationalite: map['nationalite'],
      ethnie: map['ethnie'],
      niveauInstruc: map['niveauInstruc'],
      typePiece: map['typePiece'],
      numPiece: map['numPiece'],
      situationMat: map['situationMat'],
      anneeInst: map['anneeInst'],
      appCulture: map['appCulture'],
      motifInstall: map['motifInstall'],
      lieuResidenceAct: map['lieuResidenceAct'],
      telephone1: map['telephone1'],
      telephone2: map['telephone2'],
      email: map['email'],
      nomPrenomPersContacter: map['nomPrenomPersContacter'],
      telephonePersContacter: map['telephonePersContacter'],
      photoPieceRecto: map['photoPieceRecto'],
      photoPieceVerso: map['photoPieceVerso'],
      photoPap: map['photoPap'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
      statutBien: map['statutBien'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idEnquete': idEnquete,
      'idPapMetier': idPapMetier,
      'identifiantPap': identifiantPap,
      'nomPap': nomPap,
      'prenomPap': prenomPap,
      'surnom': surnom,
      'religion': religion,
      'nomProprio': nomProprio,
      'dateNaissance': dateNaissance?.toIso8601String(),
      'genre': genre,
      'nationalite': nationalite,
      'ethnie': ethnie,
      'niveauInstruc': niveauInstruc,
      'typePiece': typePiece,
      'numPiece': numPiece,
      'situationMat': situationMat,
      'anneeInst': anneeInst,
      'appCulture': appCulture,
      'motifInstall': motifInstall,
      'lieuResidenceAct': lieuResidenceAct,
      'telephone1': telephone1,
      'telephone2': telephone2,
      'email': email,
      'nomPrenomPersContacter': nomPrenomPersContacter,
      'telephonePersContacter': telephonePersContacter,
      'photoPieceRecto': photoPieceRecto,
      'photoPieceVerso': photoPieceVerso,
      'photoPap': photoPap,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
      'statutBien': statutBien,
    };
  }

  Pap copyWith({
    String? syncStatus,
    String? deviceId,
    String? statutBien,
  }) {
    return Pap(
      id: id,
      idEnquete: idEnquete,
      idPapMetier: idPapMetier,
      identifiantPap: identifiantPap,
      nomPap: nomPap,
      prenomPap: prenomPap,
      surnom: surnom,
      religion: religion,
      nomProprio: nomProprio,
      dateNaissance: dateNaissance,
      genre: genre,
      nationalite: nationalite,
      ethnie: ethnie,
      niveauInstruc: niveauInstruc,
      typePiece: typePiece,
      numPiece: numPiece,
      situationMat: situationMat,
      anneeInst: anneeInst,
      appCulture: appCulture,
      motifInstall: motifInstall,
      lieuResidenceAct: lieuResidenceAct,
      telephone1: telephone1,
      telephone2: telephone2,
      email: email,
      nomPrenomPersContacter: nomPrenomPersContacter,
      telephonePersContacter: telephonePersContacter,
      photoPieceRecto: photoPieceRecto,
      photoPieceVerso: photoPieceVerso,
      photoPap: photoPap,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      statutBien: statutBien ?? this.statutBien,
    );
  }
}
