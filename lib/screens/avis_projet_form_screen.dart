import 'package:flutter/material.dart';
import '../models/avis_projet.dart';
import '../services/database_helper.dart';

class AvisProjetFormScreen extends StatefulWidget {
  final String idPap;
  const AvisProjetFormScreen({super.key, required this.idPap});

  @override
  State<AvisProjetFormScreen> createState() => _AvisProjetFormScreenState();
}

class _AvisProjetFormScreenState extends State<AvisProjetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  
  String? _isAvezCraintes = 'Non';
  String? _isAvezAttentes = 'Oui';
  String? _isRecommandation = 'Non';
  
  final _penseePrjController = TextEditingController();
  final _ouiCraintesController = TextEditingController();
  final _ouiAttentesController = TextEditingController();
  final _justiAvisController = TextEditingController();

  void _saveAvis() async {
    if (_formKey.currentState!.validate()) {
      final avis = AvisProjet(
        idPap: widget.idPap,
        isAvezCraintes: _isAvezCraintes == 'Oui',
        isAvezAttentes: _isAvezAttentes == 'Oui',
        isRecommandation: _isRecommandation == 'Oui',
        penseePrj: _penseePrjController.text,
        ouiCraintes: _ouiCraintesController.text,
        ouiAttentes: _ouiAttentesController.text,
        justiAvis: _justiAvisController.text,
        createdAt: DateTime.now(),
        syncStatus: 'local',
      );

      await _dbHelper.insertAvisProjet(avis);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avis sauvegardé !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avis sur le Projet', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF009E60),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _penseePrjController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Que pensez-vous du projet ?', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _isAvezCraintes,
                decoration: const InputDecoration(labelText: 'Avez-vous des craintes ?'),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _isAvezCraintes = v),
              ),
              const SizedBox(height: 16),

              if (_isAvezCraintes == 'Oui')
                TextField(
                  controller: _ouiCraintesController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Lesquelles ?', border: OutlineInputBorder()),
                ),
              if (_isAvezCraintes == 'Oui') const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _isAvezAttentes,
                decoration: const InputDecoration(labelText: 'Avez-vous des attentes ?'),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _isAvezAttentes = v),
              ),
              const SizedBox(height: 16),

              if (_isAvezAttentes == 'Oui')
                TextField(
                  controller: _ouiAttentesController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Lesquelles ?', border: OutlineInputBorder()),
                ),
              if (_isAvezAttentes == 'Oui') const SizedBox(height: 16),

              TextField(
                controller: _justiAvisController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Justification globale', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAvis,
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
