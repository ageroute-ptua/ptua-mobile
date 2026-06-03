class Menage {
  final int? idMenage;
  final String idPap;
  final int? nbrePersonnesMenage;
  final bool? isChefMen;
  final String? appartenanceOrg;
  final bool? isPersonneVulMenage;
  final String? typeSanitaire;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;

  Menage({
    this.idMenage,
    required this.idPap,
    this.nbrePersonnesMenage,
    this.isChefMen,
    this.appartenanceOrg,
    this.isPersonneVulMenage,
    this.typeSanitaire,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory Menage.fromMap(Map<String, dynamic> map) {
    return Menage(
      idMenage: map['idMenage'],
      idPap: map['idPap'],
      nbrePersonnesMenage: map['nbrePersonnesMenage'],
      isChefMen: map['isChefMen'] == 1,
      appartenanceOrg: map['appartenanceOrg'],
      isPersonneVulMenage: map['isPersonneVulMenage'] == 1,
      typeSanitaire: map['typeSanitaire'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMenage': idMenage,
      'idPap': idPap,
      'nbrePersonnesMenage': nbrePersonnesMenage,
      'isChefMen': isChefMen == true ? 1 : 0,
      'appartenanceOrg': appartenanceOrg,
      'isPersonneVulMenage': isPersonneVulMenage == true ? 1 : 0,
      'typeSanitaire': typeSanitaire,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }

  Menage copyWith({String? syncStatus}) {
    return Menage(
      idMenage: idMenage,
      idPap: idPap,
      nbrePersonnesMenage: nbrePersonnesMenage,
      isChefMen: isChefMen,
      appartenanceOrg: appartenanceOrg,
      isPersonneVulMenage: isPersonneVulMenage,
      typeSanitaire: typeSanitaire,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId,
    );
  }
}
