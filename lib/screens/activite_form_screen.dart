import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
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
  final _revenuMoyeMauvaiseController = TextEditingController();
  final _revenuMoyeBonneController = TextEditingController();
  String? _statutActivite;
  final _nbMoisActiviteController = TextEditingController();
  final _lieuTravailController = TextEditingController();
  final _revenuCumulController = TextEditingController();

  String? _transferArg = 'Non';
  String? _presenceActivSecondMenage = 'Non';
  String? _activiteSecondaire;
  String? _isParcelleHorsEmprise = 'Oui';
  
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
        revenuMoyeActPrinMauvaise: double.tryParse(_revenuMoyeMauvaiseController.text),
        revenuMoyeActPrinBonne: double.tryParse(_revenuMoyeBonneController.text),
        statutActivite: _statutActivite,
        nbMoisActivite: int.tryParse(_nbMoisActiviteController.text),
        transferArg: _transferArg == 'Oui',
        lieuTravail: _lieuTravailController.text,
        presenceActivSecondMenage: _presenceActivSecondMenage == 'Oui',
        activiteSecondaire: _presenceActivSecondMenage == 'Oui' ? _activiteSecondaire : null,
        revenuCumul: double.tryParse(_revenuCumulController.text),
        isParcelleHorsEmprise: _isParcelleHorsEmprise == 'Oui',
        aEmployes: _aEmployes == 'Oui',
        nbEmployes: _aEmployes == 'Oui' ? int.tryParse(_nbEmployesController.text) : null,
        payeTaxes: _payeTaxes == 'Oui',
        quellesTaxes: _payeTaxes == 'Oui' ? _quellesTaxesController.text : null,
        frequenceTaxes: _payeTaxes == 'Oui' ? _frequenceTaxes : null,
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
    final acts = ['Planteur/Cultivateur', 'Pêcheur', 'Eleveur/Fermier', 'Commerçant', 'Transporteur', 'Salarié du public', 'Salarié du privé', 'Artisan', 'Ouvrier', 'Employé', 'Elève/Etudiant', 'Femme au foyer', 'Sans emploi', 'Retraité', 'Guide religieux', 'Autres'];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Activités & Revenus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      title: 'Activité Principale',
                      children: [
                        PremiumSingleSelect<String>(
  value: _activitePrincip,
  label: 'Activité Principale',
  icon: Icons.work,
  items: acts.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _activitePrincip = v),
),
                        const SizedBox(height: 16),
                        PremiumSingleSelect<String>(
  value: _statutActivite,
  label: "Statut dans l\'emploi",
  icon: Icons.assignment_ind,
  items: ['Propriétaire', 'Employé', 'Fonctionnaire public', 'Fonctionnaire privé', 'Colocataire/Associé', 'Autre']
                              .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _statutActivite = v),
),
                        const SizedBox(height: 16),
                        _buildTextField(_nbMoisActiviteController, 'Nombre de mois menés en 2023', isNumber: true, icon: Icons.calendar_today),
                        _buildTextField(_revenuMoyeMauvaiseController, 'Revenu moyen mensuel (Mauvaise période)', isNumber: true, icon: Icons.trending_down),
                        _buildTextField(_revenuMoyeBonneController, 'Revenu moyen mensuel (Bonne période)', isNumber: true, icon: Icons.trending_up),
                        _buildTextField(_lieuTravailController, 'Lieu de travail', icon: Icons.location_city),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Activité Secondaire & Globale',
                      children: [
                        _buildBoolField('Présence d\'activité secondaire ?', _presenceActivSecondMenage, (v) => setState(() => _presenceActivSecondMenage = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _presenceActivSecondMenage == 'Oui' ? Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: PremiumSingleSelect<String>(
  value: _activiteSecondaire,
  label: 'Laquelle ?',
  icon: Icons.work_outline,
  items: acts.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _activiteSecondaire = v),
),
                          ) : const SizedBox.shrink(),
                        ),
                        _buildTextField(_revenuCumulController, 'Revenus cumulés du ménage (FCFA)', isNumber: true, icon: Icons.account_balance_wallet),
                        _buildBoolField('Le ménage reçoit-il un transfert d\'argent ?', _transferArg, (v) => setState(() => _transferArg = v)),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Entreprise & Taxes',
                      children: [
                        _buildBoolField('L\'entreprise a-t-elle des employés ?', _aEmployes, (v) => setState(() => _aEmployes = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _aEmployes == 'Oui' ? _buildTextField(_nbEmployesController, 'Nombre d\'employés', isNumber: true, icon: Icons.group) : const SizedBox.shrink(),
                        ),
                        _buildBoolField('Payez-vous des taxes ?', _payeTaxes, (v) => setState(() => _payeTaxes = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _payeTaxes == 'Oui' ? Column(
                            children: [
                              _buildTextField(_quellesTaxesController, 'Quelles taxes payez-vous ?', icon: Icons.request_quote),
                              PremiumSingleSelect<String>(
  value: _frequenceTaxes,
  label: 'À quelle fréquence ?',
  icon: Icons.update,
  items: ['Journalière', 'Hebdomadaire', 'Mensuelle', 'Trimestrielle', 'Annuelle', 'Autre']
                                    .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
  onChanged: (v) => setState(() => _frequenceTaxes = v),
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
                  onPressed: _saveActivite,
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
