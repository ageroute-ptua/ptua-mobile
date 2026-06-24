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
  
  // Nouveaux champs Kobo
  final String? situationSocialeMenage;
  final String? nomPrenomMen;
  final String? parenteMen;
  final String? autreLienParente;
  final String? telephoneMen;
  final int? enfVulMenage;
  final int? persAgeeVulMenage;
  final int? handicapephysmentMenage;
  final int? femGrossessMenage;
  final int? orphelinMenage;
  final int? femChefMenage;
  final int? persMaladieMetaMenage;
  final int? nbrePersVulnMenage;
  final String? declarationOrgQuartier;
  final String? statutAssociation;
  final String? autreOrganisation;
  final String? typeRelaMemOrg;
  final String? avantageAssocOrg;
  final String? indiqNbrEquip;
  final int? voiture;
  final int? moto;
  final int? velo;
  final int? salon;
  final int? television;
  final int? radio;
  final int? ordinateur;
  final int? portable;
  final int? cuisiniere;
  final int? congelateur;
  final int? fer;
  final int? clim;
  final int? machine;
  final int? biblio;

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
    this.situationSocialeMenage,
    this.nomPrenomMen,
    this.parenteMen,
    this.autreLienParente,
    this.telephoneMen,
    this.enfVulMenage,
    this.persAgeeVulMenage,
    this.handicapephysmentMenage,
    this.femGrossessMenage,
    this.orphelinMenage,
    this.femChefMenage,
    this.persMaladieMetaMenage,
    this.nbrePersVulnMenage,
    this.declarationOrgQuartier,
    this.statutAssociation,
    this.autreOrganisation,
    this.typeRelaMemOrg,
    this.avantageAssocOrg,
    this.indiqNbrEquip,
    this.voiture,
    this.moto,
    this.velo,
    this.salon,
    this.television,
    this.radio,
    this.ordinateur,
    this.portable,
    this.cuisiniere,
    this.congelateur,
    this.fer,
    this.clim,
    this.machine,
    this.biblio,
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
      situationSocialeMenage: map['situationSocialeMenage'],
      nomPrenomMen: map['nomPrenomMen'],
      parenteMen: map['parenteMen'],
      autreLienParente: map['autreLienParente'],
      telephoneMen: map['telephoneMen'],
      enfVulMenage: map['enfVulMenage'],
      persAgeeVulMenage: map['persAgeeVulMenage'],
      handicapephysmentMenage: map['handicapephysmentMenage'],
      femGrossessMenage: map['femGrossessMenage'],
      orphelinMenage: map['orphelinMenage'],
      femChefMenage: map['femChefMenage'],
      persMaladieMetaMenage: map['persMaladieMetaMenage'],
      nbrePersVulnMenage: map['nbrePersVulnMenage'],
      declarationOrgQuartier: map['declarationOrgQuartier'],
      statutAssociation: map['statutAssociation'],
      autreOrganisation: map['autreOrganisation'],
      typeRelaMemOrg: map['typeRelaMemOrg'],
      avantageAssocOrg: map['avantageAssocOrg'],
      indiqNbrEquip: map['indiqNbrEquip'],
      voiture: map['voiture'],
      moto: map['moto'],
      velo: map['velo'],
      salon: map['salon'],
      television: map['television'],
      radio: map['radio'],
      ordinateur: map['ordinateur'],
      portable: map['portable'],
      cuisiniere: map['cuisiniere'],
      congelateur: map['congelateur'],
      fer: map['fer'],
      clim: map['clim'],
      machine: map['machine'],
      biblio: map['biblio'],
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
      'situationSocialeMenage': situationSocialeMenage,
      'nomPrenomMen': nomPrenomMen,
      'parenteMen': parenteMen,
      'autreLienParente': autreLienParente,
      'telephoneMen': telephoneMen,
      'enfVulMenage': enfVulMenage,
      'persAgeeVulMenage': persAgeeVulMenage,
      'handicapephysmentMenage': handicapephysmentMenage,
      'femGrossessMenage': femGrossessMenage,
      'orphelinMenage': orphelinMenage,
      'femChefMenage': femChefMenage,
      'persMaladieMetaMenage': persMaladieMetaMenage,
      'nbrePersVulnMenage': nbrePersVulnMenage,
      'declarationOrgQuartier': declarationOrgQuartier,
      'statutAssociation': statutAssociation,
      'autreOrganisation': autreOrganisation,
      'typeRelaMemOrg': typeRelaMemOrg,
      'avantageAssocOrg': avantageAssocOrg,
      'indiqNbrEquip': indiqNbrEquip,
      'voiture': voiture,
      'moto': moto,
      'velo': velo,
      'salon': salon,
      'television': television,
      'radio': radio,
      'ordinateur': ordinateur,
      'portable': portable,
      'cuisiniere': cuisiniere,
      'congelateur': congelateur,
      'fer': fer,
      'clim': clim,
      'machine': machine,
      'biblio': biblio,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
    };
  }
}
