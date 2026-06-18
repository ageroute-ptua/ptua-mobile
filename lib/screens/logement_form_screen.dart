import 'package:flutter/material.dart';
import '../models/extended_models.dart';

class LogementFormScreen extends StatefulWidget {
  final String idMenage;
  const LogementFormScreen({super.key, required this.idMenage});

  @override
  State<LogementFormScreen> createState() => _LogementFormScreenState();
}

class _LogementFormScreenState extends State<LogementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String? _statutOccupation;
  String? _typeBatiment;
  String? _materiauMur;
  String? _materiauSol;
  String? _materiauToit;
  final _nbPiecesController = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    // final infoLogement = InfoLogement( ... );
    // await _dbHelper.insertInfoLogement(infoLogement);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logement enregistré localement.')));
    Navigator.pop(context);
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
                value: _statutOccupation,
                decoration: const InputDecoration(labelText: "Statut d'occupation du logement"),
                items: ['Locataire', 'Propriétaire', 'Occupation sur bail', 'Hébergé gratuit']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _statutOccupation = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _materiauMur,
                decoration: const InputDecoration(labelText: 'En quoi est fait le mur de votre maison ?'),
                items: ['Ciment', 'Béton', 'Banco', 'Brique', 'Bois', 'Tôle', 'Tôle d\'aluminium', 'Blocs de béton', 'Piliers en bois', 'Matériaux de récupération', 'Pierres', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _materiauMur = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _materiauToit,
                decoration: const InputDecoration(labelText: 'En quelle matière est fait le toit ?'),
                items: ['Bâches et toitures en tôle', 'toiture en tôle récente', 'ancienne toiture en tôle', 'Dalle en béton', 'Bois', 'Tuile', 'Paille', 'Palmier/Raffia', 'Ardoise', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _materiauToit = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
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
