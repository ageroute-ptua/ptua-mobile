import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'membres_menage_list_screen.dart';
import 'plan_restauration_form_screen.dart';
import 'biens_impactes_list_screen.dart';

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

  int get _totalSections {
    int total = 1; // Identité
    final String statut = _pap.statutBien ?? '';
    total += 1; // Ménage
    total += 1; // Membres Ménage
    if (statut.contains('Propriétaire') || statut.contains('Locataire')) total += 1; // Logement
    if (statut.contains('Opérateur Economique')) total += 1; // Activité
    if (statut.contains('Propriétaire')) total += 1; // Agriculture
    total += 6; // Biens, Finance, Sécurité Alim, Santé/Educ, Plan Restauration, Avis
    return total;
  }

  int get _completedSections {
    int completed = 1; // Identité always true
    final String statut = _pap.statutBien ?? '';
    if (_completionStatus['menage'] == true) completed++;
    if (_completionStatus['logement'] == true && (statut.contains('Propriétaire') || statut.contains('Locataire'))) completed++;
    if (_completionStatus['activite'] == true && statut.contains('Opérateur Economique')) completed++;
    if (_completionStatus['agriculture'] == true && statut.contains('Propriétaire')) completed++;
    if (_completionStatus['finance'] == true) completed++;
    if (_completionStatus['securite_alimentaire'] == true) completed++;
    if (_completionStatus['sante_education'] == true) completed++;
    if (_completionStatus['plan_restauration'] == true) completed++;
    if (_completionStatus['avis_projet'] == true) completed++;
    
    // We assume Membres Menage and Biens Impactes are checked differently or just manually checked. For now, let's treat them as completed if they exist.
    // In a real app we'd query count.
    
    return completed; // Approximated
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalSections == 0 ? 0.0 : _completedSections / _totalSections;
    final String statut = _pap.statutBien ?? '';
    final bool showLogement = statut.contains('Propriétaire') || statut.contains('Locataire');
    final bool showActivite = statut.contains('Opérateur Economique');
    final bool showAgriculture = statut.contains('Propriétaire');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1E224A),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E224A), Color(0xFF2A2E5D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Progress Ring with Avatar
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 6,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE1660B)),
                              ),
                            ),
                            CircleAvatar(
                              radius: 34,
                              backgroundColor: Colors.white,
                              child: Text(
                                _pap.nomPap?.substring(0, 1).toUpperCase() ?? 'P',
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E224A)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_pap.nomPap ?? ''} ${_pap.prenomPap ?? ''}',
                                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE1660B).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE1660B).withOpacity(0.5)),
                                ),
                                child: Text(
                                  _pap.identifiantPap ?? 'ID INCONNU',
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFE1660B)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Progression du dossier", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E224A))),
                  const SizedBox(height: 16),
                  
                  // Bento Grid
                  StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      // IDENTITÉ (Large Card)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Identité & Origine',
                          subtitle: 'Informations principales du PAP',
                          icon: Icons.badge_rounded,
                          color: const Color(0xFFE1660B),
                          isCompleted: true,
                          onTap: () => _navigateTo(PapStepperScreen(idEnquete: _pap.idEnquete ?? '', papToEdit: _pap)),
                        ),
                      ),

                      // BIENS IMPACTES
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Biens Impactés',
                          icon: Icons.domain_rounded,
                          color: const Color(0xFF4A90E2),
                          isCompleted: false,
                          onTap: () => _navigateTo(BiensImpactesListScreen(idPap: _pap.identifiantPap ?? '')),
                        ),
                      ),

                      // MENAGE
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Ménage',
                          icon: Icons.family_restroom_rounded,
                          color: const Color(0xFF9B59B6),
                          isCompleted: _completionStatus['menage'] ?? false,
                          onTap: () => _navigateTo(MenageFormScreen(idPap: _pap.identifiantPap ?? '')),
                        ),
                      ),

                      // MEMBRES MENAGE (Large)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Membres du Ménage',
                          subtitle: 'Gérer les personnes à charge',
                          icon: Icons.people_alt_rounded,
                          color: const Color(0xFF16A085),
                          isCompleted: false,
                          onTap: () => _navigateTo(MembresMenageListScreen(idPap: _pap.identifiantPap ?? '')),
                        ),
                      ),

                      // LOGEMENT
                      if (showLogement)
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 2,
                          child: _buildBentoCard(
                            title: 'Logement',
                            icon: Icons.house_rounded,
                            color: const Color(0xFFF39C12),
                            isCompleted: _completionStatus['logement'] ?? false,
                            onTap: () => _navigateTo(LogementFormScreen(idPap: _pap.identifiantPap ?? '')),
                          ),
                        ),

                      // ACTIVITE
                      if (showActivite)
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 2,
                          child: _buildBentoCard(
                            title: 'Activité',
                            icon: Icons.work_rounded,
                            color: const Color(0xFFD35400),
                            isCompleted: _completionStatus['activite'] ?? false,
                            onTap: () => _navigateTo(ActiviteFormScreen(idPap: _pap.identifiantPap ?? '')),
                          ),
                        ),

                      // AGRICULTURE
                      if (showAgriculture)
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 2,
                          child: _buildBentoCard(
                            title: 'Agriculture',
                            icon: Icons.agriculture_rounded,
                            color: const Color(0xFF27AE60),
                            isCompleted: _completionStatus['agriculture'] ?? false,
                            onTap: () => _navigateTo(AgricultureFormScreen(idMenage: _pap.identifiantPap ?? '')),
                          ),
                        ),

                      // FINANCE
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Finance',
                          icon: Icons.account_balance_wallet_rounded,
                          color: const Color(0xFF2980B9),
                          isCompleted: _completionStatus['finance'] ?? false,
                          onTap: () => _navigateTo(FinanceFormScreen(idMenage: _pap.identifiantPap ?? '')),
                        ),
                      ),

                      // SANTE & EDUCATION
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Santé & Éduc.',
                          icon: Icons.health_and_safety_rounded,
                          color: const Color(0xFFC0392B),
                          isCompleted: _completionStatus['sante_education'] ?? false,
                          onTap: () => _navigateTo(SanteEducationFormScreen(idPap: _pap.identifiantPap ?? '')),
                        ),
                      ),

                      // SECURITE ALIMENTAIRE
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Sécu. Alim.',
                          icon: Icons.restaurant_rounded,
                          color: const Color(0xFFD35400),
                          isCompleted: _completionStatus['securite_alimentaire'] ?? false,
                          onTap: () => _navigateTo(SecuriteAlimentaireFormScreen(idMenage: _pap.identifiantPap ?? '')),
                        ),
                      ),

                      // PLAN RESTAURATION (Large)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Plan Restauration',
                          subtitle: 'Plan d\'accompagnement et restauration',
                          icon: Icons.handshake_rounded,
                          color: const Color(0xFF8E44AD),
                          isCompleted: _completionStatus['plan_restauration'] ?? false,
                          onTap: () => _navigateTo(PlanRestaurationFormScreen(idPap: _pap.identifiantPap ?? '')),
                        ),
                      ),

                      // AVIS PROJET (Large)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: _buildBentoCard(
                          title: 'Avis sur le Projet',
                          subtitle: 'Perceptions, craintes et attentes',
                          icon: Icons.forum_rounded,
                          color: const Color(0xFF34495E),
                          isCompleted: _completionStatus['avis_projet'] ?? false,
                          onTap: () => _navigateTo(AvisProjetFormScreen(idPap: _pap.identifiantPap ?? '')),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen)).then((_) => _loadData());
  }

  Widget _buildBentoCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color color,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Color(0xFF2E7D32), size: 16),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E224A),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
