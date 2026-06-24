import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
import '../widgets/custom_segmented_bool.dart';
import '../models/plan_restauration.dart';
import '../services/database_helper.dart';

class PlanRestaurationFormScreen extends StatefulWidget {
  final String idPap;
  const PlanRestaurationFormScreen({super.key, required this.idPap});

  @override
  State<PlanRestaurationFormScreen> createState() => _PlanRestaurationFormScreenState();
}

class _PlanRestaurationFormScreenState extends State<PlanRestaurationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  bool _isSaving = false;

  String? _souhaitRestauration;
  String? _typeCompensation;
  bool _continuerActivite = false;
  final _nouvelleActiviteController = TextEditingController();
  String? _appuiSouhaite;
  final _typeFormationController = TextEditingController();
  bool _besoinAppuiEquipement = false;
  final _typeEquipementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final existing = await _dbHelper.getPlanRestaurationByPap(widget.idPap);
    if (existing != null) {
      final plan = PlanRestauration.fromMap(existing);
      setState(() {
        _souhaitRestauration = plan.souhaitRestauration;
        _typeCompensation = plan.typeCompensation;
        _continuerActivite = plan.continuerActivite ?? false;
        if (plan.nouvelleActivite != null) _nouvelleActiviteController.text = plan.nouvelleActivite!;
        _appuiSouhaite = plan.appuiSouhaite;
        if (plan.typeFormation != null) _typeFormationController.text = plan.typeFormation!;
        _besoinAppuiEquipement = plan.besoinAppuiEquipement ?? false;
        if (plan.typeEquipement != null) _typeEquipementController.text = plan.typeEquipement!;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final plan = PlanRestauration(
      idPap: widget.idPap,
      souhaitRestauration: _souhaitRestauration ?? 'Non spécifié',
      typeCompensation: _typeCompensation,
      continuerActivite: _continuerActivite,
      nouvelleActivite: !_continuerActivite ? _nouvelleActiviteController.text : null,
      appuiSouhaite: _appuiSouhaite,
      typeFormation: _appuiSouhaite == 'Formation' ? _typeFormationController.text : null,
      besoinAppuiEquipement: _besoinAppuiEquipement,
      typeEquipement: _besoinAppuiEquipement ? _typeEquipementController.text : null,
      createdAt: DateTime.now(),
    );

    await _dbHelper.insertPlanRestauration(plan.toMap());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan de restauration enregistré'), backgroundColor: Colors.green));
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

  Widget _buildTextField(TextEditingController controller, String label, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
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
        title: const Text('Plan de Restauration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      title: 'Accompagnement & Compensation',
                      children: [
                        const Text('Voulez-vous être accompagné pour la restauration de vos revenus ?', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 12),
                        PremiumSingleSelect<String>(
  value: _souhaitRestauration,
  label: 'Souhait*',
  icon: Icons.handshake,
  items: ['Oui, par le projet', 'Non, je me débrouillerai', 'Indécis'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _souhaitRestauration = v),
),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _souhaitRestauration == 'Oui, par le projet' ? Column(
                            children: [
                              const SizedBox(height: 16),
                              PremiumSingleSelect<String>(
  value: _typeCompensation,
  label: 'Préférence de compensation',
  icon: Icons.account_balance_wallet,
  items: ['En espèces', 'En nature (Matériel/Equipement)', 'Mixte'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
  onChanged: (v) => setState(() => _typeCompensation = v),
),
                            ],
                          ) : const SizedBox.shrink(),
                        )
                      ],
                    ),
                    
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: _souhaitRestauration == 'Oui, par le projet' ? _buildSectionCard(
                        title: 'Détails de l\'Activité',
                        children: [
                          CustomSegmentedBool(
  label: 'Souhaitez-vous continuer la même activité ?',
  value: _continuerActivite,
  onChanged: (v) => setState(() => _continuerActivite = v),
),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: !_continuerActivite ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: _buildTextField(_nouvelleActiviteController, 'Quelle nouvelle activité ?', icon: Icons.work_outline),
                            ) : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                          PremiumMultiSelect(
  initialValue: _appuiSouhaite,
  label: "Quel type d\'appui souhaitez-vous ?",
  icon: Icons.support_agent,
  items: const ['Formation', 'Accès au crédit', 'Accès à la terre', 'Appui technique', 'Autre'],
  onChanged: (v) => setState(() => _appuiSouhaite = v),
),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: _appuiSouhaite == 'Formation' ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: _buildTextField(_typeFormationController, 'Précisez le domaine de formation', icon: Icons.school),
                            ) : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                          CustomSegmentedBool(
  label: "Avez-vous besoin d\'un appui en équipement ?",
  value: _besoinAppuiEquipement,
  onChanged: (v) => setState(() => _besoinAppuiEquipement = v),
),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: _besoinAppuiEquipement ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: _buildTextField(_typeEquipementController, 'Précisez l\'équipement souhaité', icon: Icons.precision_manufacturing),
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
                      : const Text('ENREGISTRER LE PLAN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
