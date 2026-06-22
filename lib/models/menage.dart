class Menage {
  final int? idMenage;
  final String idPap;
  final int? nbrePersonnesMenage;
  final bool? isChefMen;
  final String? typeMenage;
  final String? appartenanceOrg;
  final bool? isPersonneVulMenage;
  final String? typeSanitaire;
  final bool? isMembreOrganisation;
  final String? typeOrganisation;
  final bool? toucheRetraite;
  final double? montantRetraite;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;

  Menage({
    this.idMenage,
    required this.idPap,
    this.nbrePersonnesMenage,
    this.isChefMen,
    this.typeMenage,
    this.appartenanceOrg,
    this.isPersonneVulMenage,
    this.typeSanitaire,
    this.isMembreOrganisation,
    this.typeOrganisation,
    this.toucheRetraite,
    this.montantRetraite,
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
      typeMenage: map['typeMenage'],
      appartenanceOrg: map['appartenanceOrg'],
      isPersonneVulMenage: map['isPersonneVulMenage'] == 1,
      typeSanitaire: map['typeSanitaire'],
      isMembreOrganisation: map['isMembreOrganisation'] == 1,
      typeOrganisation: map['typeOrganisation'],
      toucheRetraite: map['toucheRetraite'] == 1,
      montantRetraite: map['montantRetraite']?.toDouble(),
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
      'typeMenage': typeMenage,
      'appartenanceOrg': appartenanceOrg,
      'isPersonneVulMenage': isPersonneVulMenage == true ? 1 : 0,
      'typeSanitaire': typeSanitaire,
      'isMembreOrganisation': isMembreOrganisation == true ? 1 : 0,
      'typeOrganisation': typeOrganisation,
      'toucheRetraite': toucheRetraite == true ? 1 : 0,
      'montantRetraite': montantRetraite,
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
      typeMenage: typeMenage,
      appartenanceOrg: appartenanceOrg,
      isPersonneVulMenage: isPersonneVulMenage,
      typeSanitaire: typeSanitaire,
      isMembreOrganisation: isMembreOrganisation,
      typeOrganisation: typeOrganisation,
      toucheRetraite: toucheRetraite,
      montantRetraite: montantRetraite,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId,
    );
  }
}
