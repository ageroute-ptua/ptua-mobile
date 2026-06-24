import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
import '../models/bien_impacte.dart';
import '../services/database_helper.dart';

class BienImpacteFormScreen extends StatefulWidget {
  final String idPap;
  final BienImpacte? bienToEdit;

  const BienImpacteFormScreen({super.key, required this.idPap, this.bienToEdit});

  @override
  State<BienImpacteFormScreen> createState() => _BienImpacteFormScreenState();
}

class _BienImpacteFormScreenState extends State<BienImpacteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  
  String? _categorie;
  
  final _caracBienImpactesController = TextEditingController();
  final _proprioFoncController = TextEditingController();
  final _typeFoncierController = TextEditingController();
  final _typeLotissementController = TextEditingController();
  final _titreProprieteController = TextEditingController();
  final _autreTitrePropController = TextEditingController();
  final _numIlotController = TextEditingController();
  final _numLotController = TextEditingController();
  final _surfaceLotParcelleController = TextEditingController();
  final _surfaceImpacteeController = TextEditingController();
  final _statutOccupationController = TextEditingController();
  final _modeAcquisitionController = TextEditingController();
  final _autreModeAcqFoncController = TextEditingController();
  final _anneeAcqFoncController = TextEditingController();
  final _montantAcqFoncController = TextEditingController();
  final _loyerMensController = TextEditingController();
  final _loyerMensPercuBailController = TextEditingController();
  final _nomPropEnLocationFoncController = TextEditingController();
  final _contactPropEnLocationController = TextEditingController();
  final _photoDocFoncierController = TextEditingController();
  final _numBatiController = TextEditingController();
  final _identifiantBatiController = TextEditingController();
  final _typeConstructionController = TextEditingController();
  final _statutOccBatiController = TextEditingController();
  final _modeAcqBatiController = TextEditingController();
  final _nbreNiveauController = TextEditingController();
  final _nbreAppartController = TextEditingController();
  final _materiauConstController = TextEditingController();
  final _partieBatiImpactController = TextEditingController();
  final _niveauAchController = TextEditingController();
  final _nbrePieceBatiController = TextEditingController();
  final _typeComoditeController = TextEditingController();
  final _modeEvacEauUseesController = TextEditingController();
  final _autreGestEauxUseesController = TextEditingController();
  final _modeRamOrduresController = TextEditingController();
  final _autreGestRamasOrdureController = TextEditingController();
  final _autreFctBatiController = TextEditingController();
  final _anneeConstBatiController = TextEditingController();
  final _coutConstBatiController = TextEditingController();
  final _loyerMensPayeController = TextEditingController();
  final _loyerMensPercuController = TextEditingController();
  final _photoQuittanceController = TextEditingController();
  final _nomPropEnLocationController = TextEditingController();
  final _numeroPropEnLocationBatiController = TextEditingController();
  bool? _isActiviteFormelle;
  final _typeActExerController = TextEditingController();
  final _autreActImpacteeController = TextEditingController();
  final _lieuExcerActiController = TextEditingController();
  final _anneeInstallSiteController = TextEditingController();
  final _lieuPrincApproviController = TextEditingController();
  final _origineClientController = TextEditingController();
  final _revenuMensuelTireController = TextEditingController();
  final _totalSalEmpController = TextEditingController();
  bool? _isPayeTaxe;
  final _lesquellesTaxesController = TextEditingController();
  final _autreTaxeController = TextEditingController();
  final _freqPayeTaxeController = TextEditingController();
  final _montantPayeActivCommController = TextEditingController();
  final _denominatiEntrepriseController = TextEditingController();
  bool? _presenceEnseigne;
  final _formJuridiqController = TextEditingController();
  final _numRccmController = TextEditingController();
  final _nccController = TextEditingController();
  final _regimeImpositionController = TextEditingController();
  final _situationGeoController = TextEditingController();
  final _produitServiceController = TextEditingController();
  final _dateCreaEntreController = TextEditingController();
  final _totalSalaireEmployeEntrepController = TextEditingController();
  final _dateDebutActiController = TextEditingController();
  final _chifAffaiMensuelController = TextEditingController();
  final _localEntDetruitController = TextEditingController();
  final _localPartDetruitController = TextEditingController();
  final _travauxImpactController = TextEditingController();
  final _nbrePersTravailleurController = TextEditingController();
  final _imgActiviteController = TextEditingController();
  final _typeCultureController = TextEditingController();
  final _ageCultureController = TextEditingController();
  final _statuFoncAgricoleController = TextEditingController();
  final _modeAcquisitionFoncController = TextEditingController();
  bool? _autreModeAcquisFonc;
  final _supParcelleAgricoleOuPiedController = TextEditingController();
  final _supImpacteAgricController = TextEditingController();
  final _maturiteSaisonRecoltController = TextEditingController();
  final _rendCultuDernRecolteController = TextEditingController();
  final _revenuCommercialisationController = TextEditingController();
  final _destinProduitController = TextEditingController();
  final _lieuCommercialisationController = TextEditingController();
  final _autreLieuCommerceController = TextEditingController();
  final _montantCommercialisationController = TextEditingController();
  bool? _isParcelle;
  final _superfParcelDispoController = TextEditingController();
  final _nbrEmplyeAgricoleController = TextEditingController();
  final _totalSalaireEmployeAgricoleController = TextEditingController();
  final _denomiEquipCollecController = TextEditingController();
  final _statuEquipCollecController = TextEditingController();
  final _autreStatutEquipementController = TextEditingController();
  final _caractEquipCollecController = TextEditingController();
  final _autreCaracEquipementController = TextEditingController();
  final _anneeInstSiteController = TextEditingController();
  final _nbrePersFreqController = TextEditingController();
  final _lieuProvPersController = TextEditingController();
  final _nbrEmplyeEquipController = TextEditingController();
  final _revenuMensuelEquipLucratifController = TextEditingController();
  final _preferenceIndemnController = TextEditingController();
  final _continuerMemActiviteController = TextEditingController();
  final _ouiAppuiSouhaiteController = TextEditingController();
  final _autreAppuiSouhaiteController = TextEditingController();
  final _nonAppuiNvlleActivController = TextEditingController();
  bool? _isConnaisance;
  final _appuiDuProjController = TextEditingController();
  final _domaineFormationController = TextEditingController();
  final _listerTypeIntrantController = TextEditingController();
  final _gpsBatiController = TextEditingController();
  final _photoRecuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bienToEdit != null) {
      _categorie = widget.bienToEdit!.categorie;
      _caracBienImpactesController.text = widget.bienToEdit!.caracBienImpactes ?? '';
      _proprioFoncController.text = widget.bienToEdit!.proprioFonc ?? '';
      _typeFoncierController.text = widget.bienToEdit!.typeFoncier ?? '';
      _typeLotissementController.text = widget.bienToEdit!.typeLotissement ?? '';
      _titreProprieteController.text = widget.bienToEdit!.titrePropriete ?? '';
      _autreTitrePropController.text = widget.bienToEdit!.autreTitreProp ?? '';
      _numIlotController.text = widget.bienToEdit!.numIlot ?? '';
      _numLotController.text = widget.bienToEdit!.numLot ?? '';
      _surfaceLotParcelleController.text = widget.bienToEdit!.surfaceLotParcelle?.toString() ?? '';
      _surfaceImpacteeController.text = widget.bienToEdit!.surfaceImpactee?.toString() ?? '';
      _statutOccupationController.text = widget.bienToEdit!.statutOccupation ?? '';
      _modeAcquisitionController.text = widget.bienToEdit!.modeAcquisition ?? '';
      _autreModeAcqFoncController.text = widget.bienToEdit!.autreModeAcqFonc ?? '';
      _anneeAcqFoncController.text = widget.bienToEdit!.anneeAcqFonc?.toString() ?? '';
      _montantAcqFoncController.text = widget.bienToEdit!.montantAcqFonc?.toString() ?? '';
      _loyerMensController.text = widget.bienToEdit!.loyerMens?.toString() ?? '';
      _loyerMensPercuBailController.text = widget.bienToEdit!.loyerMensPercuBail?.toString() ?? '';
      _nomPropEnLocationFoncController.text = widget.bienToEdit!.nomPropEnLocationFonc ?? '';
      _contactPropEnLocationController.text = widget.bienToEdit!.contactPropEnLocation ?? '';
      _photoDocFoncierController.text = widget.bienToEdit!.photoDocFoncier ?? '';
      _numBatiController.text = widget.bienToEdit!.numBati ?? '';
      _identifiantBatiController.text = widget.bienToEdit!.identifiantBati ?? '';
      _typeConstructionController.text = widget.bienToEdit!.typeConstruction ?? '';
      _statutOccBatiController.text = widget.bienToEdit!.statutOccBati ?? '';
      _modeAcqBatiController.text = widget.bienToEdit!.modeAcqBati ?? '';
      _nbreNiveauController.text = widget.bienToEdit!.nbreNiveau?.toString() ?? '';
      _nbreAppartController.text = widget.bienToEdit!.nbreAppart?.toString() ?? '';
      _materiauConstController.text = widget.bienToEdit!.materiauConst ?? '';
      _partieBatiImpactController.text = widget.bienToEdit!.partieBatiImpact ?? '';
      _niveauAchController.text = widget.bienToEdit!.niveauAch ?? '';
      _nbrePieceBatiController.text = widget.bienToEdit!.nbrePieceBati?.toString() ?? '';
      _typeComoditeController.text = widget.bienToEdit!.typeComodite ?? '';
      _modeEvacEauUseesController.text = widget.bienToEdit!.modeEvacEauUsees ?? '';
      _autreGestEauxUseesController.text = widget.bienToEdit!.autreGestEauxUsees ?? '';
      _modeRamOrduresController.text = widget.bienToEdit!.modeRamOrdures ?? '';
      _autreGestRamasOrdureController.text = widget.bienToEdit!.autreGestRamasOrdure ?? '';
      _autreFctBatiController.text = widget.bienToEdit!.autreFctBati ?? '';
      _anneeConstBatiController.text = widget.bienToEdit!.anneeConstBati?.toString() ?? '';
      _coutConstBatiController.text = widget.bienToEdit!.coutConstBati?.toString() ?? '';
      _loyerMensPayeController.text = widget.bienToEdit!.loyerMensPaye?.toString() ?? '';
      _loyerMensPercuController.text = widget.bienToEdit!.loyerMensPercu?.toString() ?? '';
      _photoQuittanceController.text = widget.bienToEdit!.photoQuittance ?? '';
      _nomPropEnLocationController.text = widget.bienToEdit!.nomPropEnLocation ?? '';
      _numeroPropEnLocationBatiController.text = widget.bienToEdit!.numeroPropEnLocationBati ?? '';
      _isActiviteFormelle = widget.bienToEdit!.isActiviteFormelle;
      _typeActExerController.text = widget.bienToEdit!.typeActExer ?? '';
      _autreActImpacteeController.text = widget.bienToEdit!.autreActImpactee ?? '';
      _lieuExcerActiController.text = widget.bienToEdit!.lieuExcerActi ?? '';
      _anneeInstallSiteController.text = widget.bienToEdit!.anneeInstallSite?.toString() ?? '';
      _lieuPrincApproviController.text = widget.bienToEdit!.lieuPrincApprovi ?? '';
      _origineClientController.text = widget.bienToEdit!.origineClient ?? '';
      _revenuMensuelTireController.text = widget.bienToEdit!.revenuMensuelTire?.toString() ?? '';
      _totalSalEmpController.text = widget.bienToEdit!.totalSalEmp ?? '';
      _isPayeTaxe = widget.bienToEdit!.isPayeTaxe;
      _lesquellesTaxesController.text = widget.bienToEdit!.lesquellesTaxes ?? '';
      _autreTaxeController.text = widget.bienToEdit!.autreTaxe ?? '';
      _freqPayeTaxeController.text = widget.bienToEdit!.freqPayeTaxe ?? '';
      _montantPayeActivCommController.text = widget.bienToEdit!.montantPayeActivComm?.toString() ?? '';
      _denominatiEntrepriseController.text = widget.bienToEdit!.denominatiEntreprise ?? '';
      _presenceEnseigne = widget.bienToEdit!.presenceEnseigne;
      _formJuridiqController.text = widget.bienToEdit!.formJuridiq ?? '';
      _numRccmController.text = widget.bienToEdit!.numRccm ?? '';
      _nccController.text = widget.bienToEdit!.ncc ?? '';
      _regimeImpositionController.text = widget.bienToEdit!.regimeImposition ?? '';
      _situationGeoController.text = widget.bienToEdit!.situationGeo ?? '';
      _produitServiceController.text = widget.bienToEdit!.produitService ?? '';
      _dateCreaEntreController.text = widget.bienToEdit!.dateCreaEntre ?? '';
      _totalSalaireEmployeEntrepController.text = widget.bienToEdit!.totalSalaireEmployeEntrep?.toString() ?? '';
      _dateDebutActiController.text = widget.bienToEdit!.dateDebutActi ?? '';
      _chifAffaiMensuelController.text = widget.bienToEdit!.chifAffaiMensuel?.toString() ?? '';
      _localEntDetruitController.text = widget.bienToEdit!.localEntDetruit ?? '';
      _localPartDetruitController.text = widget.bienToEdit!.localPartDetruit ?? '';
      _travauxImpactController.text = widget.bienToEdit!.travauxImpact ?? '';
      _nbrePersTravailleurController.text = widget.bienToEdit!.nbrePersTravailleur?.toString() ?? '';
      _imgActiviteController.text = widget.bienToEdit!.imgActivite ?? '';
      _typeCultureController.text = widget.bienToEdit!.typeCulture ?? '';
      _ageCultureController.text = widget.bienToEdit!.ageCulture?.toString() ?? '';
      _statuFoncAgricoleController.text = widget.bienToEdit!.statuFoncAgricole ?? '';
      _modeAcquisitionFoncController.text = widget.bienToEdit!.modeAcquisitionFonc ?? '';
      _autreModeAcquisFonc = widget.bienToEdit!.autreModeAcquisFonc;
      _supParcelleAgricoleOuPiedController.text = widget.bienToEdit!.supParcelleAgricoleOuPied ?? '';
      _supImpacteAgricController.text = widget.bienToEdit!.supImpacteAgric ?? '';
      _maturiteSaisonRecoltController.text = widget.bienToEdit!.maturiteSaisonRecolt ?? '';
      _rendCultuDernRecolteController.text = widget.bienToEdit!.rendCultuDernRecolte ?? '';
      _revenuCommercialisationController.text = widget.bienToEdit!.revenuCommercialisation?.toString() ?? '';
      _destinProduitController.text = widget.bienToEdit!.destinProduit ?? '';
      _lieuCommercialisationController.text = widget.bienToEdit!.lieuCommercialisation ?? '';
      _autreLieuCommerceController.text = widget.bienToEdit!.autreLieuCommerce ?? '';
      _montantCommercialisationController.text = widget.bienToEdit!.montantCommercialisation?.toString() ?? '';
      _isParcelle = widget.bienToEdit!.isParcelle;
      _superfParcelDispoController.text = widget.bienToEdit!.superfParcelDispo?.toString() ?? '';
      _nbrEmplyeAgricoleController.text = widget.bienToEdit!.nbrEmplyeAgricole?.toString() ?? '';
      _totalSalaireEmployeAgricoleController.text = widget.bienToEdit!.totalSalaireEmployeAgricole?.toString() ?? '';
      _denomiEquipCollecController.text = widget.bienToEdit!.denomiEquipCollec ?? '';
      _statuEquipCollecController.text = widget.bienToEdit!.statuEquipCollec ?? '';
      _autreStatutEquipementController.text = widget.bienToEdit!.autreStatutEquipement ?? '';
      _caractEquipCollecController.text = widget.bienToEdit!.caractEquipCollec ?? '';
      _autreCaracEquipementController.text = widget.bienToEdit!.autreCaracEquipement ?? '';
      _anneeInstSiteController.text = widget.bienToEdit!.anneeInstSite?.toString() ?? '';
      _nbrePersFreqController.text = widget.bienToEdit!.nbrePersFreq?.toString() ?? '';
      _lieuProvPersController.text = widget.bienToEdit!.lieuProvPers ?? '';
      _nbrEmplyeEquipController.text = widget.bienToEdit!.nbrEmplyeEquip?.toString() ?? '';
      _revenuMensuelEquipLucratifController.text = widget.bienToEdit!.revenuMensuelEquipLucratif?.toString() ?? '';
      _preferenceIndemnController.text = widget.bienToEdit!.preferenceIndemn ?? '';
      _continuerMemActiviteController.text = widget.bienToEdit!.continuerMemActivite ?? '';
      _ouiAppuiSouhaiteController.text = widget.bienToEdit!.ouiAppuiSouhaite ?? '';
      _autreAppuiSouhaiteController.text = widget.bienToEdit!.autreAppuiSouhaite ?? '';
      _nonAppuiNvlleActivController.text = widget.bienToEdit!.nonAppuiNvlleActiv ?? '';
      _isConnaisance = widget.bienToEdit!.isConnaisance;
      _appuiDuProjController.text = widget.bienToEdit!.appuiDuProj ?? '';
      _domaineFormationController.text = widget.bienToEdit!.domaineFormation ?? '';
      _listerTypeIntrantController.text = widget.bienToEdit!.listerTypeIntrant ?? '';
      _gpsBatiController.text = widget.bienToEdit!.gpsBati ?? '';
      _photoRecuController.text = widget.bienToEdit!.photoRecu ?? '';
    }
  }

  @override
  void dispose() {
    _caracBienImpactesController.dispose();
    _proprioFoncController.dispose();
    _typeFoncierController.dispose();
    _typeLotissementController.dispose();
    _titreProprieteController.dispose();
    _autreTitrePropController.dispose();
    _numIlotController.dispose();
    _numLotController.dispose();
    _surfaceLotParcelleController.dispose();
    _surfaceImpacteeController.dispose();
    _statutOccupationController.dispose();
    _modeAcquisitionController.dispose();
    _autreModeAcqFoncController.dispose();
    _anneeAcqFoncController.dispose();
    _montantAcqFoncController.dispose();
    _loyerMensController.dispose();
    _loyerMensPercuBailController.dispose();
    _nomPropEnLocationFoncController.dispose();
    _contactPropEnLocationController.dispose();
    _photoDocFoncierController.dispose();
    _numBatiController.dispose();
    _identifiantBatiController.dispose();
    _typeConstructionController.dispose();
    _statutOccBatiController.dispose();
    _modeAcqBatiController.dispose();
    _nbreNiveauController.dispose();
    _nbreAppartController.dispose();
    _materiauConstController.dispose();
    _partieBatiImpactController.dispose();
    _niveauAchController.dispose();
    _nbrePieceBatiController.dispose();
    _typeComoditeController.dispose();
    _modeEvacEauUseesController.dispose();
    _autreGestEauxUseesController.dispose();
    _modeRamOrduresController.dispose();
    _autreGestRamasOrdureController.dispose();
    _autreFctBatiController.dispose();
    _anneeConstBatiController.dispose();
    _coutConstBatiController.dispose();
    _loyerMensPayeController.dispose();
    _loyerMensPercuController.dispose();
    _photoQuittanceController.dispose();
    _nomPropEnLocationController.dispose();
    _numeroPropEnLocationBatiController.dispose();
    _typeActExerController.dispose();
    _autreActImpacteeController.dispose();
    _lieuExcerActiController.dispose();
    _anneeInstallSiteController.dispose();
    _lieuPrincApproviController.dispose();
    _origineClientController.dispose();
    _revenuMensuelTireController.dispose();
    _totalSalEmpController.dispose();
    _lesquellesTaxesController.dispose();
    _autreTaxeController.dispose();
    _freqPayeTaxeController.dispose();
    _montantPayeActivCommController.dispose();
    _denominatiEntrepriseController.dispose();
    _formJuridiqController.dispose();
    _numRccmController.dispose();
    _nccController.dispose();
    _regimeImpositionController.dispose();
    _situationGeoController.dispose();
    _produitServiceController.dispose();
    _dateCreaEntreController.dispose();
    _totalSalaireEmployeEntrepController.dispose();
    _dateDebutActiController.dispose();
    _chifAffaiMensuelController.dispose();
    _localEntDetruitController.dispose();
    _localPartDetruitController.dispose();
    _travauxImpactController.dispose();
    _nbrePersTravailleurController.dispose();
    _imgActiviteController.dispose();
    _typeCultureController.dispose();
    _ageCultureController.dispose();
    _statuFoncAgricoleController.dispose();
    _modeAcquisitionFoncController.dispose();
    _supParcelleAgricoleOuPiedController.dispose();
    _supImpacteAgricController.dispose();
    _maturiteSaisonRecoltController.dispose();
    _rendCultuDernRecolteController.dispose();
    _revenuCommercialisationController.dispose();
    _destinProduitController.dispose();
    _lieuCommercialisationController.dispose();
    _autreLieuCommerceController.dispose();
    _montantCommercialisationController.dispose();
    _superfParcelDispoController.dispose();
    _nbrEmplyeAgricoleController.dispose();
    _totalSalaireEmployeAgricoleController.dispose();
    _denomiEquipCollecController.dispose();
    _statuEquipCollecController.dispose();
    _autreStatutEquipementController.dispose();
    _caractEquipCollecController.dispose();
    _autreCaracEquipementController.dispose();
    _anneeInstSiteController.dispose();
    _nbrePersFreqController.dispose();
    _lieuProvPersController.dispose();
    _nbrEmplyeEquipController.dispose();
    _revenuMensuelEquipLucratifController.dispose();
    _preferenceIndemnController.dispose();
    _continuerMemActiviteController.dispose();
    _ouiAppuiSouhaiteController.dispose();
    _autreAppuiSouhaiteController.dispose();
    _nonAppuiNvlleActivController.dispose();
    _appuiDuProjController.dispose();
    _domaineFormationController.dispose();
    _listerTypeIntrantController.dispose();
    _gpsBatiController.dispose();
    _photoRecuController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categorie == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez choisir une catégorie')));
      return;
    }

    final bien = BienImpacte(
      id: widget.bienToEdit?.id,
      idPap: widget.idPap,
      categorie: _categorie,
      caracBienImpactes: _caracBienImpactesController.text,
      proprioFonc: _proprioFoncController.text,
      typeFoncier: _typeFoncierController.text,
      typeLotissement: _typeLotissementController.text,
      titrePropriete: _titreProprieteController.text,
      autreTitreProp: _autreTitrePropController.text,
      numIlot: _numIlotController.text,
      numLot: _numLotController.text,
      surfaceLotParcelle: double.tryParse(_surfaceLotParcelleController.text),
      surfaceImpactee: double.tryParse(_surfaceImpacteeController.text),
      statutOccupation: _statutOccupationController.text,
      modeAcquisition: _modeAcquisitionController.text,
      autreModeAcqFonc: _autreModeAcqFoncController.text,
      anneeAcqFonc: int.tryParse(_anneeAcqFoncController.text),
      montantAcqFonc: double.tryParse(_montantAcqFoncController.text),
      loyerMens: double.tryParse(_loyerMensController.text),
      loyerMensPercuBail: double.tryParse(_loyerMensPercuBailController.text),
      nomPropEnLocationFonc: _nomPropEnLocationFoncController.text,
      contactPropEnLocation: _contactPropEnLocationController.text,
      photoDocFoncier: _photoDocFoncierController.text,
      numBati: _numBatiController.text,
      identifiantBati: _identifiantBatiController.text,
      typeConstruction: _typeConstructionController.text,
      statutOccBati: _statutOccBatiController.text,
      modeAcqBati: _modeAcqBatiController.text,
      nbreNiveau: int.tryParse(_nbreNiveauController.text),
      nbreAppart: int.tryParse(_nbreAppartController.text),
      materiauConst: _materiauConstController.text,
      partieBatiImpact: _partieBatiImpactController.text,
      niveauAch: _niveauAchController.text,
      nbrePieceBati: int.tryParse(_nbrePieceBatiController.text),
      typeComodite: _typeComoditeController.text,
      modeEvacEauUsees: _modeEvacEauUseesController.text,
      autreGestEauxUsees: _autreGestEauxUseesController.text,
      modeRamOrdures: _modeRamOrduresController.text,
      autreGestRamasOrdure: _autreGestRamasOrdureController.text,
      autreFctBati: _autreFctBatiController.text,
      anneeConstBati: int.tryParse(_anneeConstBatiController.text),
      coutConstBati: double.tryParse(_coutConstBatiController.text),
      loyerMensPaye: double.tryParse(_loyerMensPayeController.text),
      loyerMensPercu: double.tryParse(_loyerMensPercuController.text),
      photoQuittance: _photoQuittanceController.text,
      nomPropEnLocation: _nomPropEnLocationController.text,
      numeroPropEnLocationBati: _numeroPropEnLocationBatiController.text,
      isActiviteFormelle: _isActiviteFormelle,
      typeActExer: _typeActExerController.text,
      autreActImpactee: _autreActImpacteeController.text,
      lieuExcerActi: _lieuExcerActiController.text,
      anneeInstallSite: int.tryParse(_anneeInstallSiteController.text),
      lieuPrincApprovi: _lieuPrincApproviController.text,
      origineClient: _origineClientController.text,
      revenuMensuelTire: double.tryParse(_revenuMensuelTireController.text),
      totalSalEmp: _totalSalEmpController.text,
      isPayeTaxe: _isPayeTaxe,
      lesquellesTaxes: _lesquellesTaxesController.text,
      autreTaxe: _autreTaxeController.text,
      freqPayeTaxe: _freqPayeTaxeController.text,
      montantPayeActivComm: double.tryParse(_montantPayeActivCommController.text),
      denominatiEntreprise: _denominatiEntrepriseController.text,
      presenceEnseigne: _presenceEnseigne,
      formJuridiq: _formJuridiqController.text,
      numRccm: _numRccmController.text,
      ncc: _nccController.text,
      regimeImposition: _regimeImpositionController.text,
      situationGeo: _situationGeoController.text,
      produitService: _produitServiceController.text,
      dateCreaEntre: _dateCreaEntreController.text,
      totalSalaireEmployeEntrep: double.tryParse(_totalSalaireEmployeEntrepController.text),
      dateDebutActi: _dateDebutActiController.text,
      chifAffaiMensuel: double.tryParse(_chifAffaiMensuelController.text),
      localEntDetruit: _localEntDetruitController.text,
      localPartDetruit: _localPartDetruitController.text,
      travauxImpact: _travauxImpactController.text,
      nbrePersTravailleur: int.tryParse(_nbrePersTravailleurController.text),
      imgActivite: _imgActiviteController.text,
      typeCulture: _typeCultureController.text,
      ageCulture: int.tryParse(_ageCultureController.text),
      statuFoncAgricole: _statuFoncAgricoleController.text,
      modeAcquisitionFonc: _modeAcquisitionFoncController.text,
      autreModeAcquisFonc: _autreModeAcquisFonc,
      supParcelleAgricoleOuPied: _supParcelleAgricoleOuPiedController.text,
      supImpacteAgric: _supImpacteAgricController.text,
      maturiteSaisonRecolt: _maturiteSaisonRecoltController.text,
      rendCultuDernRecolte: _rendCultuDernRecolteController.text,
      revenuCommercialisation: double.tryParse(_revenuCommercialisationController.text),
      destinProduit: _destinProduitController.text,
      lieuCommercialisation: _lieuCommercialisationController.text,
      autreLieuCommerce: _autreLieuCommerceController.text,
      montantCommercialisation: double.tryParse(_montantCommercialisationController.text),
      isParcelle: _isParcelle,
      superfParcelDispo: double.tryParse(_superfParcelDispoController.text),
      nbrEmplyeAgricole: int.tryParse(_nbrEmplyeAgricoleController.text),
      totalSalaireEmployeAgricole: double.tryParse(_totalSalaireEmployeAgricoleController.text),
      denomiEquipCollec: _denomiEquipCollecController.text,
      statuEquipCollec: _statuEquipCollecController.text,
      autreStatutEquipement: _autreStatutEquipementController.text,
      caractEquipCollec: _caractEquipCollecController.text,
      autreCaracEquipement: _autreCaracEquipementController.text,
      anneeInstSite: int.tryParse(_anneeInstSiteController.text),
      nbrePersFreq: int.tryParse(_nbrePersFreqController.text),
      lieuProvPers: _lieuProvPersController.text,
      nbrEmplyeEquip: int.tryParse(_nbrEmplyeEquipController.text),
      revenuMensuelEquipLucratif: double.tryParse(_revenuMensuelEquipLucratifController.text),
      preferenceIndemn: _preferenceIndemnController.text,
      continuerMemActivite: _continuerMemActiviteController.text,
      ouiAppuiSouhaite: _ouiAppuiSouhaiteController.text,
      autreAppuiSouhaite: _autreAppuiSouhaiteController.text,
      nonAppuiNvlleActiv: _nonAppuiNvlleActivController.text,
      isConnaisance: _isConnaisance,
      appuiDuProj: _appuiDuProjController.text,
      domaineFormation: _domaineFormationController.text,
      listerTypeIntrant: _listerTypeIntrantController.text,
      gpsBati: _gpsBatiController.text,
      photoRecu: _photoRecuController.text,
      createdAt: widget.bienToEdit?.createdAt ?? DateTime.now(),
      syncStatus: 'local',
    );

    if (bien.id != null) {
      await _dbHelper.updateBienImpacte(bien);
    } else {
      await _dbHelper.insertBienImpacte(bien);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bien sauvegardé avec succès !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
      Navigator.pop(context, true);
    }
  }





  // Pour générer le UI dynamiquement, on va utiliser une liste simple pour le moment

  // --- UI Helpers ---
  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E224A))),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCategoryPills() {
    final categories = [
      {'id': 'Foncier', 'label': 'Foncier', 'icon': Icons.landscape},
      {'id': 'Bati', 'label': 'Bâti / Logement', 'icon': Icons.home_work},
      {'id': 'Agricole', 'label': 'Agricole', 'icon': Icons.agriculture},
      {'id': 'ActiviteCommerciale', 'label': 'Activité Commerciale', 'icon': Icons.storefront},
      {'id': 'Equipement', 'label': 'Équipement Collectif', 'icon': Icons.account_balance},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((cat) {
        final isSelected = _categorie == cat['id'];
        return InkWell(
          onTap: () => setState(() => _categorie = cat['id'] as String),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE1660B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFE1660B) : Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: const Color(0xFFE1660B).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat['icon'] as IconData, size: 20, color: isSelected ? Colors.white : Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  cat['label'] as String,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFFE1660B)) : const Icon(Icons.edit, color: Color(0xFFE1660B)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE1660B), width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
  Widget _buildBoolField(String label, bool? value, Function(bool?) onChanged) {
    return PremiumSingleSelect<bool>(
      value: value,
      label: label,
      icon: Icons.check_circle_outline,
      items: const [
        DropdownMenuItem(value: true, child: Text('Oui')),
        DropdownMenuItem(value: false, child: Text('Non')),
      ],
      onChanged: onChanged,
    );
  }
  
  Widget _buildSingleSelect(String label, String? value, List<String> options, IconData icon, Function(String?) onChanged) {
    return PremiumSingleSelect<String>(
      value: value,
      label: label,
      icon: icon,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      showSearch: options.length > 8,
    );
  }

  Widget _buildMultiSelect(String label, String? value, List<String> options, IconData icon, Function(String?) onChanged) {
    return PremiumMultiSelect(
      initialValue: value,
      label: label,
      icon: icon,
      items: options,
      onChanged: onChanged,
      showSearch: options.length > 8,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Enregistrement Bien Impacté', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E224A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      title: 'Sélectionnez la catégorie',
                      children: [
                        const Text('Quelle est la nature du bien impacté par le projet ?', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        _buildCategoryPills(),
                      ],
                    ),
                    
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: _categorie == null 
                        ? const SizedBox.shrink() 
                        : _buildSectionCard(
                            title: 'Détails du $_categorie',
                            children: _buildDynamicFields(),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Save Button
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFFE1660B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('ENREGISTRER LE BIEN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDynamicFields() {
    if (_categorie == 'Foncier') {
      return [
        _buildMultiSelect('Caractéristiques du bien impacté', _caracBienImpactesController.text, ['Nu', 'Clôturé', 'Bâti', 'En culture', 'Autre'], Icons.description, (v) => setState(() => _caracBienImpactesController.text = v ?? '')),
        _buildTextField(_proprioFoncController, 'Propriétaire Foncier', icon: Icons.person),
        _buildSingleSelect('Type de foncier', _typeFoncierController.text.isEmpty ? null : _typeFoncierController.text, ['Urbain', 'Rural'], Icons.landscape, (v) => setState(() => _typeFoncierController.text = v ?? '')),
        _buildSingleSelect('Type de lotissement', _typeLotissementController.text.isEmpty ? null : _typeLotissementController.text, ['Lotissement approuvé', 'Lotissement non approuvé', 'Villageois', 'Autre'], Icons.map, (v) => setState(() => _typeLotissementController.text = v ?? '')),
        _buildSingleSelect('Titre de propriété', _titreProprieteController.text.isEmpty ? null : _titreProprieteController.text, ['ACD', 'Attestation villageoise', 'Lettre d\'attribution', 'Aucun', 'Autre'], Icons.insert_drive_file, (v) => setState(() => _titreProprieteController.text = v ?? '')),
        if (_titreProprieteController.text == 'Autre') _buildTextField(_autreTitrePropController, 'Autre titre de propriété'),
        _buildTextField(_numIlotController, 'Numéro d\'îlot'),
        _buildTextField(_numLotController, 'Numéro de lot'),
        _buildTextField(_surfaceLotParcelleController, 'Surface totale de la parcelle (m²)', isNumber: true, icon: Icons.square_foot),
        _buildTextField(_surfaceImpacteeController, 'Surface impactée (m²)', isNumber: true, icon: Icons.straighten),
        _buildSingleSelect('Statut d\'occupation', _statutOccupationController.text.isEmpty ? null : _statutOccupationController.text, ['Propriétaire', 'Locataire', 'Hébergé gratuit', 'Squatter'], Icons.supervised_user_circle, (v) => setState(() => _statutOccupationController.text = v ?? '')),
        _buildSingleSelect('Mode d\'acquisition', _modeAcquisitionController.text.isEmpty ? null : _modeAcquisitionController.text, ['Achat', 'Héritage', 'Don', 'Attribution', 'Autre'], Icons.handshake, (v) => setState(() => _modeAcquisitionController.text = v ?? '')),
        _buildTextField(_anneeAcqFoncController, 'Année d\'acquisition', isNumber: true, icon: Icons.calendar_today),
        _buildTextField(_montantAcqFoncController, 'Montant d\'acquisition (FCFA)', isNumber: true, icon: Icons.payments),
        _buildTextField(_loyerMensController, 'Loyer mensuel payé (FCFA)', isNumber: true),
        _buildTextField(_loyerMensPercuBailController, 'Loyer mensuel perçu (FCFA)', isNumber: true),
      ];
    } else if (_categorie == 'Bati') {
      return [
        _buildMultiSelect('Caractéristiques', _caracBienImpactesController.text, ['Achevé', 'Inachevé', 'En ruine', 'Clôturé'], Icons.description, (v) => setState(() => _caracBienImpactesController.text = v ?? '')),
        _buildTextField(_numBatiController, 'Numéro du Bâti', icon: Icons.numbers),
        _buildTextField(_identifiantBatiController, 'Identifiant Bâti', icon: Icons.tag),
        _buildSingleSelect('Type de construction', _typeConstructionController.text.isEmpty ? null : _typeConstructionController.text, ['Villa', 'Bande', 'Maison commune', 'Baraque', 'Autre'], Icons.home_work, (v) => setState(() => _typeConstructionController.text = v ?? '')),
        _buildSingleSelect('Statut occupation', _statutOccBatiController.text.isEmpty ? null : _statutOccBatiController.text, ['Propriétaire résident', 'Propriétaire non résident', 'Locataire', 'Hébergé gratuit'], Icons.person, (v) => setState(() => _statutOccBatiController.text = v ?? '')),
        _buildTextField(_nbreNiveauController, 'Nombre de niveaux (Étages)', isNumber: true, icon: Icons.layers),
        _buildTextField(_nbreAppartController, 'Nombre d\'appartements', isNumber: true, icon: Icons.meeting_room),
        _buildMultiSelect('Matériaux de construction', _materiauConstController.text, ['Ciment/Béton', 'Briques en terre', 'Bois', 'Tôle', 'Banco', 'Autre'], Icons.foundation, (v) => setState(() => _materiauConstController.text = v ?? '')),
        _buildMultiSelect('Partie du bâti impactée', _partieBatiImpactController.text, ['Bâtiment principal', 'Annexe', 'Clôture', 'Boutique intégrée', 'Toilettes externes', 'Autre'], Icons.broken_image, (v) => setState(() => _partieBatiImpactController.text = v ?? '')),
        _buildMultiSelect('Commodités du Bâti', _typeComoditeController.text, ['Eau courante (CIE/SODECI)', 'Électricité', 'Puits', 'Forage', 'Aucune'], Icons.offline_bolt, (v) => setState(() => _typeComoditeController.text = v ?? '')),
        _buildTextField(_nbrePieceBatiController, 'Nombre de pièces', isNumber: true),
        _buildTextField(_anneeConstBatiController, 'Année de construction', isNumber: true, icon: Icons.calendar_today),
        _buildTextField(_coutConstBatiController, 'Coût de construction (FCFA)', isNumber: true, icon: Icons.payments),
      ];
    } else if (_categorie == 'Agricole') {
      return [
        _buildMultiSelect('Type de culture', _typeCultureController.text, ['Cacao', 'Café', 'Hévéa', 'Palmier à huile', 'Anacarde', 'Vivrier (Igname, Banane...)', 'Maraîcher', 'Autre'], Icons.eco, (v) => setState(() => _typeCultureController.text = v ?? '')),
        _buildTextField(_ageCultureController, 'Âge de la culture (Années)', icon: Icons.history),
        _buildSingleSelect('Statut foncier agricole', _statuFoncAgricoleController.text.isEmpty ? null : _statuFoncAgricoleController.text, ['Propriétaire coutumier', 'Propriétaire avec titre', 'Locataire/Fermier', 'Métayer (Aboussan/Abouda)', 'Autre'], Icons.gavel, (v) => setState(() => _statuFoncAgricoleController.text = v ?? '')),
        _buildSingleSelect('Mode d\'acquisition', _modeAcquisitionFoncController.text.isEmpty ? null : _modeAcquisitionFoncController.text, ['Héritage', 'Achat', 'Don', 'Location', 'Autre'], Icons.handshake, (v) => setState(() => _modeAcquisitionFoncController.text = v ?? '')),
        _buildMultiSelect('Intrants utilisés', _listerTypeIntrantController.text, ['Engrais', 'Pesticides', 'Semences améliorées', 'Aucun'], Icons.science, (v) => setState(() => _listerTypeIntrantController.text = v ?? '')),
        _buildTextField(_supParcelleAgricoleOuPiedController, 'Superficie de la parcelle / Nb de pieds', icon: Icons.square_foot),
        _buildTextField(_supImpacteAgricController, 'Superficie impactée', icon: Icons.straighten),
        _buildTextField(_maturiteSaisonRecoltController, 'Maturité / Saison de récolte', icon: Icons.calendar_month),
        _buildTextField(_rendCultuDernRecolteController, 'Rendement dernière récolte'),
        _buildTextField(_revenuCommercialisationController, 'Revenu de commercialisation (FCFA)', isNumber: true, icon: Icons.payments),
        _buildSingleSelect('Destination du produit', _destinProduitController.text.isEmpty ? null : _destinProduitController.text, ['Autoconsommation', 'Vente partielle', 'Vente totale'], Icons.shopping_cart, (v) => setState(() => _destinProduitController.text = v ?? '')),
        _buildTextField(_nbrEmplyeAgricoleController, 'Nombre d\'employés agricoles', isNumber: true, icon: Icons.people),
      ];
    } else if (_categorie == 'ActiviteCommerciale') {
      return [
        _buildBoolField('Activité formelle ?', _isActiviteFormelle, (v) => setState(() => _isActiviteFormelle = v ?? false)),
        _buildMultiSelect('Type d\'activité exercée', _typeActExerController.text, ['Commerce de détail', 'Artisanat', 'Restauration/Maquis', 'Prestation de services', 'Transport', 'Autre'], Icons.store, (v) => setState(() => _typeActExerController.text = v ?? '')),
        _buildTextField(_denominatiEntrepriseController, 'Dénomination de l\'entreprise', icon: Icons.business),
        _buildTextField(_lieuExcerActiController, 'Lieu d\'exercice', icon: Icons.place),
        _buildTextField(_anneeInstallSiteController, 'Année d\'installation', isNumber: true, icon: Icons.calendar_today),
        _buildTextField(_revenuMensuelTireController, 'Revenu mensuel tiré (FCFA)', isNumber: true, icon: Icons.payments),
        _buildBoolField('Payez-vous des taxes ?', _isPayeTaxe, (v) => setState(() => _isPayeTaxe = v ?? false)),
        if (_isPayeTaxe == true) _buildMultiSelect('Lesquelles taxes ?', _lesquellesTaxesController.text, ['Patente', 'Impôt synthétique', 'Taxe communale/Mairie', 'Autre'], Icons.receipt_long, (v) => setState(() => _lesquellesTaxesController.text = v ?? '')),
        if (_isPayeTaxe == true) _buildTextField(_montantPayeActivCommController, 'Montant des taxes payées', isNumber: true),
        _buildTextField(_totalSalaireEmployeEntrepController, 'Masse salariale employés (FCFA)', isNumber: true, icon: Icons.money),
      ];
    } else if (_categorie == 'Equipement') {
      return [
        _buildTextField(_denomiEquipCollecController, 'Dénomination de l\'équipement', icon: Icons.account_balance),
        _buildTextField(_statuEquipCollecController, 'Statut de l\'équipement', icon: Icons.info),
        _buildTextField(_caractEquipCollecController, 'Caractéristiques', icon: Icons.description),
        _buildTextField(_anneeInstSiteController, 'Année d\'installation', isNumber: true, icon: Icons.calendar_today),
        _buildTextField(_nbrePersFreqController, 'Nombre de personnes fréquentant', isNumber: true, icon: Icons.people),
        _buildTextField(_revenuMensuelEquipLucratifController, 'Revenus générés (si lucratif)', isNumber: true, icon: Icons.payments),
      ];
    }
    return [const Text('Sélectionnez une catégorie pour afficher les champs.')];
  }
}
