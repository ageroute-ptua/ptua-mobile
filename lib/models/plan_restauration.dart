class PlanRestauration {
  final int? idPlan;
  final String idPap;
  final String souhaitRestauration;
  final String? typeCompensation;
  final bool? continuerActivite;
  final String? nouvelleActivite;
  final String? appuiSouhaite;
  final String? typeFormation;
  final bool? besoinAppuiEquipement;
  final String? typeEquipement;
  final DateTime? createdAt;
  final String syncStatus;
  final String? deviceId;

  PlanRestauration({
    this.idPlan,
    required this.idPap,
    required this.souhaitRestauration,
    this.typeCompensation,
    this.continuerActivite,
    this.nouvelleActivite,
    this.appuiSouhaite,
    this.typeFormation,
    this.besoinAppuiEquipement,
    this.typeEquipement,
    this.createdAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory PlanRestauration.fromMap(Map<String, dynamic> map) {
    return PlanRestauration(
      idPlan: map['idPlan'],
      idPap: map['idPap'],
      souhaitRestauration: map['souhaitRestauration'],
      typeCompensation: map['typeCompensation'],
      continuerActivite: map['continuerActivite'] == 1,
      nouvelleActivite: map['nouvelleActivite'],
      appuiSouhaite: map['appuiSouhaite'],
      typeFormation: map['typeFormation'],
      besoinAppuiEquipement: map['besoinAppuiEquipement'] == 1,
      typeEquipement: map['typeEquipement'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPlan': idPlan,
      'idPap': idPap,
      'souhaitRestauration': souhaitRestauration,
      'typeCompensation': typeCompensation,
      'continuerActivite': continuerActivite == true ? 1 : 0,
      'nouvelleActivite': nouvelleActivite,
      'appuiSouhaite': appuiSouhaite,
      'typeFormation': typeFormation,
      'besoinAppuiEquipement': besoinAppuiEquipement == true ? 1 : 0,
      'typeEquipement': typeEquipement,
      'createdAt': createdAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }
}
