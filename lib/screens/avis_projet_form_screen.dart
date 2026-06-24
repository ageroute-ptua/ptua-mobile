import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
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

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
      ),
    );
  }

  Widget _buildBoolField(String label, String? value, Function(String?) onChanged) {
    return PremiumSingleSelect<String>(
      value: value,
      label: label,
      icon: Icons.check_circle_outline,
      items: ['Oui', 'Non'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Avis sur le Projet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      title: 'Perception Générale',
                      children: [
                        _buildTextField(_penseePrjController, 'Que pensez-vous du projet ?', maxLines: 3, icon: Icons.chat_bubble_outline),
                        _buildTextField(_justiAvisController, 'Justification globale', maxLines: 2, icon: Icons.format_align_left),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Craintes & Inquiétudes',
                      children: [
                        _buildBoolField('Avez-vous des craintes ?', _isAvezCraintes, (v) => setState(() => _isAvezCraintes = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _isAvezCraintes == 'Oui'
                              ? _buildTextField(_ouiCraintesController, 'Lesquelles ?', maxLines: 2, icon: Icons.warning_amber_rounded)
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Attentes & Recommandations',
                      children: [
                        _buildBoolField('Avez-vous des attentes ?', _isAvezAttentes, (v) => setState(() => _isAvezAttentes = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _isAvezAttentes == 'Oui'
                              ? _buildTextField(_ouiAttentesController, 'Lesquelles ?', maxLines: 2, icon: Icons.lightbulb_outline)
                              : const SizedBox.shrink(),
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
                  onPressed: _saveAvis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1660B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('ENREGISTRER', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
