import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import '../widgets/premium_multi_select.dart';
import '../widgets/custom_segmented_bool.dart';
import '../services/database_helper.dart';

class FinanceFormScreen extends StatefulWidget {
  final String idMenage;
  const FinanceFormScreen({super.key, required this.idMenage});

  @override
  State<FinanceFormScreen> createState() => _FinanceFormScreenState();
}

class _FinanceFormScreenState extends State<FinanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  bool _isSaving = false;

  bool _recoitAideFinanciere = false;
  final _montantAideController = TextEditingController();
  bool _aCompteBanque = false;
  bool _pratiqueTontine = false;
  
  bool _aDesCredits = false;
  String? _institutionCredit;
  String? _raisonCredit;
  String? _statutCredit;
  final _montantCreditController = TextEditingController();

  String? _sourcePrincipaleRevenus;
  
  final _consomAlimentaireController = TextEditingController();
  final _logementController = TextEditingController();
  final _educationController = TextEditingController();
  final _santeController = TextEditingController();
  final _habillementController = TextEditingController();
  final _transportController = TextEditingController();
  final _communicationController = TextEditingController();
  final _entretienEquipController = TextEditingController();
  final _autreChargeController = TextEditingController();
  final _coutTotalChargeMenageController = TextEditingController();

  bool _aChargeHorsMenage = false;
  final _nbTransfertsEnvoyesController = TextEditingController();
  final _montantTransfertsEnvoyesController = TextEditingController();
  
  final _nbrTransferController = TextEditingController();
  final _montantTransfer6moisController = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await _dbHelper.insertFinance({
        'idPap': widget.idMenage,
        'aCompteBanque': _aCompteBanque ? 1 : 0,
        'pratiqueTontine': _pratiqueTontine ? 1 : 0,
        'recoitAideFinanciere': _recoitAideFinanciere ? 1 : 0,
        'montantAide': double.tryParse(_montantAideController.text) ?? 0.0,
        'aDesCredits': _aDesCredits ? 1 : 0,
        'institutionCredit': _institutionCredit,
        'raisonCredit': _raisonCredit,
        'statutCredit': _statutCredit,
        'montantCredit': double.tryParse(_montantCreditController.text) ?? 0.0,
        'sourcePrincipaleRevenus': _sourcePrincipaleRevenus,
        
        'consomAlimentaire': double.tryParse(_consomAlimentaireController.text) ?? 0.0,
        'logement': double.tryParse(_logementController.text) ?? 0.0,
        'education': double.tryParse(_educationController.text) ?? 0.0,
        'sante': double.tryParse(_santeController.text) ?? 0.0,
        'habillement': double.tryParse(_habillementController.text) ?? 0.0,
        'transport': double.tryParse(_transportController.text) ?? 0.0,
        'communication': double.tryParse(_communicationController.text) ?? 0.0,
        'entretienEquip': double.tryParse(_entretienEquipController.text) ?? 0.0,
        'autreCharge': double.tryParse(_autreChargeController.text) ?? 0.0,
        'coutTotalChargeMenage': double.tryParse(_coutTotalChargeMenageController.text) ?? 0.0,

        'aChargeHorsMenage': _aChargeHorsMenage ? 1 : 0,
        'nbTransfertsEnvoyes': int.tryParse(_nbTransfertsEnvoyesController.text) ?? 0,
        'montantTransfertsEnvoyes': double.tryParse(_montantTransfertsEnvoyesController.text) ?? 0.0,
        
        'nbrTransfer': int.tryParse(_nbrTransferController.text) ?? 0,
        'montantTransfer6mois': double.tryParse(_montantTransfer6moisController.text) ?? 0.0,

        'createdAt': DateTime.now().toIso8601String(),
        'syncStatus': 'local',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Données financières enregistrées !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
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

  Widget _buildDepense(String label, TextEditingController ctrl, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixText: 'FCFA',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Finances & Crédits', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      title: 'Informations Financières',
                      children: [
                        CustomSegmentedBool(label: 'Avez-vous un compte bancaire ou mobile money ?', value: _aCompteBanque, onChanged: (v) => setState(() => _aCompteBanque = v)),
                        CustomSegmentedBool(label: 'Participez-vous à une tontine ?', value: _pratiqueTontine, onChanged: (v) => setState(() => _pratiqueTontine = v)),
                        CustomSegmentedBool(label: 'Recevez-vous des aides financières régulières ?', value: _recoitAideFinanciere, onChanged: (v) => setState(() => _recoitAideFinanciere = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _recoitAideFinanciere ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: _buildTextField(_montantAideController, 'Montant estimé par an (FCFA)', isNumber: true, icon: Icons.payments),
                          ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Revenus et Dépenses',
                      children: [
                        PremiumSingleSelect<String>(
                          value: _sourcePrincipaleRevenus,
                          label: 'Source principale de revenus',
                          icon: Icons.account_balance_wallet,
                          items: ['Agriculture', 'Elevage', 'Pêche', 'Commerce', 'Artisanat', 'Salaire', 'Pension', 'Transferts', 'Autre']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                          onChanged: (v) => setState(() => _sourcePrincipaleRevenus = v),
                        ),
                        const SizedBox(height: 24),
                        const Text('Détail des dépenses mensuelles', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E224A))),
                        const SizedBox(height: 16),
                        _buildDepense('Consommation alimentaire', _consomAlimentaireController, Icons.restaurant),
                        _buildDepense('Logement / Energie / Eau', _logementController, Icons.home),
                        _buildDepense('Education (Scolarité...)', _educationController, Icons.school),
                        _buildDepense('Santé (Soins, médicaments)', _santeController, Icons.local_hospital),
                        _buildDepense('Habillement', _habillementController, Icons.checkroom),
                        _buildDepense('Transport', _transportController, Icons.directions_bus),
                        _buildDepense('Communication', _communicationController, Icons.phone),
                        _buildDepense('Entretien équipements', _entretienEquipController, Icons.build),
                        _buildDepense('Autre charge', _autreChargeController, Icons.more_horiz),
                        _buildDepense('Coût total estimé', _coutTotalChargeMenageController, Icons.functions),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Transferts et Charges Externes',
                      children: [
                        CustomSegmentedBool(label: 'Personnes à charge hors de votre ménage ?', value: _aChargeHorsMenage, onChanged: (v) => setState(() => _aChargeHorsMenage = v)),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _aChargeHorsMenage ? Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildTextField(_nbTransfertsEnvoyesController, 'Nombre de personnes aidées', isNumber: true, icon: Icons.group),
                              _buildTextField(_nbrTransferController, 'Nombre de transferts dans l\'année', isNumber: true, icon: Icons.sync_alt),
                              _buildTextField(_montantTransfer6moisController, 'Montant total (6 mois) (FCFA)', isNumber: true, icon: Icons.price_change),
                            ],
                          ) : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    _buildSectionCard(
                      title: 'Crédits en cours',
                      children: [
                        SwitchListTile(
                          title: const Text('Avez-vous un crédit en cours ?', style: TextStyle(fontSize: 14)),
                          value: _aDesCredits,
                          activeColor: const Color(0xFFE1660B),
                          onChanged: (v) => setState(() => _aDesCredits = v),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _aDesCredits ? Column(
                            children: [
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _institutionCredit,
                                decoration: const InputDecoration(labelText: 'Institution de crédit', prefixIcon: Icon(Icons.account_balance)),
                                items: ['Banque', 'Institution de Microfinance', 'Commerçant', 'Chef de tontine', 'Acheteur d\'or', 'Ami', 'Famille', 'Groupement/association', 'Autre']
                                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                onChanged: (v) => setState(() => _institutionCredit = v),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _raisonCredit,
                                decoration: const InputDecoration(labelText: 'Pour quelle raison ?', prefixIcon: Icon(Icons.help_outline)),
                                items: ['Evènement social', 'Maladie', 'Rentrée scolaire', 'Commerce', 'Agriculture', 'Construction', 'Autre']
                                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                onChanged: (v) => setState(() => _raisonCredit = v),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _statutCredit,
                                decoration: const InputDecoration(labelText: 'Statut actuel', prefixIcon: Icon(Icons.info_outline)),
                                items: ['Remboursé', 'En cours de remboursement', 'Retard']
                                    .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                onChanged: (v) => setState(() => _statutCredit = v),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(_montantCreditController, 'Montant total du crédit (FCFA)', isNumber: true, icon: Icons.monetization_on),
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
