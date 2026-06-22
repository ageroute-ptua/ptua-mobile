import 'package:flutter/material.dart';
import '../models/menage.dart';
import '../services/database_helper.dart';

class MenageFormScreen extends StatefulWidget {
  final String idPap;
  const MenageFormScreen({super.key, required this.idPap});

  @override
  State<MenageFormScreen> createState() => _MenageFormScreenState();
}

class _MenageFormScreenState extends State<MenageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  
  final _nbrePersonnesController = TextEditingController();
  final _appartenanceOrgController = TextEditingController();

  String? _isChefMen = 'Oui';
  String? _isPersonneVulMenage = 'Non';
  String? _typeSanitaire = 'W-C Chasse';
  String? _typeMenage;
  
  // Skip logic organisation
  String? _isMembreOrganisation = 'Non';
  String? _typeOrganisation;
  
  // Skip logic retraite
  String? _toucheRetraite = 'Non';
  final _montantRetraiteController = TextEditingController();

  void _saveMenage() async {
    if (_formKey.currentState!.validate()) {
      final menage = Menage(
        idPap: widget.idPap,
        nbrePersonnesMenage: int.tryParse(_nbrePersonnesController.text),
        isChefMen: _isChefMen == 'Oui',
        appartenanceOrg: _appartenanceOrgController.text,
        isPersonneVulMenage: _isPersonneVulMenage == 'Oui',
        typeSanitaire: _typeSanitaire,
        createdAt: DateTime.now(),
        syncStatus: 'local',
      );

      await _dbHelper.insertMenage(menage);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Infos Ménage sauvegardées !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ménage & Habitat', style: TextStyle(color: Colors.white)),
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
                controller: _nbrePersonnesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nombre total de personnes', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _isChefMen,
                decoration: const InputDecoration(labelText: 'Êtes-vous chef de ménage ?'),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _isChefMen = v),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _typeMenage,
                decoration: const InputDecoration(labelText: 'Type de Ménage'),
                items: [
                  'Ménage composé d\'une seule personne',
                  'Ménage composé d\'un couple sans enfant',
                  'Ménage composé d\'un couple et d\'enfants',
                  'Ménage monoparental',
                  'Ménage polygamique',
                  'Ménage comprenant la famille étendue'
                ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _typeMenage = v),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _isPersonneVulMenage,
                decoration: const InputDecoration(labelText: 'Y a-t-il une personne vulnérable ?'),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _isPersonneVulMenage = v),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _isMembreOrganisation,
                decoration: const InputDecoration(labelText: "Faites-vous partie d'une organisation ?"),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _isMembreOrganisation = v),
              ),
              if (_isMembreOrganisation == 'Oui') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _typeOrganisation,
                  decoration: const InputDecoration(labelText: 'Précisez l\'organisation'),
                  items: ['Mutuelle de développement', 'Association du quartier', 'Coopérative agricole', 'Autres']
                      .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (v) => setState(() => _typeOrganisation = v),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _appartenanceOrgController,
                  decoration: const InputDecoration(labelText: "Si Autre, précisez le nom", border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _toucheRetraite,
                decoration: const InputDecoration(labelText: 'Le chef de ménage touche-t-il une retraite ?'),
                items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _toucheRetraite = v),
              ),
              if (_toucheRetraite == 'Oui') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _montantRetraiteController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Montant annuel de la retraite (FCFA)", border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _typeSanitaire,
                decoration: const InputDecoration(labelText: 'Type de Sanitaire'),
                items: ['W-C Chasse', 'Latrine', 'Fosse Septique', 'Dans la nature'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _typeSanitaire = v),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMenage,
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
