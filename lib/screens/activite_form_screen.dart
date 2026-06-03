import 'package:flutter/material.dart';
import '../models/activite.dart';
import '../services/database_helper.dart';

class ActiviteFormScreen extends StatefulWidget {
  final String idPap;
  const ActiviteFormScreen({super.key, required this.idPap});

  @override
  State<ActiviteFormScreen> createState() => _ActiviteFormScreenState();
}

class _ActiviteFormScreenState extends State<ActiviteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  
  final _activitePrincipController = TextEditingController();
  final _revenuMoyeController = TextEditingController();
  final _lieuTravailController = TextEditingController();
  final _revenuCumulController = TextEditingController();

  String? _transferArg = 'Non';
  String? _presenceActivSecondMenage = 'Non';
  String? _isParcelleHorsEmprise = 'Oui';

  void _saveActivite() async {
    if (_formKey.currentState!.validate()) {
      final activite = Activite(
        idPap: widget.idPap,
        activitePrincipMenage: _activitePrincipController.text,
        revenuMoyeActPrin: double.tryParse(_revenuMoyeController.text),
        transferArg: _transferArg == 'Oui',
        lieuTravail: _lieuTravailController.text,
        presenceActivSecondMenage: _presenceActivSecondMenage == 'Oui',
        revenuCumul: double.tryParse(_revenuCumulController.text),
        isParcelleHorsEmprise: _isParcelleHorsEmprise == 'Oui',
        createdAt: DateTime.now(),
        syncStatus: 'local',
      );

      await _dbHelper.insertActivite(activite);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activités sauvegardées !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activités & Revenus', style: TextStyle(color: Colors.white)),
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
                controller: _activitePrincipController,
                decoration: const InputDecoration(labelText: 'Activité Principale', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _revenuMoyeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Revenu moyen estimé (FCFA)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _lieuTravailController,
                decoration: const InputDecoration(labelText: 'Lieu de travail', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _presenceActivSecondMenage,
                decoration: const InputDecoration(labelText: "Présence d'activité secondaire ?"),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _presenceActivSecondMenage = v),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _revenuCumulController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Revenus cumulés du ménage (FCFA)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _transferArg,
                decoration: const InputDecoration(labelText: "Le ménage reçoit-il un transfert d'argent ?"),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _transferArg = v),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveActivite,
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
