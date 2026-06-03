class Education {
  final int? idEducation;
  final String idPap;
  final int? nbrEnf0_14;
  final int? nbrJeun15_59;
  final int? nbrPersAge60;
  final int? maternelle;
  final int? primaire;
  final int? secondaire;
  final int? superieur;
  final int? nbEnftScolarise;
  final int? distanceDomEcolePrim;
  final int? distanceDomEcoleSec;
  final int? nbrEnfScolarisable;
  final int? nbrEnfScolarise7_18;
  final int? francoArabe;
  final int? nbrElevMangCantine;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;

  Education({
    this.idEducation,
    required this.idPap,
    this.nbrEnf0_14,
    this.nbrJeun15_59,
    this.nbrPersAge60,
    this.maternelle,
    this.primaire,
    this.secondaire,
    this.superieur,
    this.nbEnftScolarise,
    this.distanceDomEcolePrim,
    this.distanceDomEcoleSec,
    this.nbrEnfScolarisable,
    this.nbrEnfScolarise7_18,
    this.francoArabe,
    this.nbrElevMangCantine,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      idEducation: map['idEducation'],
      idPap: map['idPap'],
      nbrEnf0_14: map['nbrEnf0_14'],
      nbrJeun15_59: map['nbrJeun15_59'],
      nbrPersAge60: map['nbrPersAge60'],
      maternelle: map['maternelle'],
      primaire: map['primaire'],
      secondaire: map['secondaire'],
      superieur: map['superieur'],
      nbEnftScolarise: map['nbEnftScolarise'],
      distanceDomEcolePrim: map['distanceDomEcolePrim'],
      distanceDomEcoleSec: map['distanceDomEcoleSec'],
      nbrEnfScolarisable: map['nbrEnfScolarisable'],
      nbrEnfScolarise7_18: map['nbrEnfScolarise7_18'],
      francoArabe: map['francoArabe'],
      nbrElevMangCantine: map['nbrElevMangCantine'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idEducation': idEducation,
      'idPap': idPap,
      'nbrEnf0_14': nbrEnf0_14,
      'nbrJeun15_59': nbrJeun15_59,
      'nbrPersAge60': nbrPersAge60,
      'maternelle': maternelle,
      'primaire': primaire,
      'secondaire': secondaire,
      'superieur': superieur,
      'nbEnftScolarise': nbEnftScolarise,
      'distanceDomEcolePrim': distanceDomEcolePrim,
      'distanceDomEcoleSec': distanceDomEcoleSec,
      'nbrEnfScolarisable': nbrEnfScolarisable,
      'nbrEnfScolarise7_18': nbrEnfScolarise7_18,
      'francoArabe': francoArabe,
      'nbrElevMangCantine': nbrElevMangCantine,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }

  Education copyWith({String? syncStatus}) {
    return Education(
      idEducation: idEducation,
      idPap: idPap,
      nbrEnf0_14: nbrEnf0_14,
      nbrJeun15_59: nbrJeun15_59,
      nbrPersAge60: nbrPersAge60,
      maternelle: maternelle,
      primaire: primaire,
      secondaire: secondaire,
      superieur: superieur,
      nbEnftScolarise: nbEnftScolarise,
      distanceDomEcolePrim: distanceDomEcolePrim,
      distanceDomEcoleSec: distanceDomEcoleSec,
      nbrEnfScolarisable: nbrEnfScolarisable,
      nbrEnfScolarise7_18: nbrEnfScolarise7_18,
      francoArabe: francoArabe,
      nbrElevMangCantine: nbrElevMangCantine,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId,
    );
  }
}
