class Activite {
  final int? idActivite;
  final String idPap;
  final String? activitePrincipMenage;
  final double? revenuMoyeActPrinMauvaise;
  final double? revenuMoyeActPrinBonne;
  final String? statutActivite;
  final int? nbMoisActivite;
  final bool? transferArg;
  final String? lieuTravail;
  final bool? presenceActivSecondMenage;
  final String? activiteSecondaire;
  final double? revenuCumul;
  final bool? isParcelleHorsEmprise;
  final bool? aEmployes;
  final int? nbEmployes;
  final bool? payeTaxes;
  final String? quellesTaxes;
  final String? frequenceTaxes;
  final String? situationEconoMenage;
  final String? autreActivitePrinc;
  final String? autreLieuTravail;
  final double? revenuMoyeActSeco;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String syncStatus;
  final String? deviceId;

  Activite({
    this.idActivite,
    required this.idPap,
    this.activitePrincipMenage,
    this.revenuMoyeActPrinMauvaise,
    this.revenuMoyeActPrinBonne,
    this.statutActivite,
    this.nbMoisActivite,
    this.transferArg,
    this.lieuTravail,
    this.presenceActivSecondMenage,
    this.activiteSecondaire,
    this.revenuCumul,
    this.isParcelleHorsEmprise,
    this.aEmployes,
    this.nbEmployes,
    this.payeTaxes,
    this.quellesTaxes,
    this.frequenceTaxes,
    this.situationEconoMenage,
    this.autreActivitePrinc,
    this.autreLieuTravail,
    this.revenuMoyeActSeco,
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
      revenuMoyeActPrinMauvaise: map['revenuMoyeActPrinMauvaise']?.toDouble(),
      revenuMoyeActPrinBonne: map['revenuMoyeActPrinBonne']?.toDouble(),
      statutActivite: map['statutActivite'],
      nbMoisActivite: map['nbMoisActivite'],
      transferArg: map['transferArg'] == 1,
      lieuTravail: map['lieuTravail'],
      presenceActivSecondMenage: map['presenceActivSecondMenage'] == 1,
      activiteSecondaire: map['activiteSecondaire'],
      revenuCumul: map['revenuCumul']?.toDouble(),
      isParcelleHorsEmprise: map['isParcelleHorsEmprise'] == 1,
      aEmployes: map['aEmployes'] == 1,
      nbEmployes: map['nbEmployes'],
      payeTaxes: map['payeTaxes'] == 1,
      quellesTaxes: map['quellesTaxes'],
      frequenceTaxes: map['frequenceTaxes'],
      situationEconoMenage: map['situationEconoMenage'],
      autreActivitePrinc: map['autreActivitePrinc'],
      autreLieuTravail: map['autreLieuTravail'],
      revenuMoyeActSeco: map['revenuMoyeActSeco']?.toDouble(),
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
      'revenuMoyeActPrinMauvaise': revenuMoyeActPrinMauvaise,
      'revenuMoyeActPrinBonne': revenuMoyeActPrinBonne,
      'statutActivite': statutActivite,
      'nbMoisActivite': nbMoisActivite,
      'transferArg': transferArg == true ? 1 : 0,
      'lieuTravail': lieuTravail,
      'presenceActivSecondMenage': presenceActivSecondMenage == true ? 1 : 0,
      'activiteSecondaire': activiteSecondaire,
      'revenuCumul': revenuCumul,
      'isParcelleHorsEmprise': isParcelleHorsEmprise == true ? 1 : 0,
      'aEmployes': aEmployes == true ? 1 : 0,
      'nbEmployes': nbEmployes,
      'payeTaxes': payeTaxes == true ? 1 : 0,
      'quellesTaxes': quellesTaxes,
      'frequenceTaxes': frequenceTaxes,
      'situationEconoMenage': situationEconoMenage,
      'autreActivitePrinc': autreActivitePrinc,
      'autreLieuTravail': autreLieuTravail,
      'revenuMoyeActSeco': revenuMoyeActSeco,
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
      revenuMoyeActPrinMauvaise: revenuMoyeActPrinMauvaise,
      revenuMoyeActPrinBonne: revenuMoyeActPrinBonne,
      statutActivite: statutActivite,
      nbMoisActivite: nbMoisActivite,
      transferArg: transferArg,
      lieuTravail: lieuTravail,
      presenceActivSecondMenage: presenceActivSecondMenage,
      activiteSecondaire: activiteSecondaire,
      revenuCumul: revenuCumul,
      isParcelleHorsEmprise: isParcelleHorsEmprise,
      aEmployes: aEmployes,
      nbEmployes: nbEmployes,
      payeTaxes: payeTaxes,
      quellesTaxes: quellesTaxes,
      frequenceTaxes: frequenceTaxes,
      situationEconoMenage: situationEconoMenage,
      autreActivitePrinc: autreActivitePrinc,
      autreLieuTravail: autreLieuTravail,
      revenuMoyeActSeco: revenuMoyeActSeco,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId,
    );
  }
}
