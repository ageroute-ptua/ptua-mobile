import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
import '../widgets/custom_segmented_bool.dart';
import '../services/database_helper.dart';

class AgricultureFormScreen extends StatefulWidget {
  final String idMenage;
  const AgricultureFormScreen({super.key, required this.idMenage});

  @override
  State<AgricultureFormScreen> createState() => _AgricultureFormScreenState();
}

class _AgricultureFormScreenState extends State<AgricultureFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  bool _isSaving = false;

  bool _aParcelles = false;
  bool _aAnimaux = false;

  String? _typeCulture;
  String? _modeAcquisition;
  bool _exploiteSoiMeme = true;
  final _localisationController = TextEditingController();

  final _nbBovinsController = TextEditingController();
  final _nbOvinsController = TextEditingController();
  final _nbVolaillesController = TextEditingController();
  bool _elevageCommercial = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await _dbHelper.insertAgriculture({
        'idPap': widget.idMenage,
        'aParcelles': _aParcelles ? 1 : 0,
        'typeCulture': _typeCulture,
        'modeAcquisition': _modeAcquisition,
        'exploiteSoiMeme': _exploiteSoiMeme ? 1 : 0,
        'localisationParcelles': _localisationController.text,
        'aAnimaux': _aAnimaux ? 1 : 0,
        'nbBovins': int.tryParse(_nbBovinsController.text) ?? 0,
        'nbOvins': int.tryParse(_nbOvinsController.text) ?? 0,
        'nbVolailles': int.tryParse(_nbVolaillesController.text) ?? 0,
        'elevageCommercial': _elevageCommercial ? 1 : 0,
        'createdAt': DateTime.now().toIso8601String(),
        'syncStatus': 'local',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Données agricoles enregistrées !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
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

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Agriculture & Élevage', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      title: 'Parcelle Agricole',
                      children: [
                        CustomSegmentedBool(
  label: 'Le ménage dispose-t-il de parcelles cultivables ?',
  value: _aParcelles,
  onChanged: (v) => setState(() => _aParcelles = v),
),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _aParcelles ? Column(
                            children: [
                              const SizedBox(height: 16),
                              PremiumSingleSelect<String>(
  value: _typeCulture,
  label: 'Type de culture',
  icon: Icons.grass,
  items: ['Cultures pérennes', 'Cultures Annuelles', 'Cultures Vivrières']
                                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _typeCulture = v),
),
                              const SizedBox(height: 16),
                              PremiumSingleSelect<String>(
  value: _modeAcquisition,
  label: "Mode d\'acquisition",
  icon: Icons.real_estate_agent,
  items: ['Achat', 'Lèg', 'Bien de la famille(Filière coutumière)', 'Don', 'Héritage', 'Location', 'Occupation informelle', 'Autre']
                                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _modeAcquisition = v),
),
                              const SizedBox(height: 16),
                              CustomSegmentedBool(
  label: 'Exploitez-vous vous-même le champ ?',
  value: _exploiteSoiMeme,
  onChanged: (v) => setState(() => _exploiteSoiMeme = v),
),
                              const SizedBox(height: 16),
                              _buildTextField(_localisationController, 'Localisation des parcelles', icon: Icons.location_on),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Élevage',
                      children: [
                        CustomSegmentedBool(
  label: "Avez-vous des animaux d\'élevage ?",
  value: _aAnimaux,
  onChanged: (v) => setState(() => _aAnimaux = v),
),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _aAnimaux ? Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildTextField(_nbBovinsController, 'Nombre de Bovins (Boeufs)', isNumber: true),
                              _buildTextField(_nbOvinsController, 'Nombre d\'Ovins/Caprins (Moutons, Chèvres)', isNumber: true),
                              _buildTextField(_nbVolaillesController, 'Nombre de Volailles', isNumber: true),
                              CustomSegmentedBool(
  label: 'Élevage à but commercial ?',
  value: _elevageCommercial,
  onChanged: (v) => setState(() => _elevageCommercial = v),
),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
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
