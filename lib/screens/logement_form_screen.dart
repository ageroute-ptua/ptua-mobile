import 'package:flutter/material.dart';
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

  // Nouveaux champs pour logique dynamique
  final _montantLoyerController = TextEditingController();
  final _nomProprietaireController = TextEditingController();
  final _contactProprietaireController = TextEditingController();
  String? _dureeLocation;
  bool _aPayeCaution = false;
  final _moisCautionController = TextEditingController();
  final _montantCautionController = TextEditingController();
  String? _modeAcquisitionTerrain;
  
  // Skip logic location
  String? _aMisEnLocation = 'Non';
  final _nbMoisLocationController = TextEditingController();
  final _revenusLocationController = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    final data = {
      'idPap': widget.idPap,
      'statutOccupation': _statutOccupation,
      'typeBatiment': _typeBatiment,
      'materiauMur': _materiauMur,
      'materiauSol': _materiauSol,
      'materiauToit': _materiauToit,
      'sourceEau': _sourceEau,
      'typeToilette': _typeToilette,
      'energieCuisson': _energieCuisson,
      'energieEclairage': _energieEclairage,
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
      'createdAt': DateTime.now().toIso8601String(),
      'syncStatus': 'local',
    };

    await _dbHelper.insertLogement(data);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logement enregistré localement.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logement & Matériaux'), backgroundColor: const Color(0xFFF77F00)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _statutOccupation,
                decoration: const InputDecoration(labelText: "Statut d'occupation du logement"),
                items: ['Locataire', 'Propriétaire', 'Occupation sur bail', 'Hébergé gratuit']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() {
                  _statutOccupation = v;
                  // Reset fields when changing status to avoid dirty data
                  _montantLoyerController.clear();
                  _nomProprietaireController.clear();
                  _contactProprietaireController.clear();
                  _dureeLocation = null;
                  _aPayeCaution = false;
                  _moisCautionController.clear();
                  _montantCautionController.clear();
                  _modeAcquisitionTerrain = null;
                }),
              ),
              const SizedBox(height: 16),
              
              if (_statutOccupation == 'Locataire') ...[
                TextFormField(
                  controller: _montantLoyerController,
                  decoration: const InputDecoration(labelText: 'Montant mensuel de location'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomProprietaireController,
                  decoration: const InputDecoration(labelText: 'Nom et prénom du propriétaire'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactProprietaireController,
                  decoration: const InputDecoration(labelText: 'Contact du propriétaire'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _dureeLocation,
                  decoration: const InputDecoration(labelText: 'Depuis combien de temps habitez-vous la maison ?'),
                  items: ['moins d\'1 an', 'Entre 1 et 3 ans', 'Plus de 3 ans']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _dureeLocation = v),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Avez-vous payé une caution avant d\'y habiter ?'),
                  value: _aPayeCaution,
                  onChanged: (v) => setState(() => _aPayeCaution = v),
                ),
                if (_aPayeCaution) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _moisCautionController,
                    decoration: const InputDecoration(labelText: 'Combien de mois de caution avez-vous payé ?'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _montantCautionController,
                    decoration: const InputDecoration(labelText: 'Cette caution s\'élève à combien ?'),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const Divider(height: 32, thickness: 2),
              ],
              
              if (_statutOccupation == 'Propriétaire') ...[
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _modeAcquisitionTerrain,
                  decoration: const InputDecoration(labelText: 'Comment avez-vous acquis le terrain ?'),
                  items: ['Achat', 'Lèg', 'Bien de la famille (Filière coutumière)', 'Don', 'Héritage', 'Location', 'Occupation informelle', 'Autre']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _modeAcquisitionTerrain = v),
                ),
                const Divider(height: 32, thickness: 2),
              ],
              
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _aMisEnLocation,
                decoration: const InputDecoration(labelText: 'Avez-vous mis en location des bâtiments/chambres en 2023 ?'),
                items: ['Oui', 'Non'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _aMisEnLocation = v),
              ),
              if (_aMisEnLocation == 'Oui') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nbMoisLocationController,
                  decoration: const InputDecoration(labelText: 'Combien de mois ?'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _revenusLocationController,
                  decoration: const InputDecoration(labelText: 'Montant cumulé des loyers reçus/attendus par an (FCFA)'),
                  keyboardType: TextInputType.number,
                ),
              ],
              const Divider(height: 32, thickness: 2),

              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _typeBatiment,
                decoration: const InputDecoration(labelText: 'Dans quel type de bâtiment logez-vous ?'),
                items: ['Construction individuelle', 'Cour commune/Concession', 'Construction en bande', 'Immeuble', 'Baraque', 'Hangar', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _typeBatiment = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _materiauMur,
                decoration: const InputDecoration(labelText: 'En quoi est fait le mur de votre maison ?'),
                items: ['Ciment', 'Béton', 'Banco', 'Brique', 'Bois', 'Tôle', 'Tôle d\'aluminium', 'Blocs de béton', 'Piliers en bois', 'Matériaux de récupération', 'Pierres', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _materiauMur = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _materiauToit,
                decoration: const InputDecoration(labelText: 'En quelle matière est fait le toit ?'),
                items: ['Bâches et toitures en tôle', 'toiture en tôle récente', 'ancienne toiture en tôle', 'Dalle en béton', 'Bois', 'Tuile', 'Paille', 'Palmier/Raffia', 'Ardoise', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _materiauToit = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _materiauSol,
                decoration: const InputDecoration(labelText: 'En quelle matière est fait le sol ?'),
                items: ['Ciment', 'Béton', 'Sol en carreaux', 'Sol en, terre', 'Terre cuite', 'Bois', 'Pavés', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _materiauSol = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nbPiecesController,
                decoration: const InputDecoration(labelText: 'Combien de pièce comporte le bâtiment (y compris le salon) ?'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _sourceEau,
                decoration: const InputDecoration(labelText: 'Source principale d\'eau de boisson / lessive'),
                items: ['Pompe villageoise', 'Borne fontaine', 'Robinet public', 'Eau de SODECI à la maison', 'Eau de la SODECI chez un privé', 'Forage privé', 'Puits protégés (busés)', 'Puisards (non busés)', 'Eau de pluie', 'Bouteille', 'Rivière/marigot', 'Camion-citerne', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _sourceEau = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _typeToilette,
                decoration: const InputDecoration(labelText: 'Type de toilettes utilisées'),
                items: ['Pas de latrine (à l\'air libre)', 'Latrines traditionnelles (sans fosse)', 'Latrines améliorées (fosse, ventilation, dalle)', 'Toilette avec chasse d\'eau', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _typeToilette = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _energieCuisson,
                decoration: const InputDecoration(labelText: 'Source d\'énergie pour la cuisson'),
                items: ['Charbon de bois', 'bois', 'gaz butane', 'plaque électrique', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _energieCuisson = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _energieEclairage,
                decoration: const InputDecoration(labelText: 'Source d\'énergie pour l\'éclairage'),
                items: ['Aucun', 'Groupe électrogène', 'Panneau solaire', 'Batterie', 'CIE', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _energieEclairage = v),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009E60)),
                onPressed: _save,
                child: const Text('ENREGISTRER', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
