import 'package:flutter/material.dart';

class AgricultureFormScreen extends StatefulWidget {
  final String idMenage;
  const AgricultureFormScreen({super.key, required this.idMenage});

  @override
  State<AgricultureFormScreen> createState() => _AgricultureFormScreenState();
}

class _AgricultureFormScreenState extends State<AgricultureFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Parcelle Agricole
  String? _typeCulture;
  String? _modeAcquisition;
  bool _exploiteSoiMeme = true;
  final _localisationController = TextEditingController();

  // Elevage
  final _nbBovinsController = TextEditingController();
  final _nbOvinsController = TextEditingController();
  final _nbVolaillesController = TextEditingController();
  bool _elevageCommercial = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Données agricoles enregistrées.')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agriculture & Élevage'), backgroundColor: const Color(0xFFF77F00)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('PARCELLE AGRICOLE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _typeCulture,
                decoration: const InputDecoration(labelText: 'Quelles type de culture pratiquez-vous dans vos exploitations ?'),
                items: ['Cultures pérennes', 'Cultures Annuelles', 'Cultures Vivrières']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _typeCulture = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _modeAcquisition,
                decoration: const InputDecoration(labelText: 'Comment le ménage à acquis ces exploitations agricoles ?'),
                items: ['Achat', 'Lèg', 'Bien de la famille(Filière coutumière)', 'Don', 'Héritage', 'Location', 'Occupation informelle', 'Autre']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _modeAcquisition = v),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Exploitez-vous vous-même le champ ?'),
                value: _exploiteSoiMeme,
                onChanged: (v) => setState(() => _exploiteSoiMeme = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _localisationController,
                decoration: const InputDecoration(labelText: 'Si oui où se situent ces parcelles et sont-elles en exploitations ?'),
              ),
              
              const Divider(height: 40, thickness: 2),
              
              const Text('ÉLEVAGE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nbBovinsController,
                decoration: const InputDecoration(labelText: 'Nombre de Bovins (Boeufs)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nbOvinsController,
                decoration: const InputDecoration(labelText: 'Nombre d\'Ovins / Caprins (Moutons, Chèvres)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nbVolaillesController,
                decoration: const InputDecoration(labelText: 'Nombre de Volailles'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('S\'agit-il d\'un élevage à but commercial ?'),
                value: _elevageCommercial,
                onChanged: (v) => setState(() => _elevageCommercial = v),
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
