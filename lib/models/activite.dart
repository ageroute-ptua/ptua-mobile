class Activite {
  final int? idActivite;
  final String idPap;
  final String? activitePrincipMenage;
  final double? revenuMoyeActPrin;
  final bool? transferArg;
  final String? lieuTravail;
  final bool? presenceActivSecondMenage;
  final double? revenuCumul;
  final bool? isParcelleHorsEmprise;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;

  Activite({
    this.idActivite,
    required this.idPap,
    this.activitePrincipMenage,
    this.revenuMoyeActPrin,
    this.transferArg,
    this.lieuTravail,
    this.presenceActivSecondMenage,
    this.revenuCumul,
    this.isParcelleHorsEmprise,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory Activite.fromMap(Map<String, dynamic> map) {
    return Activite(
      idActivite: map['idActivite'],
      idPap: map['idPap'],
      activitePrincipMenage: map['activitePrincipMenage'],
      revenuMoyeActPrin: map['revenuMoyeActPrin'],
      transferArg: map['transferArg'] == 1,
      lieuTravail: map['lieuTravail'],
      presenceActivSecondMenage: map['presenceActivSecondMenage'] == 1,
      revenuCumul: map['revenuCumul'],
      isParcelleHorsEmprise: map['isParcelleHorsEmprise'] == 1,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idActivite': idActivite,
      'idPap': idPap,
      'activitePrincipMenage': activitePrincipMenage,
      'revenuMoyeActPrin': revenuMoyeActPrin,
      'transferArg': transferArg == true ? 1 : 0,
      'lieuTravail': lieuTravail,
      'presenceActivSecondMenage': presenceActivSecondMenage == true ? 1 : 0,
      'revenuCumul': revenuCumul,
      'isParcelleHorsEmprise': isParcelleHorsEmprise == true ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }

  Activite copyWith({String? syncStatus}) {
    return Activite(
      idActivite: idActivite,
      idPap: idPap,
      activitePrincipMenage: activitePrincipMenage,
      revenuMoyeActPrin: revenuMoyeActPrin,
      transferArg: transferArg,
      lieuTravail: lieuTravail,
      presenceActivSecondMenage: presenceActivSecondMenage,
      revenuCumul: revenuCumul,
      isParcelleHorsEmprise: isParcelleHorsEmprise,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId,
    );
  }
}
