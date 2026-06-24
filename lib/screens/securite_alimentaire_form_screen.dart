import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class SecuriteAlimentaireFormScreen extends StatefulWidget {
  final String idMenage;
  const SecuriteAlimentaireFormScreen({super.key, required this.idMenage});

  @override
  State<SecuriteAlimentaireFormScreen> createState() => _SecuriteAlimentaireFormScreenState();
}

class _SecuriteAlimentaireFormScreenState extends State<SecuriteAlimentaireFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  bool _isSaving = false;

  final _joursAlimentsMoinsChersController = TextEditingController();
  final _joursEmprunterNourritureController = TextEditingController();
  final _joursLimiterQuantiteController = TextEditingController();
  final _joursRestreindreAdultesController = TextEditingController();
  final _joursReduireRepasController = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await _dbHelper.insertSecuriteAlimentaire({
        'idPap': widget.idMenage,
        'joursAlimentsMoinsChers': int.tryParse(_joursAlimentsMoinsChersController.text) ?? 0,
        'joursEmprunterNourriture': int.tryParse(_joursEmprunterNourritureController.text) ?? 0,
        'joursLimiterQuantite': int.tryParse(_joursLimiterQuantiteController.text) ?? 0,
        'joursRestreindreAdultes': int.tryParse(_joursRestreindreAdultesController.text) ?? 0,
        'joursReduireRepas': int.tryParse(_joursReduireRepasController.text) ?? 0,
        'joursManquerNourriture': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'syncStatus': 'local',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sécurité alimentaire enregistrée !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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

  Widget _buildDaysInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Ex: 2',
          prefixIcon: const Icon(Icons.date_range),
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
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Sécurité Alimentaire', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      title: 'Impact sur l\'alimentation',
                      children: [
                        const Text(
                          'Au cours des 7 derniers jours, combien de jours votre ménage a-t-il dû faire face aux situations suivantes à cause d\'un manque de nourriture ou d\'argent ?',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        _buildDaysInput('1. Aliments moins chers que d\'habitude', _joursAlimentsMoinsChersController),
                        _buildDaysInput('2. Emprunter de la nourriture', _joursEmprunterNourritureController),
                        _buildDaysInput('3. Limiter la quantité des repas', _joursLimiterQuantiteController),
                        _buildDaysInput('4. Restreindre la consommation des adultes', _joursRestreindreAdultesController),
                        _buildDaysInput('5. Réduire le nombre de repas par jour', _joursReduireRepasController),
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
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1660B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isSaving 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('ENREGISTRER', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
