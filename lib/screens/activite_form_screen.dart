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
  
  String? _activitePrincip;
  final _revenuMoyeController = TextEditingController();
  final _lieuTravailController = TextEditingController();
  final _revenuCumulController = TextEditingController();

  String? _transferArg = 'Non';
  String? _presenceActivSecondMenage = 'Non';
  final _activiteSecondaireController = TextEditingController();
  String? _isParcelleHorsEmprise = 'Oui';
  
  // Nouveaux champs de skip logic
  String? _payeTaxes = 'Non';
  final _quellesTaxesController = TextEditingController();
  String? _frequenceTaxes;
  
  String? _aEmployes = 'Non';
  final _nbEmployesController = TextEditingController();

  void _saveActivite() async {
    if (_formKey.currentState!.validate()) {
      final activite = Activite(
        idPap: widget.idPap,
        activitePrincipMenage: _activitePrincip,
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
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _activitePrincip,
                decoration: const InputDecoration(labelText: 'Activité Principale', border: OutlineInputBorder()),
                items: [
                  'Planteur/Cultivateur', 'Pêcheur', 'Eleveur/Fermier', 'Commerçant', 'Transporteur', 'Salarié du public', 'Salarié du privé', 'Artisan', 'Ouvrier', 'Employé', 'Elève/Etudiant', 'Femme au foyer', 'Sans emploi', 'Retraité', 'Guide religieux', 'Autres'
                ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _activitePrincip = v),
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
                isExpanded: true,
                value: _presenceActivSecondMenage,
                decoration: const InputDecoration(labelText: "Présence d'activité secondaire ?"),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _presenceActivSecondMenage = v),
              ),
              if (_presenceActivSecondMenage == 'Oui') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _activiteSecondaireController,
                  decoration: const InputDecoration(labelText: 'Laquelle ?', border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 16),

              TextField(
                controller: _revenuCumulController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Revenus cumulés du ménage (FCFA)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _transferArg,
                decoration: const InputDecoration(labelText: "Le ménage reçoit-il un transfert d'argent ?"),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _transferArg = v),
              ),
              const SizedBox(height: 16),

              const Divider(height: 32, thickness: 2),
              
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _aEmployes,
                decoration: const InputDecoration(labelText: "L'entreprise a-t-elle des employés ?"),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _aEmployes = v),
              ),
              if (_aEmployes == 'Oui') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _nbEmployesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Combien d'employés l'activité engage-t-elle ?", border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _payeTaxes,
                decoration: const InputDecoration(labelText: "Payez-vous des taxes ?"),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _payeTaxes = v),
              ),
              if (_payeTaxes == 'Oui') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _quellesTaxesController,
                  decoration: const InputDecoration(labelText: "Si oui, quelles taxes payez-vous ?", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _frequenceTaxes,
                  decoration: const InputDecoration(labelText: "À quelle fréquence ?"),
                  items: ['Journalière', 'Hebdomadaire', 'Mensuelle', 'Trimestrielle', 'Annuelle', 'Autre']
                      .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (v) => setState(() => _frequenceTaxes = v),
                ),
              ],
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
