import 'package:flutter/material.dart';
import '../models/pap.dart';
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Dossier: ${widget.pap.nomPap}'),
        backgroundColor: const Color(0xFFF77F00),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statut global du dossier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // IDENTITÉ (Déjà rempli via le PapStepper)
            _buildSectionCard(
              title: 'Identité & Origine',
              icon: Icons.person,
              color: Colors.green,
              isCompleted: true, // L'identité est le point d'entrée
              onTap: () {
                // Navigation vers le PapStepperScreen existant pour modif
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Déjà rempli à la création du PAP.')));
              },
            ),

            // MENAGE
            _buildSectionCard(
              title: 'Ménage & Habitat',
              icon: Icons.family_restroom,
              color: const Color(0xFF009E60),
              isCompleted: false, // TODO: Vérifier via DB
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MenageFormScreen(idPap: widget.pap.identifiantPap ?? '')),
                );
              },
            ),

            // LOGEMENT & MATERIAUX
            _buildSectionCard(
              title: 'Logement & Matériaux',
              icon: Icons.house,
              color: const Color(0xFF009E60),
              isCompleted: false, // À connecter avec SQLite
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LogementFormScreen(idMenage: widget.pap.identifiantPap ?? '')),
                );
              },
            ),

            // ACTIVITE
            _buildSectionCard(
              title: 'Activités & Revenus',
              icon: Icons.work,
              color: const Color(0xFF009E60),
              isCompleted: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ActiviteFormScreen(idPap: widget.pap.identifiantPap ?? '')),
                );
              },
            ),

            // AGRICULTURE & ÉLEVAGE
            _buildSectionCard(
              title: 'Agriculture & Élevage',
              icon: Icons.agriculture,
              color: const Color(0xFF8B4513), // Marron
              isCompleted: false,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AgricultureFormScreen(idMenage: widget.pap.identifiantPap ?? '')),
                );
              },
            ),
            const SizedBox(height: 12),

            // FINANCES & CRÉDITS
            _buildSectionCard(
              title: 'Finances & Crédits',
              icon: Icons.account_balance_wallet,
              color: Colors.indigo,
              isCompleted: false,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FinanceFormScreen(idMenage: widget.pap.identifiantPap ?? '')),
                );
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
                  MaterialPageRoute(builder: (_) => SecuriteAlimentaireFormScreen(idMenage: widget.pap.identifiantPap ?? '')),
                );
              },
            ),
            const SizedBox(height: 12),

            // SANTÉ & ÉDUCATION
            _buildSectionCard(
              title: 'Santé & Éducation',
              icon: Icons.health_and_safety,
              color: const Color(0xFF009E60),
              isCompleted: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SanteEducationFormScreen(idPap: widget.pap.identifiantPap ?? '')),
                );
              },
            ),

            // AVIS SUR LE PROJET
            _buildSectionCard(
              title: 'Avis sur le Projet',
              icon: Icons.forum,
              color: const Color(0xFF009E60),
              isCompleted: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AvisProjetFormScreen(idPap: widget.pap.identifiantPap ?? '')),
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
