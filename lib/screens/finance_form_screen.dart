import 'package:flutter/material.dart';
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

  // Finances
  bool _recoitAideFinanciere = false;
  final _montantAideController = TextEditingController();
  bool _aCompteBanque = false;
  bool _pratiqueTontine = false;
  
  // Crédit
  bool _aDesCredits = false;
  String? _institutionCredit;
  String? _raisonCredit;
  String? _statutCredit;
  final _montantCreditController = TextEditingController();

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
        'createdAt': DateTime.now().toIso8601String(),
        'syncStatus': 'local',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Données financières enregistrées !'), backgroundColor: Colors.green),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finances & Crédits'), backgroundColor: const Color(0xFFF77F00)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('INFORMATIONS FINANCIÈRES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF77F00))),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Avez-vous un compte bancaire ou mobile money actif ?'),
                value: _aCompteBanque,
                onChanged: (v) => setState(() => _aCompteBanque = v),
              ),
              SwitchListTile(
                title: const Text('Participez-vous à une tontine ?'),
                value: _pratiqueTontine,
                onChanged: (v) => setState(() => _pratiqueTontine = v),
              ),
              SwitchListTile(
                title: const Text('Recevez-vous des aides financières régulières ?'),
                value: _recoitAideFinanciere,
                onChanged: (v) => setState(() => _recoitAideFinanciere = v),
              ),
              if (_recoitAideFinanciere)
                TextFormField(
                  controller: _montantAideController,
                  decoration: const InputDecoration(labelText: 'Montant estimé par an (FCFA)'),
                  keyboardType: TextInputType.number,
                ),

              const Divider(height: 40, thickness: 2),
              
              const Text('CRÉDITS EN COURS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF77F00))),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Avez-vous un crédit en cours de remboursement ?'),
                value: _aDesCredits,
                onChanged: (v) => setState(() => _aDesCredits = v),
              ),
              if (_aDesCredits) ...[
                DropdownButtonFormField<String>(
                isExpanded: true,
                  value: _institutionCredit,
                  decoration: const InputDecoration(labelText: 'Institution de crédit'),
                  items: ['Banque', 'Institution de Microfinance', 'Commerçant', 'Chef de tontine', 'Acheteur d\'or', 'Ami', 'Famille', 'Groupement/association', 'Autre']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _institutionCredit = v),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                isExpanded: true,
                  value: _raisonCredit,
                  decoration: const InputDecoration(labelText: 'Pour quelle raison ?'),
                  items: ['Evènement social', 'Maladie', 'Rentrée scolaire', 'Commerce', 'Agriculture', 'Construction', 'Autre']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _raisonCredit = v),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                isExpanded: true,
                  value: _statutCredit,
                  decoration: const InputDecoration(labelText: 'Statut actuel du crédit'),
                  items: ['Remboursé', 'En cours de remboursement', 'Retard']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _statutCredit = v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _montantCreditController,
                  decoration: const InputDecoration(labelText: 'Montant total du crédit (FCFA)'),
                  keyboardType: TextInputType.number,
                ),
              ],

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
