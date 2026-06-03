import 'package:flutter/material.dart';
import '../models/sante.dart';
import '../models/education.dart';
import '../services/database_helper.dart';

class SanteEducationFormScreen extends StatefulWidget {
  final String idPap;
  const SanteEducationFormScreen({super.key, required this.idPap});

  @override
  State<SanteEducationFormScreen> createState() => _SanteEducationFormScreenState();
}

class _SanteEducationFormScreenState extends State<SanteEducationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  
  // Santé
  final _distanceDomSanteController = TextEditingController();
  final _assureurController = TextEditingController();
  final _tauxCouvertureController = TextEditingController();
  final _nbrPersMaladeController = TextEditingController();
  
  String? _isAssurance = 'Non';
  String? _typeSoinMen = 'Hôpital public';

  // Education
  final _nbEnftScolariseController = TextEditingController();
  final _distanceDomEcolePrimController = TextEditingController();

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      // 1. Sauvegarde Santé
      final sante = Sante(
        idPap: widget.idPap,
        distanceDomSante: int.tryParse(_distanceDomSanteController.text),
        isAssurance: _isAssurance == 'Oui',
        assureur: _assureurController.text,
        tauxCouverture: double.tryParse(_tauxCouvertureController.text),
        nbrPersMalade: int.tryParse(_nbrPersMaladeController.text),
        typeSoinMen: _typeSoinMen,
        createdAt: DateTime.now(),
        syncStatus: 'local',
      );
      await _dbHelper.insertSante(sante);

      // 2. Sauvegarde Education
      final education = Education(
        idPap: widget.idPap,
        nbEnftScolarise: int.tryParse(_nbEnftScolariseController.text),
        distanceDomEcolePrim: int.tryParse(_distanceDomEcolePrimController.text),
        createdAt: DateTime.now(),
        syncStatus: 'local',
      );
      await _dbHelper.insertEducation(education);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Santé & Education sauvegardées !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Santé & Éducation', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF009E60),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Partie 1: Santé', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF77F00))),
              const SizedBox(height: 16),
              
              TextField(
                controller: _distanceDomSanteController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Distance vers le centre de santé (m)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _isAssurance,
                decoration: const InputDecoration(labelText: 'Avez-vous une assurance maladie ?'),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _isAssurance = v),
              ),
              const SizedBox(height: 16),

              if (_isAssurance == 'Oui') ...[
                TextField(
                  controller: _assureurController,
                  decoration: const InputDecoration(labelText: "Nom de l'assureur", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _tauxCouvertureController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Taux de couverture (%)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
              ],

              TextField(
                controller: _nbrPersMaladeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nombre de personnes malades récemment', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _typeSoinMen,
                decoration: const InputDecoration(labelText: 'Lieu de soin principal'),
                items: ['Hôpital public', 'Clinique privée', 'Tradipraticien', 'Automédication'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _typeSoinMen = v),
              ),
              
              const Divider(height: 40, thickness: 2),

              const Text('Partie 2: Éducation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF77F00))),
              const SizedBox(height: 16),

              TextField(
                controller: _nbEnftScolariseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nombre d'enfants scolarisés", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _distanceDomEcolePrimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Distance vers l'école primaire (m)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77F00),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('ENREGISTRER', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
