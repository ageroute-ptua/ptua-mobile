class MembreMenage {
  final int? idMembre;
  final String idPap;
  final String nomPrenom;
  final String lienChefMenage;
  final bool estEnfantMoins5;
  final int? age;
  final bool estPap;
  final String? numPiecePap;
  final String? telephonePap;
  final String? sexe;
  final String? nationalite;
  final String? ethnie;
  final String? handicap;
  final bool? saitLireEcrire;
  final String? langueLecture;
  final String? niveauEtude;
  final bool? vaAEcole;
  final bool? travaille;
  final String? activitePrincipale;
  final String? statutActivite;
  final int? nbMoisActivite;
  final double? revenuMensuel;
  final String? activiteSecondaire;
  final String? statutActiviteSec;
  final int? nbMoisActiviteSec;
  final double? revenuMensuelSec;
  final String? sitEmploiMembreMen;
  final String? autreSituationEmploi;
  final DateTime? createdAt;
  final String syncStatus;
  final String? deviceId;

  MembreMenage({
    this.idMembre,
    required this.idPap,
    required this.nomPrenom,
    required this.lienChefMenage,
    required this.estEnfantMoins5,
    this.age,
    required this.estPap,
    this.numPiecePap,
    this.telephonePap,
    this.sexe,
    this.nationalite,
    this.ethnie,
    this.handicap,
    this.saitLireEcrire,
    this.langueLecture,
    this.niveauEtude,
    this.vaAEcole,
    this.travaille,
    this.activitePrincipale,
    this.statutActivite,
    this.nbMoisActivite,
    this.revenuMensuel,
    this.activiteSecondaire,
    this.statutActiviteSec,
    this.nbMoisActiviteSec,
    this.revenuMensuelSec,
    this.sitEmploiMembreMen,
    this.autreSituationEmploi,
    this.createdAt,
    this.syncStatus = 'local',
    this.deviceId,
  });

  factory MembreMenage.fromMap(Map<String, dynamic> map) {
    return MembreMenage(
      idMembre: map['idMembre'],
      idPap: map['idPap'],
      nomPrenom: map['nomPrenom'],
      lienChefMenage: map['lienChefMenage'],
      estEnfantMoins5: map['estEnfantMoins5'] == 1,
      age: map['age'],
      estPap: map['estPap'] == 1,
      numPiecePap: map['numPiecePap'],
      telephonePap: map['telephonePap'],
      sexe: map['sexe'],
      nationalite: map['nationalite'],
      ethnie: map['ethnie'],
      handicap: map['handicap'],
      saitLireEcrire: map['saitLireEcrire'] == 1,
      langueLecture: map['langueLecture'],
      niveauEtude: map['niveauEtude'],
      vaAEcole: map['vaAEcole'] == 1,
      travaille: map['travaille'] == 1,
      activitePrincipale: map['activitePrincipale'],
      statutActivite: map['statutActivite'],
      nbMoisActivite: map['nbMoisActivite'],
      revenuMensuel: map['revenuMensuel']?.toDouble(),
      activiteSecondaire: map['activiteSecondaire'],
      statutActiviteSec: map['statutActiviteSec'],
      nbMoisActiviteSec: map['nbMoisActiviteSec'],
      revenuMensuelSec: map['revenuMensuelSec']?.toDouble(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      syncStatus: map['syncStatus'] ?? 'local',
      deviceId: map['deviceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMembre': idMembre,
      'idPap': idPap,
      'nomPrenom': nomPrenom,
      'lienChefMenage': lienChefMenage,
      'estEnfantMoins5': estEnfantMoins5 ? 1 : 0,
      'age': age,
      'estPap': estPap ? 1 : 0,
      'numPiecePap': numPiecePap,
      'telephonePap': telephonePap,
      'sexe': sexe,
      'nationalite': nationalite,
      'ethnie': ethnie,
      'handicap': handicap,
      'saitLireEcrire': saitLireEcrire == true ? 1 : 0,
      'langueLecture': langueLecture,
      'niveauEtude': niveauEtude,
      'vaAEcole': vaAEcole == true ? 1 : 0,
      'travaille': travaille == true ? 1 : 0,
      'activitePrincipale': activitePrincipale,
      'statutActivite': statutActivite,
      'nbMoisActivite': nbMoisActivite,
      'revenuMensuel': revenuMensuel,
      'activiteSecondaire': activiteSecondaire,
      'statutActiviteSec': statutActiviteSec,
      'nbMoisActiviteSec': nbMoisActiviteSec,
      'revenuMensuelSec': revenuMensuelSec,
      'sitEmploiMembreMen': sitEmploiMembreMen,
      'autreSituationEmploi': autreSituationEmploi,
      'createdAt': createdAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }
}
