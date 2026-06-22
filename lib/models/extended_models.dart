class InfoLogement {
  final String? statutOccupationLogement;
  final String? typeBatiment;
  final int? nbPieces;
  final String? materiauMur;
  final String? materiauSol;
  final String? materiauToit;
  final double? montantLoyer;
  final String? nomProprietaire;
  final String? contactProprietaire;
  final String? dureeLocation;
  final bool? aPayeCaution;
  final int? moisCaution;
  final double? montantCaution;
  final String? modeAcquisitionTerrain;
  final String? aMisEnLocation;
  final int? nbMoisLocation;
  final double? revenusLocation;
  final String? syncStatus;
  final String? deviceId;

  InfoLogement({
    this.statutOccupationLogement,
    this.typeBatiment,
    this.nbPieces,
    this.materiauMur,
    this.materiauSol,
    this.materiauToit,
    this.montantLoyer,
    this.nomProprietaire,
    this.contactProprietaire,
    this.dureeLocation,
    this.aPayeCaution,
    this.moisCaution,
    this.montantCaution,
    this.modeAcquisitionTerrain,
    this.aMisEnLocation,
    this.nbMoisLocation,
    this.revenusLocation,
    this.syncStatus,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'statutOccupationLogement': statutOccupationLogement,
    'typeBatiment': typeBatiment,
    'nbPieces': nbPieces,
    'materiauMur': materiauMur,
    'materiauSol': materiauSol,
    'materiauToit': materiauToit,
    'montantLoyer': montantLoyer,
    'nomProprietaire': nomProprietaire,
    'contactProprietaire': contactProprietaire,
    'dureeLocation': dureeLocation,
    'aPayeCaution': aPayeCaution,
    'moisCaution': moisCaution,
    'montantCaution': montantCaution,
    'modeAcquisitionTerrain': modeAcquisitionTerrain,
    'aMisEnLocation': aMisEnLocation,
    'nbMoisLocation': nbMoisLocation,
    'revenusLocation': revenusLocation,
    'syncStatus': syncStatus,
    'deviceId': deviceId,
  };
}

class ParcelleAgricole {
  final String? localisationParcelles;
  final bool? exploiteSoiMeme;
  final String? typeCulture;
  final String? modeAcquisitionParcelle;
  final String? syncStatus;
  final String? deviceId;

  ParcelleAgricole({
    this.localisationParcelles,
    this.exploiteSoiMeme,
    this.typeCulture,
    this.modeAcquisitionParcelle,
    this.syncStatus,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'localisationParcelles': localisationParcelles,
    'exploiteSoiMeme': exploiteSoiMeme,
    'typeCulture': typeCulture,
    'modeAcquisitionParcelle': modeAcquisitionParcelle,
    'syncStatus': syncStatus,
    'deviceId': deviceId,
  };
}

class Elevage {
  final int? nbBovins;
  final int? nbOvins;
  final int? nbCaprins;
  final int? nbVolailles;
  final int? nbAnes;
  final bool? elevageCommercial;
  final String? syncStatus;
  final String? deviceId;

  Elevage({
    this.nbBovins,
    this.nbOvins,
    this.nbCaprins,
    this.nbVolailles,
    this.nbAnes,
    this.elevageCommercial,
    this.syncStatus,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'nbBovins': nbBovins,
    'nbOvins': nbOvins,
    'nbCaprins': nbCaprins,
    'nbVolailles': nbVolailles,
    'nbAnes': nbAnes,
    'elevageCommercial': elevageCommercial,
    'syncStatus': syncStatus,
    'deviceId': deviceId,
  };
}

class InfoFinanciere {
  final bool? recoitAideFinanciere;
  final double? montantAide2023;
  final bool? aCompteBanque;
  final bool? pratiqueTontine;
  final bool? membresParticipentCharges;
  final String? syncStatus;
  final String? deviceId;

  InfoFinanciere({
    this.recoitAideFinanciere,
    this.montantAide2023,
    this.aCompteBanque,
    this.pratiqueTontine,
    this.membresParticipentCharges,
    this.syncStatus,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'recoitAideFinanciere': recoitAideFinanciere,
    'montantAide2023': montantAide2023,
    'aCompteBanque': aCompteBanque,
    'pratiqueTontine': pratiqueTontine,
    'membresParticipentCharges': membresParticipentCharges,
    'syncStatus': syncStatus,
    'deviceId': deviceId,
  };
}

class Credit {
  final String? institutionCredit;
  final String? raisonCredit;
  final double? montantCredit;
  final String? statutCredit;
  final String? syncStatus;
  final String? deviceId;

  Credit({
    this.institutionCredit,
    this.raisonCredit,
    this.montantCredit,
    this.statutCredit,
    this.syncStatus,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'institutionCredit': institutionCredit,
    'raisonCredit': raisonCredit,
    'montantCredit': montantCredit,
    'statutCredit': statutCredit,
    'syncStatus': syncStatus,
    'deviceId': deviceId,
  };
}

class SecuriteAlimentaire {
  final int? joursAlimentsMoinsChers;
  final int? joursEmprunterNourriture;
  final int? joursLimiterQuantite;
  final int? joursRestreindreAdultes;
  final int? joursReduireRepas;
  final int? joursManquerNourriture;
  final String? syncStatus;
  final String? deviceId;

  SecuriteAlimentaire({
    this.joursAlimentsMoinsChers,
    this.joursEmprunterNourriture,
    this.joursLimiterQuantite,
    this.joursRestreindreAdultes,
    this.joursReduireRepas,
    this.joursManquerNourriture,
    this.syncStatus,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'joursAlimentsMoinsChers': joursAlimentsMoinsChers,
    'joursEmprunterNourriture': joursEmprunterNourriture,
    'joursLimiterQuantite': joursLimiterQuantite,
    'joursRestreindreAdultes': joursRestreindreAdultes,
    'joursReduireRepas': joursReduireRepas,
    'joursManquerNourriture': joursManquerNourriture,
    'syncStatus': syncStatus,
    'deviceId': deviceId,
  };
}

class Employe {
  final String? employeNomPrenoms;
  final String? employeContact;
  final String? employeType;
  final double? employeSalaireNet;
  final String? syncStatus;
  final String? deviceId;

  Employe({
    this.employeNomPrenoms,
    this.employeContact,
    this.employeType,
    this.employeSalaireNet,
    this.syncStatus,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'employeNomPrenoms': employeNomPrenoms,
    'employeContact': employeContact,
    'employeType': employeType,
    'employeSalaireNet': employeSalaireNet,
    'syncStatus': syncStatus,
    'deviceId': deviceId,
  };
}
