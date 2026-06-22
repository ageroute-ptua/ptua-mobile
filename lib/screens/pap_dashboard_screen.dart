import 'package:flutter/material.dart';
import '../models/pap.dart';
import '../services/database_helper.dart';
import 'pap_stepper_screen.dart';
import 'menage_form_screen.dart';
import 'activite_form_screen.dart';
import 'logement_form_screen.dart';
import 'agriculture_form_screen.dart';
import 'finance_form_screen.dart';
import 'securite_alimentaire_form_screen.dart';
import 'avis_projet_form_screen.dart';
import 'sante_education_form_screen.dart';

class PapDashboardScreen extends StatefulWidget {
  final Pap pap;
  const PapDashboardScreen({super.key, required this.pap});

  @override
  State<PapDashboardScreen> createState() => _PapDashboardScreenState();
}

class _PapDashboardScreenState extends State<PapDashboardScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, bool> _completionStatus = {};
  bool _isLoading = true;
  late Pap _pap;

  @override
  void initState() {
    super.initState();
    _pap = widget.pap;
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final idPap = _pap.identifiantPap ?? '';
      
      // Reload PAP details from database in case they were edited
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('paps', where: 'identifiantPap = ?', whereArgs: [idPap]);
      if (maps.isNotEmpty) {
        _pap = Pap.fromMap(maps.first);
      }

      final status = await _dbHelper.getPapCompletionStatus(idPap);
      if (mounted) setState(() { _completionStatus = status; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Dossier: ${_pap.nomPap}'),
        backgroundColor: const Color(0xFFF77F00),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadData,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de progression globale
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complété: ${_completionStatus.values.where((v) => v).length + 1}/${_completionStatus.length + 1} sections',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF009E60)),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_completionStatus.values.where((v) => v).length + 1) / (_completionStatus.length + 1),
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF009E60),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            
            // IDENTITÉ (toujours complété)
            _buildSectionCard(
              title: 'Identité & Origine',
              icon: Icons.person,
              color: Colors.green,
              isCompleted: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PapStepperScreen(idEnquete: _pap.idEnquete ?? '', papToEdit: _pap)),
                ).then((_) => _loadData());
              },
            ),

            // LOGIQUE CONDITIONNELLE
            Builder(
              builder: (context) {
                final String statut = _pap.statutBien ?? '';
                final bool showLogement = statut.contains('Propriétaire') || statut.contains('Locataire');
                final bool showActivite = statut.contains('Opérateur Economique');
                final bool showAgriculture = statut.contains('Propriétaire');

                return Column(
                  children: [
                    // MENAGE
                    _buildSectionCard(
                      title: 'Ménage & Habitat',
                      icon: Icons.family_restroom,
                      color: const Color(0xFF009E60),
                      isCompleted: _completionStatus['menage'] ?? false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MenageFormScreen(idPap: _pap.identifiantPap ?? '')),
                        ).then((_) => _loadData());
                      },
                    ),

                    // LOGEMENT & MATERIAUX
                    if (showLogement)
                      _buildSectionCard(
                        title: 'Logement & Matériaux',
                        icon: Icons.house,
                        color: const Color(0xFF009E60),
                        isCompleted: _completionStatus['logement'] ?? false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LogementFormScreen(idPap: _pap.identifiantPap ?? '')),
                          ).then((_) => _loadData());
                        },
                      ),

                    // ACTIVITE
                    if (showActivite)
                      _buildSectionCard(
                        title: 'Activités & Revenus',
                        icon: Icons.work,
                        color: const Color(0xFF009E60),
                        isCompleted: _completionStatus['activite'] ?? false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ActiviteFormScreen(idPap: _pap.identifiantPap ?? '')),
                          ).then((_) => _loadData());
                        },
                      ),

                    // AGRICULTURE & ÉLEVAGE
                    if (showAgriculture)
                      Column(
                        children: [
                          _buildSectionCard(
                            title: 'Agriculture & Élevage',
                            icon: Icons.agriculture,
                            color: const Color(0xFF8B4513),
                            isCompleted: _completionStatus['agriculture'] ?? false,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AgricultureFormScreen(idMenage: _pap.identifiantPap ?? '')),
                              );
                              _loadData();
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),

                    // FINANCES & CRÉDITS
            _buildSectionCard(
              title: 'Finances & Crédits',
              icon: Icons.account_balance_wallet,
              color: Colors.indigo,
              isCompleted: _completionStatus['finance'] ?? false,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FinanceFormScreen(idMenage: _pap.identifiantPap ?? '')),
                );
                _loadData();
              },
            ),
            const SizedBox(height: 12),

            // SÉCURITÉ ALIMENTAIRE
            _buildSectionCard(
              title: 'Sécurité Alimentaire',
              icon: Icons.food_bank,
              color: Colors.redAccent,
              isCompleted: false,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SecuriteAlimentaireFormScreen(idMenage: _pap.identifiantPap ?? '')),
                );
                _loadData();
              },
            ),
            const SizedBox(height: 12),

            // SANTÉ & ÉDUCATION
            _buildSectionCard(
              title: 'Santé & Éducation',
              icon: Icons.health_and_safety,
              color: const Color(0xFF009E60),
              isCompleted: _completionStatus['sante'] ?? false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SanteEducationFormScreen(idPap: _pap.identifiantPap ?? '')),
                ).then((_) => _loadData());
              },
            ),

                    // AVIS SUR LE PROJET
                    _buildSectionCard(
                      title: 'Avis sur le Projet',
                      icon: Icons.forum,
                      color: const Color(0xFF009E60),
                      isCompleted: _completionStatus['avis'] ?? false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AvisProjetFormScreen(idPap: _pap.identifiantPap ?? '')),
                        ).then((_) => _loadData());
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(isCompleted ? 'Complété' : 'À renseigner', style: TextStyle(color: isCompleted ? Colors.green : Colors.redAccent)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
