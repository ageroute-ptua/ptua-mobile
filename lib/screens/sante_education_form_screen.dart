import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
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
  String? _typeSoinMen;
  String? _aMaladieChronique = 'Non';
  String? _laquelleMaladie;

  // Education
  final _nbEnftScolariseController = TextEditingController();
  final _distanceDomEcolePrimController = TextEditingController();
  String? _aEcoliersEtudiants = 'Non';
  final _nbEcoliersController = TextEditingController();
  final _nbElevesController = TextEditingController();
  final _nbEtudiantsController = TextEditingController();

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
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
        title: const Text('Santé & Éducation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      title: 'Santé du Ménage',
                      children: [
                        _buildTextField(_distanceDomSanteController, 'Distance vers le centre de santé (m)', isNumber: true, icon: Icons.local_hospital),
                        _buildBoolField('Avez-vous une assurance maladie ?', _isAssurance, (v) => setState(() => _isAssurance = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _isAssurance == 'Oui' ? Column(
                            children: [
                              _buildTextField(_assureurController, 'Nom de l\'assureur', icon: Icons.health_and_safety),
                              _buildTextField(_tauxCouvertureController, 'Taux de couverture (%)', isNumber: true, icon: Icons.percent),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                        _buildTextField(_nbrPersMaladeController, 'Nombre de personnes malades récemment', isNumber: true, icon: Icons.sick),
                        _buildBoolField('Un membre a-t-il un handicap ou maladie chronique ?', _aMaladieChronique, (v) => setState(() => _aMaladieChronique = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _aMaladieChronique == 'Oui' ? Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: PremiumMultiSelect(
  initialValue: _laquelleMaladie,
  label: 'Lequel / Laquelle ?',
  icon: Icons.accessible,
  items: const ['Handicap mental', 'Retard cognitif', 'Maladie chronique', 'Handicap moteur cérébral', 'Handicap membre', 'Visuel', 'Auditif/Verbal', 'Autre'],
  onChanged: (v) => setState(() => _laquelleMaladie = v),
),
                          ) : const SizedBox.shrink(),
                        ),
                        PremiumMultiSelect(
  initialValue: _typeSoinMen,
  label: 'Lieu(x) de soin principal(aux)',
  icon: Icons.medication,
  items: const ['Centre Hospitalier Universitaire', 'Centre hospitalier régional', 'Hôpital général', 'Centre de santé public', 'Centre de santé privée', 'Médecin libéral', 'Pharmacien', 'Tradipraticien', 'Auto-médication', 'Autre'],
  onChanged: (v) => setState(() => _typeSoinMen = v),
),
                      ],
                    ),
                    
                    _buildSectionCard(
                      title: 'Éducation',
                      children: [
                        _buildTextField(_nbEnftScolariseController, 'Nombre d\'enfants scolarisés', isNumber: true, icon: Icons.school),
                        _buildBoolField('Y a t-il des écoliers/étudiants dans votre ménage ?', _aEcoliersEtudiants, (v) => setState(() => _aEcoliersEtudiants = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _aEcoliersEtudiants == 'Oui' ? Column(
                            children: [
                              _buildTextField(_nbEcoliersController, 'Nombre d\'écoliers (Primaire)', isNumber: true, icon: Icons.backpack),
                              _buildTextField(_nbElevesController, 'Nombre d\'élèves (Secondaire)', isNumber: true, icon: Icons.menu_book),
                              _buildTextField(_nbEtudiantsController, 'Nombre d\'étudiants (Supérieur)', isNumber: true, icon: Icons.history_edu),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                        _buildTextField(_distanceDomEcolePrimController, 'Distance vers l\'école primaire (m)', isNumber: true, icon: Icons.map),
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
                  onPressed: _saveData,
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
