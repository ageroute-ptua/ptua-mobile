import 'package:flutter/material.dart';

class FinanceFormScreen extends StatefulWidget {
  final String idMenage;
  const FinanceFormScreen({super.key, required this.idMenage});

  @override
  State<FinanceFormScreen> createState() => _FinanceFormScreenState();
}

class _FinanceFormScreenState extends State<FinanceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Finances
  bool _recoitAideFinanciere = false;
  final _montantAideController = TextEditingController();
  bool _aCompteBanque = false;
  bool _pratiqueTontine = false;
  
  // Crédit
  bool _aDesCredits = false;
  final _institutionCreditController = TextEditingController();
  final _montantCreditController = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Données financières enregistrées.')));
    Navigator.pop(context, true);
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
              const Text('INFORMATIONS FINANCIÈRES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
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
              
              const Text('CRÉDITS EN COURS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Avez-vous un crédit en cours de remboursement ?'),
                value: _aDesCredits,
                onChanged: (v) => setState(() => _aDesCredits = v),
              ),
              if (_aDesCredits) ...[
                TextFormField(
                  controller: _institutionCreditController,
                  decoration: const InputDecoration(labelText: 'Institution (Banque, Microfinance, Particulier)'),
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
