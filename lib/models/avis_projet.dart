class AvisProjet {
  final int? idAvis;
  final String idPap;
  final bool? isAvezCraintes;
  final bool? isAvezAttentes;
  final bool? isRecommandation;
  final String? penseePrj;
  final String? ouiCraintes;
  final String? informationProjet;
  final String? sourceInfor;
  final String? prjInfoRecues;
  final String? justiAvis;
  final String? ouiAttentes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;

  AvisProjet({
    this.idAvis,
    required this.idPap,
    this.isAvezCraintes,
    this.isAvezAttentes,
    this.isRecommandation,
    this.penseePrj,
    this.ouiCraintes,
    this.informationProjet,
    this.sourceInfor,
    this.prjInfoRecues,
    this.justiAvis,
    this.ouiAttentes,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory AvisProjet.fromMap(Map<String, dynamic> map) {
    return AvisProjet(
      idAvis: map['idAvis'],
      idPap: map['idPap'],
      isAvezCraintes: map['isAvezCraintes'] == 1,
      isAvezAttentes: map['isAvezAttentes'] == 1,
      isRecommandation: map['isRecommandation'] == 1,
      penseePrj: map['penseePrj'],
      ouiCraintes: map['ouiCraintes'],
      informationProjet: map['informationProjet'],
      sourceInfor: map['sourceInfor'],
      prjInfoRecues: map['prjInfoRecues'],
      justiAvis: map['justiAvis'],
      ouiAttentes: map['ouiAttentes'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idAvis': idAvis,
      'idPap': idPap,
      'isAvezCraintes': isAvezCraintes == true ? 1 : 0,
      'isAvezAttentes': isAvezAttentes == true ? 1 : 0,
      'isRecommandation': isRecommandation == true ? 1 : 0,
      'penseePrj': penseePrj,
      'ouiCraintes': ouiCraintes,
      'informationProjet': informationProjet,
      'sourceInfor': sourceInfor,
      'prjInfoRecues': prjInfoRecues,
      'justiAvis': justiAvis,
      'ouiAttentes': ouiAttentes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }

  AvisProjet copyWith({String? syncStatus}) {
    return AvisProjet(
      idAvis: idAvis,
      idPap: idPap,
      isAvezCraintes: isAvezCraintes,
      isAvezAttentes: isAvezAttentes,
      isRecommandation: isRecommandation,
      penseePrj: penseePrj,
      ouiCraintes: ouiCraintes,
      informationProjet: informationProjet,
      sourceInfor: sourceInfor,
      prjInfoRecues: prjInfoRecues,
      justiAvis: justiAvis,
      ouiAttentes: ouiAttentes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId,
    );
  }
}
