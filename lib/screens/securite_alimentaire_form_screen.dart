import 'package:flutter/material.dart';

class SecuriteAlimentaireFormScreen extends StatefulWidget {
  final String idMenage;
  const SecuriteAlimentaireFormScreen({super.key, required this.idMenage});

  @override
  State<SecuriteAlimentaireFormScreen> createState() => _SecuriteAlimentaireFormScreenState();
}

class _SecuriteAlimentaireFormScreenState extends State<SecuriteAlimentaireFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _joursAlimentsMoinsChersController = TextEditingController();
  final _joursEmprunterNourritureController = TextEditingController();
  final _joursLimiterQuantiteController = TextEditingController();
  final _joursRestreindreAdultesController = TextEditingController();
  final _joursReduireRepasController = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Données de sécurité alimentaire enregistrées.')));
    Navigator.pop(context, true);
  }

  Widget _buildDaysInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Ex: 2',
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (v) {
          if (v != null && v.isNotEmpty) {
            final val = int.tryParse(v);
            if (val == null || val < 0 || val > 7) {
              return 'Entrez un nombre entre 0 et 7';
            }
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sécurité Alimentaire'), backgroundColor: const Color(0xFFF77F00)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Au cours des 7 derniers jours, combien de jours votre ménage a-t-il dû faire face aux situations suivantes à cause d\'un manque de nourriture ou d\'argent ?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              _buildDaysInput('1. Manger des aliments moins chers que d\'habitude', _joursAlimentsMoinsChersController),
              _buildDaysInput('2. Emprunter de la nourriture à des amis ou de la famille', _joursEmprunterNourritureController),
              _buildDaysInput('3. Limiter la quantité des repas de tout le ménage', _joursLimiterQuantiteController),
              _buildDaysInput('4. Restreindre la consommation des adultes au profit des petits enfants', _joursRestreindreAdultesController),
              _buildDaysInput('5. Réduire le nombre de repas par jour', _joursReduireRepasController),

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
