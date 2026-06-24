import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
import '../widgets/custom_segmented_bool.dart';
import '../models/extended_models.dart';
import '../services/database_helper.dart';

class LogementFormScreen extends StatefulWidget {
  final String idPap;
  const LogementFormScreen({super.key, required this.idPap});

  @override
  State<LogementFormScreen> createState() => _LogementFormScreenState();
}

class _LogementFormScreenState extends State<LogementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  
  String? _statutOccupation;
  String? _typeBatiment;
  String? _materiauMur;
  String? _materiauSol;
  String? _materiauToit;
  String? _sourceEau;
  String? _typeToilette;
  String? _energieCuisson;
  String? _energieEclairage;
  final _nbPiecesController = TextEditingController();

  final _montantLoyerController = TextEditingController();
  final _nomProprietaireController = TextEditingController();
  final _contactProprietaireController = TextEditingController();
  String? _dureeLocation;
  bool _aPayeCaution = false;
  final _moisCautionController = TextEditingController();
  final _montantCautionController = TextEditingController();
  String? _modeAcquisitionTerrain;
  
  String? _aMisEnLocation = 'Non';
  final _nbMoisLocationController = TextEditingController();
  final _revenusLocationController = TextEditingController();

  final _autreSanitaireController = TextEditingController();
  String? _srcCombustion;
  final _autreSourceCombustionController = TextEditingController();
  String? _srcEau;
  final _anneeUtilEauController = TextEditingController();
  final _distMoyDomEauController = TextEditingController();
  final _montantDepEauController = TextEditingController();
  String? _principaleSrcEclair;
  String? _typeReseauElec;
  final _autreTypeReseauElecController = TextEditingController();
  final _anConReseauElecController = TextEditingController();
  final _montantDepConsoEnergieController = TextEditingController();
  final _periodeAnCoupureController = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    final data = {
      'idPap': widget.idPap,
      'statutOccupation': _statutOccupation,
      'typeBatiment': _typeBatiment,
      'materiauMur': _materiauMur,
      'materiauSol': _materiauSol,
      'materiauToit': _materiauToit,
      'sourceEau': _srcEau ?? _sourceEau,
      'typeToilette': _typeToilette,
      'energieCuisson': _srcCombustion ?? _energieCuisson,
      'energieEclairage': _principaleSrcEclair ?? _energieEclairage,
      'nbPieces': int.tryParse(_nbPiecesController.text),
      'montantLoyer': double.tryParse(_montantLoyerController.text),
      'nomProprietaire': _nomProprietaireController.text,
      'contactProprietaire': _contactProprietaireController.text,
      'dureeLocation': _dureeLocation,
      'aPayeCaution': _aPayeCaution ? 1 : 0,
      'moisCaution': int.tryParse(_moisCautionController.text),
      'montantCaution': double.tryParse(_montantCautionController.text),
      'modeAcquisitionTerrain': _modeAcquisitionTerrain,
      'aMisEnLocation': _aMisEnLocation,
      'nbMoisLocation': int.tryParse(_nbMoisLocationController.text),
      'revenusLocation': double.tryParse(_revenusLocationController.text),
      
      'autreSanitaire': _autreSanitaireController.text,
      'srcCombustion': _srcCombustion,
      'autreSourceCombustion': _autreSourceCombustionController.text,
      'srcEau': _srcEau,
      'anneeUtilEau': int.tryParse(_anneeUtilEauController.text),
      'distMoyDomEau': double.tryParse(_distMoyDomEauController.text),
      'montantDepEau': double.tryParse(_montantDepEauController.text),
      'principaleSrcEclair': _principaleSrcEclair,
      'typeReseauElec': _typeReseauElec,
      'autreTypeReseauElec': _autreTypeReseauElecController.text,
      'anConReseauElec': int.tryParse(_anConReseauElecController.text),
      'montantDepConsoEnergie': double.tryParse(_montantDepConsoEnergieController.text),
      'periodeAnCoupure': int.tryParse(_periodeAnCoupureController.text),

      'createdAt': DateTime.now().toIso8601String(),
      'syncStatus': 'local',
    };

    await _dbHelper.insertLogement(data);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logement enregistré localement.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
      Navigator.pop(context, true);
    }
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
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

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
      ),
    );
  }

  Widget _buildBoolField(String label, String? value, Function(String?) onChanged) {
    return PremiumSingleSelect<String>(
      value: value,
      label: label,
      icon: Icons.check_circle_outline,
      items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Logement & Commodités', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E224A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSectionCard(
                      title: 'Occupation et Location',
                      children: [
                        PremiumSingleSelect<String>(
  value: _statutOccupation,
  label: "Statut d\'occupation",
  icon: Icons.vpn_key,
  items: ['Locataire', 'Propriétaire', 'Occupation sur bail', 'Hébergé gratuit'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) {},
),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _statutOccupation == 'Locataire' ? Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildTextField(_montantLoyerController, 'Montant mensuel de location (FCFA)', isNumber: true, icon: Icons.attach_money),
                              _buildTextField(_nomProprietaireController, 'Nom du propriétaire', icon: Icons.person),
                              _buildTextField(_contactProprietaireController, 'Contact du propriétaire', isNumber: true, icon: Icons.phone),
                              PremiumSingleSelect<String>(
  value: _dureeLocation,
  label: 'Depuis quand habitez-vous ici ?',
  icon: Icons.timer,
  items: ['moins d\'1 an', 'Entre 1 et 3 ans', 'Plus de 3 ans'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _dureeLocation = v),
),
                              const SizedBox(height: 16),
                              CustomSegmentedBool(
  label: 'Avez-vous payé une caution ?',
  value: _aPayeCaution,
  onChanged: (v) => setState(() => _aPayeCaution = v),
),
                              if (_aPayeCaution) ...[
                                _buildTextField(_moisCautionController, 'Combien de mois ?', isNumber: true, icon: Icons.calendar_today),
                                _buildTextField(_montantCautionController, 'Montant de la caution', isNumber: true, icon: Icons.payments),
                              ],
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _statutOccupation == 'Propriétaire' ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: PremiumSingleSelect<String>(
  value: _modeAcquisitionTerrain,
  label: "Mode d\'acquisition",
  icon: Icons.real_estate_agent,
  items: ['Achat', 'Lèg', 'Bien de la famille (Filière coutumière)', 'Don', 'Héritage', 'Location', 'Occupation informelle', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _modeAcquisitionTerrain = v),
),
                          ) : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 16),
                        _buildBoolField('Bâtiment mis en location en 2023 ?', _aMisEnLocation, (v) => setState(() => _aMisEnLocation = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _aMisEnLocation == 'Oui' ? Column(
                            children: [
                              _buildTextField(_nbMoisLocationController, 'Combien de mois ?', isNumber: true),
                              _buildTextField(_revenusLocationController, 'Loyers cumulés par an (FCFA)', isNumber: true),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Matériaux du Bâtiment',
                      children: [
                        PremiumSingleSelect<String>(
  value: _typeBatiment,
  label: 'Type de bâtiment',
  icon: Icons.home_work,
  items: ['Construction individuelle', 'Cour commune/Concession', 'Construction en bande', 'Immeuble', 'Baraque', 'Hangar', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _typeBatiment = v),
),
                        const SizedBox(height: 16),
                        PremiumSingleSelect<String>(
  value: _materiauMur,
  label: 'Matériau des murs',
  icon: Icons.wallpaper,
  items: ['Ciment', 'Béton', 'Banco', 'Brique', 'Bois', 'Tôle', 'Tôle d\'aluminium', 'Blocs de béton', 'Piliers en bois', 'Matériaux de récupération', 'Pierres', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _materiauMur = v),
),
                        const SizedBox(height: 16),
                        PremiumSingleSelect<String>(
  value: _materiauToit,
  label: 'Matériau du toit',
  icon: Icons.roofing,
  items: ['Bâches et toitures en tôle', 'toiture en tôle récente', 'ancienne toiture en tôle', 'Dalle en béton', 'Bois', 'Tuile', 'Paille', 'Palmier/Raffia', 'Ardoise', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _materiauToit = v),
),
                        const SizedBox(height: 16),
                        PremiumSingleSelect<String>(
  value: _materiauSol,
  label: 'Matériau du sol',
  icon: Icons.layers,
  items: ['Ciment', 'Béton', 'Sol en carreaux', 'Sol en, terre', 'Terre cuite', 'Bois', 'Pavés', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _materiauSol = v),
),
                        const SizedBox(height: 16),
                        _buildTextField(_nbPiecesController, 'Nombre de pièces', isNumber: true, icon: Icons.meeting_room),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Commodités (Eau & Assainissement)',
                      children: [
                        PremiumSingleSelect<String>(
  value: _srcEau,
  label: "Source d\'énergie",
  icon: Icons.water_drop,
  items: ['Pompe villageoise', 'Borne fontaine', 'Robinet public', 'Eau de SODECI à la maison', 'Eau de la SODECI chez un privé', 'Forage privé', 'Puits protégés (busés)', 'Puisards (non busés)', 'Eau de pluie', 'Bouteille', 'Rivière/marigot', 'Camion-citerne', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _srcEau = v),
),
                        const SizedBox(height: 16),
                        _buildTextField(_anneeUtilEauController, 'Année d\'utilisation de cette source', isNumber: true, icon: Icons.calendar_month),
                        _buildTextField(_distMoyDomEauController, 'Distance domicile - source (m)', isNumber: true, icon: Icons.map),
                        _buildTextField(_montantDepEauController, 'Dépense mensuelle en eau (FCFA)', isNumber: true, icon: Icons.attach_money),
                        PremiumSingleSelect<String>(
  value: _typeToilette,
  label: 'Type de toilettes',
  icon: Icons.wc,
  items: ['Pas de latrine (à l\'air libre)', 'Latrines traditionnelles (sans fosse)', 'Latrines améliorées (fosse, ventilation, dalle)', 'Toilette avec chasse d\'eau', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _typeToilette = v),
),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _typeToilette == 'Autre' ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: _buildTextField(_autreSanitaireController, 'Précisez l\'autre sanitaire'),
                          ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Commodités (Énergie)',
                      children: [
                        PremiumSingleSelect<String>(
  value: _srcCombustion,
  label: 'Énergie de cuisson',
  icon: Icons.fireplace,
  items: ['Charbon de bois', 'bois', 'gaz butane', 'plaque électrique', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _srcCombustion = v),
),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _srcCombustion == 'Autre' ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: _buildTextField(_autreSourceCombustionController, 'Autre énergie de cuisson'),
                          ) : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 16),
                        PremiumSingleSelect<String>(
  value: _principaleSrcEclair,
  label: "Énergie d\'éclairage",
  icon: Icons.lightbulb,
  items: ['Aucun', 'Groupe électrogène', 'Panneau solaire', 'Batterie', 'CIE', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _principaleSrcEclair = v),
),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _principaleSrcEclair == 'CIE' ? Column(
                            children: [
                              const SizedBox(height: 16),
                              PremiumSingleSelect<String>(
  value: _typeReseauElec,
  label: 'Type de réseau électrique',
  icon: Icons.list,
  items: ['Réseau public', 'Compteur individuel', 'Compteur partagé', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _typeReseauElec = v),
),
                              if (_typeReseauElec == 'Autre') Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: _buildTextField(_autreTypeReseauElecController, 'Autre réseau électrique'),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(_anConReseauElecController, 'Année de connexion au réseau', isNumber: true),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(_montantDepConsoEnergieController, 'Dépense mensuelle en énergie', isNumber: true, icon: Icons.payments),
                        _buildTextField(_periodeAnCoupureController, 'Jours de coupure (an)', isNumber: true, icon: Icons.power_off),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1660B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('ENREGISTRER', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
