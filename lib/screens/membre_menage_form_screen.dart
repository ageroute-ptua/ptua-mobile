import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
import '../widgets/custom_segmented_bool.dart';
import '../models/membre_menage.dart';
import '../services/database_helper.dart';

class MembreMenageFormScreen extends StatefulWidget {
  final String idPap;
  const MembreMenageFormScreen({super.key, required this.idPap});

  @override
  State<MembreMenageFormScreen> createState() => _MembreMenageFormScreenState();
}

class _MembreMenageFormScreenState extends State<MembreMenageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  bool _isSaving = false;

  final _nomPrenomController = TextEditingController();
  final _ageController = TextEditingController();
  final _numPiecePapController = TextEditingController();
  final _telephonePapController = TextEditingController();
  final _revenuMensuelController = TextEditingController();
  final _revenuMensuelSecController = TextEditingController();
  final _nbMoisActiviteController = TextEditingController();
  final _nbMoisActiviteSecController = TextEditingController();

  String? _lienChefMenage;
  bool _estEnfantMoins5 = false;
  bool _estPap = false;
  String? _sexe;
  String? _nationalite;
  String? _ethnie;
  String? _handicap;
  bool _saitLireEcrire = false;
  String? _langueLecture;
  String? _niveauEtude;
  bool _vaAEcole = false;
  bool _travaille = false;
  String? _activitePrincipale;
  String? _statutActivite;
  String? _activiteSecondaire;
  String? _statutActiviteSec;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final membre = MembreMenage(
      idPap: widget.idPap,
      nomPrenom: _nomPrenomController.text,
      lienChefMenage: _lienChefMenage ?? 'Autre',
      estEnfantMoins5: _estEnfantMoins5,
      age: int.tryParse(_ageController.text),
      estPap: _estPap,
      numPiecePap: _numPiecePapController.text,
      telephonePap: _telephonePapController.text,
      sexe: _sexe,
      nationalite: _nationalite,
      ethnie: _ethnie,
      handicap: _handicap,
      saitLireEcrire: _saitLireEcrire,
      langueLecture: _langueLecture,
      niveauEtude: _niveauEtude,
      vaAEcole: _vaAEcole,
      travaille: _travaille,
      activitePrincipale: _activitePrincipale,
      statutActivite: _statutActivite,
      nbMoisActivite: int.tryParse(_nbMoisActiviteController.text),
      revenuMensuel: double.tryParse(_revenuMensuelController.text),
      activiteSecondaire: _activiteSecondaire,
      statutActiviteSec: _statutActiviteSec,
      nbMoisActiviteSec: int.tryParse(_nbMoisActiviteSecController.text),
      revenuMensuelSec: double.tryParse(_revenuMensuelSecController.text),
      createdAt: DateTime.now(),
    );

    await _dbHelper.insertMembreMenage(membre.toMap());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Membre enregistré', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
      Navigator.pop(context, true);
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

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false, IconData? icon, bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
        validator: required ? (v) => v!.isEmpty ? 'Requis' : null : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Nouveau Membre', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      title: 'Identité du Membre',
                      children: [
                        _buildTextField(_nomPrenomController, 'Nom et Prénom(s)*', icon: Icons.person, required: true),
                        PremiumSingleSelect<String>(
  value: _lienChefMenage,
  label: 'Lien avec le Chef de Ménage*',
  icon: Icons.family_restroom,
  items: ['Chef de ménage (CM)', 'Conjoint(e)', 'Enfant (Fils/Fille)', 'Père/Mère du CM', 'Frère/Sœur du CM', 'Neveu/Nièce', 'Petit fils/fille', 'Autre parent', 'Sans lien de parenté']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _lienChefMenage = v),
),
                        const SizedBox(height: 16),
                        CustomSegmentedBool(
  label: 'Est-ce un enfant de moins de 5 ans ?',
  value: _estEnfantMoins5,
  onChanged: (v) => setState(() => _estEnfantMoins5 = v),
),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: !_estEnfantMoins5 ? Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildTextField(_ageController, 'Âge', isNumber: true, icon: Icons.cake),
                              PremiumSingleSelect<String>(
  value: _sexe,
  label: 'Sexe',
  icon: Icons.transgender,
  items: ['Masculin', 'Féminin'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _sexe = v),
),
                              const SizedBox(height: 16),
                              CustomSegmentedBool(
  label: 'Ce membre est-il la PAP elle-même ?',
  value: _estPap,
  onChanged: (v) => setState(() => _estPap = v),
),
                              if (_estPap) ...[
                                const SizedBox(height: 16),
                                _buildTextField(_numPiecePapController, 'N° Pièce d\'identité', icon: Icons.badge),
                                _buildTextField(_telephonePapController, 'Téléphone', isNumber: true, icon: Icons.phone),
                              ],
                              PremiumSingleSelect<String>(
  value: _nationalite,
  label: 'Nationalité',
  icon: Icons.public,
  items: ['Ivoirienne', 'CEDEAO', 'Hors CEDEAO'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _nationalite = v),
),
                              const SizedBox(height: 16),
                              PremiumSingleSelect<String>(
  value: _handicap,
  label: 'Présente-t-il un handicap ?',
  icon: Icons.accessible,
  items: ['Aucun', 'Physique', 'Visuel', 'Auditif', 'Mental', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _handicap = v),
),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: !_estEnfantMoins5 ? _buildSectionCard(
                        title: 'Éducation & Activité',
                        children: [
                          CustomSegmentedBool(
  label: 'Sait-il lire et écrire ?',
  value: _saitLireEcrire,
  onChanged: (v) => setState(() => _saitLireEcrire = v),
),
                          const SizedBox(height: 16),
                          PremiumSingleSelect<String>(
  value: _niveauEtude,
  label: "Niveau d\'instruction",
  icon: Icons.school,
  items: ['Aucun', 'Primaire', 'Secondaire 1er cycle', 'Secondaire 2nd cycle', 'Supérieur', 'Coranique/Confessionnel'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _niveauEtude = v),
),
                          const SizedBox(height: 16),
                          CustomSegmentedBool(
  label: 'Exerce-t-il une activité rémunérée ?',
  value: _travaille,
  onChanged: (v) => setState(() => _travaille = v),
),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: _travaille ? Column(
                              children: [
                                const SizedBox(height: 16),
                                PremiumSingleSelect<String>(
  value: _activitePrincipale,
  label: 'Activité Principale',
  icon: Icons.work,
  items: ['Agriculture', 'Élevage', 'Commerce', 'Artisanat', 'Fonctionnaire', 'Employé privé', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _activitePrincipale = v),
),
                                const SizedBox(height: 16),
                                _buildTextField(_revenuMensuelController, 'Revenu mensuel estimé (FCFA)', isNumber: true, icon: Icons.payments),
                              ],
                            ) : const SizedBox.shrink(),
                          ),
                        ],
                      ) : const SizedBox.shrink(),
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
                      : const Text('ENREGISTRER LE MEMBRE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
