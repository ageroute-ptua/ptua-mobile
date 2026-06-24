
class BienImpacte {
  final int? id;
  final String idPap;
  final String? categorie;
  final String? caracBienImpactes;
  final String? proprioFonc;
  final String? typeFoncier;
  final String? typeLotissement;
  final String? titrePropriete;
  final String? autreTitreProp;
  final String? numIlot;
  final String? numLot;
  final double? surfaceLotParcelle;
  final double? surfaceImpactee;
  final String? statutOccupation;
  final String? modeAcquisition;
  final String? autreModeAcqFonc;
  final int? anneeAcqFonc;
  final double? montantAcqFonc;
  final double? loyerMens;
  final double? loyerMensPercuBail;
  final String? nomPropEnLocationFonc;
  final String? contactPropEnLocation;
  final String? photoDocFoncier;
  final String? numBati;
  final String? identifiantBati;
  final String? typeConstruction;
  final String? statutOccBati;
  final String? modeAcqBati;
  final int? nbreNiveau;
  final int? nbreAppart;
  final String? materiauConst;
  final String? partieBatiImpact;
  final String? niveauAch;
  final int? nbrePieceBati;
  final String? typeComodite;
  final String? modeEvacEauUsees;
  final String? autreGestEauxUsees;
  final String? modeRamOrdures;
  final String? autreGestRamasOrdure;
  final String? autreFctBati;
  final int? anneeConstBati;
  final double? coutConstBati;
  final double? loyerMensPaye;
  final double? loyerMensPercu;
  final String? photoQuittance;
  final String? nomPropEnLocation;
  final String? numeroPropEnLocationBati;
  final bool? isActiviteFormelle;
  final String? typeActExer;
  final String? autreActImpactee;
  final String? lieuExcerActi;
  final int? anneeInstallSite;
  final String? lieuPrincApprovi;
  final String? origineClient;
  final double? revenuMensuelTire;
  final String? totalSalEmp;
  final bool? isPayeTaxe;
  final String? lesquellesTaxes;
  final String? autreTaxe;
  final String? freqPayeTaxe;
  final double? montantPayeActivComm;
  final String? denominatiEntreprise;
  final bool? presenceEnseigne;
  final String? formJuridiq;
  final String? numRccm;
  final String? ncc;
  final String? regimeImposition;
  final String? situationGeo;
  final String? produitService;
  final String? dateCreaEntre;
  final double? totalSalaireEmployeEntrep;
  final String? dateDebutActi;
  final double? chifAffaiMensuel;
  final String? localEntDetruit;
  final String? localPartDetruit;
  final String? travauxImpact;
  final int? nbrePersTravailleur;
  final String? imgActivite;
  final String? typeCulture;
  final int? ageCulture;
  final String? statuFoncAgricole;
  final String? modeAcquisitionFonc;
  final bool? autreModeAcquisFonc;
  final String? supParcelleAgricoleOuPied;
  final String? supImpacteAgric;
  final String? maturiteSaisonRecolt;
  final String? rendCultuDernRecolte;
  final double? revenuCommercialisation;
  final String? destinProduit;
  final String? lieuCommercialisation;
  final String? autreLieuCommerce;
  final double? montantCommercialisation;
  final bool? isParcelle;
  final double? superfParcelDispo;
  final int? nbrEmplyeAgricole;
  final double? totalSalaireEmployeAgricole;
  final String? denomiEquipCollec;
  final String? statuEquipCollec;
  final String? autreStatutEquipement;
  final String? caractEquipCollec;
  final String? autreCaracEquipement;
  final int? anneeInstSite;
  final int? nbrePersFreq;
  final String? lieuProvPers;
  final int? nbrEmplyeEquip;
  final double? revenuMensuelEquipLucratif;
  final String? preferenceIndemn;
  final String? continuerMemActivite;
  final String? ouiAppuiSouhaite;
  final String? autreAppuiSouhaite;
  final String? nonAppuiNvlleActiv;
  final bool? isConnaisance;
  final String? appuiDuProj;
  final String? domaineFormation;
  final String? listerTypeIntrant;
  final String? gpsBati;
  final String? photoRecu;
  final DateTime? createdAt;
  final String? syncStatus;

  BienImpacte({
    this.id,
    required this.idPap,
    this.categorie,
    this.caracBienImpactes,
    this.proprioFonc,
    this.typeFoncier,
    this.typeLotissement,
    this.titrePropriete,
    this.autreTitreProp,
    this.numIlot,
    this.numLot,
    this.surfaceLotParcelle,
    this.surfaceImpactee,
    this.statutOccupation,
    this.modeAcquisition,
    this.autreModeAcqFonc,
    this.anneeAcqFonc,
    this.montantAcqFonc,
    this.loyerMens,
    this.loyerMensPercuBail,
    this.nomPropEnLocationFonc,
    this.contactPropEnLocation,
    this.photoDocFoncier,
    this.numBati,
    this.identifiantBati,
    this.typeConstruction,
    this.statutOccBati,
    this.modeAcqBati,
    this.nbreNiveau,
    this.nbreAppart,
    this.materiauConst,
    this.partieBatiImpact,
    this.niveauAch,
    this.nbrePieceBati,
    this.typeComodite,
    this.modeEvacEauUsees,
    this.autreGestEauxUsees,
    this.modeRamOrdures,
    this.autreGestRamasOrdure,
    this.autreFctBati,
    this.anneeConstBati,
    this.coutConstBati,
    this.loyerMensPaye,
    this.loyerMensPercu,
    this.photoQuittance,
    this.nomPropEnLocation,
    this.numeroPropEnLocationBati,
    this.isActiviteFormelle,
    this.typeActExer,
    this.autreActImpactee,
    this.lieuExcerActi,
    this.anneeInstallSite,
    this.lieuPrincApprovi,
    this.origineClient,
    this.revenuMensuelTire,
    this.totalSalEmp,
    this.isPayeTaxe,
    this.lesquellesTaxes,
    this.autreTaxe,
    this.freqPayeTaxe,
    this.montantPayeActivComm,
    this.denominatiEntreprise,
    this.presenceEnseigne,
    this.formJuridiq,
    this.numRccm,
    this.ncc,
    this.regimeImposition,
    this.situationGeo,
    this.produitService,
    this.dateCreaEntre,
    this.totalSalaireEmployeEntrep,
    this.dateDebutActi,
    this.chifAffaiMensuel,
    this.localEntDetruit,
    this.localPartDetruit,
    this.travauxImpact,
    this.nbrePersTravailleur,
    this.imgActivite,
    this.typeCulture,
    this.ageCulture,
    this.statuFoncAgricole,
    this.modeAcquisitionFonc,
    this.autreModeAcquisFonc,
    this.supParcelleAgricoleOuPied,
    this.supImpacteAgric,
    this.maturiteSaisonRecolt,
    this.rendCultuDernRecolte,
    this.revenuCommercialisation,
    this.destinProduit,
    this.lieuCommercialisation,
    this.autreLieuCommerce,
    this.montantCommercialisation,
    this.isParcelle,
    this.superfParcelDispo,
    this.nbrEmplyeAgricole,
    this.totalSalaireEmployeAgricole,
    this.denomiEquipCollec,
    this.statuEquipCollec,
    this.autreStatutEquipement,
    this.caractEquipCollec,
    this.autreCaracEquipement,
    this.anneeInstSite,
    this.nbrePersFreq,
    this.lieuProvPers,
    this.nbrEmplyeEquip,
    this.revenuMensuelEquipLucratif,
    this.preferenceIndemn,
    this.continuerMemActivite,
    this.ouiAppuiSouhaite,
    this.autreAppuiSouhaite,
    this.nonAppuiNvlleActiv,
    this.isConnaisance,
    this.appuiDuProj,
    this.domaineFormation,
    this.listerTypeIntrant,
    this.gpsBati,
    this.photoRecu,
    this.createdAt,
    this.syncStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idPap': idPap,
      'categorie': categorie,
      'caracBienImpactes': caracBienImpactes,
      'proprioFonc': proprioFonc,
      'typeFoncier': typeFoncier,
      'typeLotissement': typeLotissement,
      'titrePropriete': titrePropriete,
      'autreTitreProp': autreTitreProp,
      'numIlot': numIlot,
      'numLot': numLot,
      'surfaceLotParcelle': surfaceLotParcelle,
      'surfaceImpactee': surfaceImpactee,
      'statutOccupation': statutOccupation,
      'modeAcquisition': modeAcquisition,
      'autreModeAcqFonc': autreModeAcqFonc,
      'anneeAcqFonc': anneeAcqFonc,
      'montantAcqFonc': montantAcqFonc,
      'loyerMens': loyerMens,
      'loyerMensPercuBail': loyerMensPercuBail,
      'nomPropEnLocationFonc': nomPropEnLocationFonc,
      'contactPropEnLocation': contactPropEnLocation,
      'photoDocFoncier': photoDocFoncier,
      'numBati': numBati,
      'identifiantBati': identifiantBati,
      'typeConstruction': typeConstruction,
      'statutOccBati': statutOccBati,
      'modeAcqBati': modeAcqBati,
      'nbreNiveau': nbreNiveau,
      'nbreAppart': nbreAppart,
      'materiauConst': materiauConst,
      'partieBatiImpact': partieBatiImpact,
      'niveauAch': niveauAch,
      'nbrePieceBati': nbrePieceBati,
      'typeComodite': typeComodite,
      'modeEvacEauUsees': modeEvacEauUsees,
      'autreGestEauxUsees': autreGestEauxUsees,
      'modeRamOrdures': modeRamOrdures,
      'autreGestRamasOrdure': autreGestRamasOrdure,
      'autreFctBati': autreFctBati,
      'anneeConstBati': anneeConstBati,
      'coutConstBati': coutConstBati,
      'loyerMensPaye': loyerMensPaye,
      'loyerMensPercu': loyerMensPercu,
      'photoQuittance': photoQuittance,
      'nomPropEnLocation': nomPropEnLocation,
      'numeroPropEnLocationBati': numeroPropEnLocationBati,
      'isActiviteFormelle': isActiviteFormelle,
      'typeActExer': typeActExer,
      'autreActImpactee': autreActImpactee,
      'lieuExcerActi': lieuExcerActi,
      'anneeInstallSite': anneeInstallSite,
      'lieuPrincApprovi': lieuPrincApprovi,
      'origineClient': origineClient,
      'revenuMensuelTire': revenuMensuelTire,
      'totalSalEmp': totalSalEmp,
      'isPayeTaxe': isPayeTaxe,
      'lesquellesTaxes': lesquellesTaxes,
      'autreTaxe': autreTaxe,
      'freqPayeTaxe': freqPayeTaxe,
      'montantPayeActivComm': montantPayeActivComm,
      'denominatiEntreprise': denominatiEntreprise,
      'presenceEnseigne': presenceEnseigne,
      'formJuridiq': formJuridiq,
      'numRccm': numRccm,
      'ncc': ncc,
      'regimeImposition': regimeImposition,
      'situationGeo': situationGeo,
      'produitService': produitService,
      'dateCreaEntre': dateCreaEntre,
      'totalSalaireEmployeEntrep': totalSalaireEmployeEntrep,
      'dateDebutActi': dateDebutActi,
      'chifAffaiMensuel': chifAffaiMensuel,
      'localEntDetruit': localEntDetruit,
      'localPartDetruit': localPartDetruit,
      'travauxImpact': travauxImpact,
      'nbrePersTravailleur': nbrePersTravailleur,
      'imgActivite': imgActivite,
      'typeCulture': typeCulture,
      'ageCulture': ageCulture,
      'statuFoncAgricole': statuFoncAgricole,
      'modeAcquisitionFonc': modeAcquisitionFonc,
      'autreModeAcquisFonc': autreModeAcquisFonc,
      'supParcelleAgricoleOuPied': supParcelleAgricoleOuPied,
      'supImpacteAgric': supImpacteAgric,
      'maturiteSaisonRecolt': maturiteSaisonRecolt,
      'rendCultuDernRecolte': rendCultuDernRecolte,
      'revenuCommercialisation': revenuCommercialisation,
      'destinProduit': destinProduit,
      'lieuCommercialisation': lieuCommercialisation,
      'autreLieuCommerce': autreLieuCommerce,
      'montantCommercialisation': montantCommercialisation,
      'isParcelle': isParcelle,
      'superfParcelDispo': superfParcelDispo,
      'nbrEmplyeAgricole': nbrEmplyeAgricole,
      'totalSalaireEmployeAgricole': totalSalaireEmployeAgricole,
      'denomiEquipCollec': denomiEquipCollec,
      'statuEquipCollec': statuEquipCollec,
      'autreStatutEquipement': autreStatutEquipement,
      'caractEquipCollec': caractEquipCollec,
      'autreCaracEquipement': autreCaracEquipement,
      'anneeInstSite': anneeInstSite,
      'nbrePersFreq': nbrePersFreq,
      'lieuProvPers': lieuProvPers,
      'nbrEmplyeEquip': nbrEmplyeEquip,
      'revenuMensuelEquipLucratif': revenuMensuelEquipLucratif,
      'preferenceIndemn': preferenceIndemn,
      'continuerMemActivite': continuerMemActivite,
      'ouiAppuiSouhaite': ouiAppuiSouhaite,
      'autreAppuiSouhaite': autreAppuiSouhaite,
      'nonAppuiNvlleActiv': nonAppuiNvlleActiv,
      'isConnaisance': isConnaisance,
      'appuiDuProj': appuiDuProj,
      'domaineFormation': domaineFormation,
      'listerTypeIntrant': listerTypeIntrant,
      'gpsBati': gpsBati,
      'photoRecu': photoRecu,
      'createdAt': createdAt?.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }

  factory BienImpacte.fromMap(Map<String, dynamic> map) {
    return BienImpacte(
      id: map['id'],
      idPap: map['idPap'],
      categorie: map['categorie'],
      caracBienImpactes: map['caracBienImpactes'],
      proprioFonc: map['proprioFonc'],
      typeFoncier: map['typeFoncier'],
      typeLotissement: map['typeLotissement'],
      titrePropriete: map['titrePropriete'],
      autreTitreProp: map['autreTitreProp'],
      numIlot: map['numIlot'],
      numLot: map['numLot'],
      surfaceLotParcelle: map['surfaceLotParcelle'] != null ? double.tryParse(map['surfaceLotParcelle'].toString()) : null,
      surfaceImpactee: map['surfaceImpactee'] != null ? double.tryParse(map['surfaceImpactee'].toString()) : null,
      statutOccupation: map['statutOccupation'],
      modeAcquisition: map['modeAcquisition'],
      autreModeAcqFonc: map['autreModeAcqFonc'],
      anneeAcqFonc: map['anneeAcqFonc'] != null ? int.tryParse(map['anneeAcqFonc'].toString()) : null,
      montantAcqFonc: map['montantAcqFonc'] != null ? double.tryParse(map['montantAcqFonc'].toString()) : null,
      loyerMens: map['loyerMens'] != null ? double.tryParse(map['loyerMens'].toString()) : null,
      loyerMensPercuBail: map['loyerMensPercuBail'] != null ? double.tryParse(map['loyerMensPercuBail'].toString()) : null,
      nomPropEnLocationFonc: map['nomPropEnLocationFonc'],
      contactPropEnLocation: map['contactPropEnLocation'],
      photoDocFoncier: map['photoDocFoncier'],
      numBati: map['numBati'],
      identifiantBati: map['identifiantBati'],
      typeConstruction: map['typeConstruction'],
      statutOccBati: map['statutOccBati'],
      modeAcqBati: map['modeAcqBati'],
      nbreNiveau: map['nbreNiveau'] != null ? int.tryParse(map['nbreNiveau'].toString()) : null,
      nbreAppart: map['nbreAppart'] != null ? int.tryParse(map['nbreAppart'].toString()) : null,
      materiauConst: map['materiauConst'],
      partieBatiImpact: map['partieBatiImpact'],
      niveauAch: map['niveauAch'],
      nbrePieceBati: map['nbrePieceBati'] != null ? int.tryParse(map['nbrePieceBati'].toString()) : null,
      typeComodite: map['typeComodite'],
      modeEvacEauUsees: map['modeEvacEauUsees'],
      autreGestEauxUsees: map['autreGestEauxUsees'],
      modeRamOrdures: map['modeRamOrdures'],
      autreGestRamasOrdure: map['autreGestRamasOrdure'],
      autreFctBati: map['autreFctBati'],
      anneeConstBati: map['anneeConstBati'] != null ? int.tryParse(map['anneeConstBati'].toString()) : null,
      coutConstBati: map['coutConstBati'] != null ? double.tryParse(map['coutConstBati'].toString()) : null,
      loyerMensPaye: map['loyerMensPaye'] != null ? double.tryParse(map['loyerMensPaye'].toString()) : null,
      loyerMensPercu: map['loyerMensPercu'] != null ? double.tryParse(map['loyerMensPercu'].toString()) : null,
      photoQuittance: map['photoQuittance'],
      nomPropEnLocation: map['nomPropEnLocation'],
      numeroPropEnLocationBati: map['numeroPropEnLocationBati'],
      isActiviteFormelle: map['isActiviteFormelle'] == 1 || map['isActiviteFormelle'] == 'true',
      typeActExer: map['typeActExer'],
      autreActImpactee: map['autreActImpactee'],
      lieuExcerActi: map['lieuExcerActi'],
      anneeInstallSite: map['anneeInstallSite'] != null ? int.tryParse(map['anneeInstallSite'].toString()) : null,
      lieuPrincApprovi: map['lieuPrincApprovi'],
      origineClient: map['origineClient'],
      revenuMensuelTire: map['revenuMensuelTire'] != null ? double.tryParse(map['revenuMensuelTire'].toString()) : null,
      totalSalEmp: map['totalSalEmp'],
      isPayeTaxe: map['isPayeTaxe'] == 1 || map['isPayeTaxe'] == 'true',
      lesquellesTaxes: map['lesquellesTaxes'],
      autreTaxe: map['autreTaxe'],
      freqPayeTaxe: map['freqPayeTaxe'],
      montantPayeActivComm: map['montantPayeActivComm'] != null ? double.tryParse(map['montantPayeActivComm'].toString()) : null,
      denominatiEntreprise: map['denominatiEntreprise'],
      presenceEnseigne: map['presenceEnseigne'] == 1 || map['presenceEnseigne'] == 'true',
      formJuridiq: map['formJuridiq'],
      numRccm: map['numRccm'],
      ncc: map['ncc'],
      regimeImposition: map['regimeImposition'],
      situationGeo: map['situationGeo'],
      produitService: map['produitService'],
      dateCreaEntre: map['dateCreaEntre'],
      totalSalaireEmployeEntrep: map['totalSalaireEmployeEntrep'] != null ? double.tryParse(map['totalSalaireEmployeEntrep'].toString()) : null,
      dateDebutActi: map['dateDebutActi'],
      chifAffaiMensuel: map['chifAffaiMensuel'] != null ? double.tryParse(map['chifAffaiMensuel'].toString()) : null,
      localEntDetruit: map['localEntDetruit'],
      localPartDetruit: map['localPartDetruit'],
      travauxImpact: map['travauxImpact'],
      nbrePersTravailleur: map['nbrePersTravailleur'] != null ? int.tryParse(map['nbrePersTravailleur'].toString()) : null,
      imgActivite: map['imgActivite'],
      typeCulture: map['typeCulture'],
      ageCulture: map['ageCulture'] != null ? int.tryParse(map['ageCulture'].toString()) : null,
      statuFoncAgricole: map['statuFoncAgricole'],
      modeAcquisitionFonc: map['modeAcquisitionFonc'],
      autreModeAcquisFonc: map['autreModeAcquisFonc'] == 1 || map['autreModeAcquisFonc'] == 'true',
      supParcelleAgricoleOuPied: map['supParcelleAgricoleOuPied'],
      supImpacteAgric: map['supImpacteAgric'],
      maturiteSaisonRecolt: map['maturiteSaisonRecolt'],
      rendCultuDernRecolte: map['rendCultuDernRecolte'],
      revenuCommercialisation: map['revenuCommercialisation'] != null ? double.tryParse(map['revenuCommercialisation'].toString()) : null,
      destinProduit: map['destinProduit'],
      lieuCommercialisation: map['lieuCommercialisation'],
      autreLieuCommerce: map['autreLieuCommerce'],
      montantCommercialisation: map['montantCommercialisation'] != null ? double.tryParse(map['montantCommercialisation'].toString()) : null,
      isParcelle: map['isParcelle'] == 1 || map['isParcelle'] == 'true',
      superfParcelDispo: map['superfParcelDispo'] != null ? double.tryParse(map['superfParcelDispo'].toString()) : null,
      nbrEmplyeAgricole: map['nbrEmplyeAgricole'] != null ? int.tryParse(map['nbrEmplyeAgricole'].toString()) : null,
      totalSalaireEmployeAgricole: map['totalSalaireEmployeAgricole'] != null ? double.tryParse(map['totalSalaireEmployeAgricole'].toString()) : null,
      denomiEquipCollec: map['denomiEquipCollec'],
      statuEquipCollec: map['statuEquipCollec'],
      autreStatutEquipement: map['autreStatutEquipement'],
      caractEquipCollec: map['caractEquipCollec'],
      autreCaracEquipement: map['autreCaracEquipement'],
      anneeInstSite: map['anneeInstSite'] != null ? int.tryParse(map['anneeInstSite'].toString()) : null,
      nbrePersFreq: map['nbrePersFreq'] != null ? int.tryParse(map['nbrePersFreq'].toString()) : null,
      lieuProvPers: map['lieuProvPers'],
      nbrEmplyeEquip: map['nbrEmplyeEquip'] != null ? int.tryParse(map['nbrEmplyeEquip'].toString()) : null,
      revenuMensuelEquipLucratif: map['revenuMensuelEquipLucratif'] != null ? double.tryParse(map['revenuMensuelEquipLucratif'].toString()) : null,
      preferenceIndemn: map['preferenceIndemn'],
      continuerMemActivite: map['continuerMemActivite'],
      ouiAppuiSouhaite: map['ouiAppuiSouhaite'],
      autreAppuiSouhaite: map['autreAppuiSouhaite'],
      nonAppuiNvlleActiv: map['nonAppuiNvlleActiv'],
      isConnaisance: map['isConnaisance'] == 1 || map['isConnaisance'] == 'true',
      appuiDuProj: map['appuiDuProj'],
      domaineFormation: map['domaineFormation'],
      listerTypeIntrant: map['listerTypeIntrant'],
      gpsBati: map['gpsBati'],
      photoRecu: map['photoRecu'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      syncStatus: map['syncStatus'],
    );
  }
}
