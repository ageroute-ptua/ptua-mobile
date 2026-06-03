import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';
import '../providers/sync_provider.dart';
import '../providers/avatar_provider.dart';
import '../models/enquete.dart';
import 'enquete_paps_screen.dart';
import 'enquete_list_screen.dart';
import 'enquete_form_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Enquete> _enquetes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _dbHelper.getEnquetes();
    setState(() {
      _enquetes = data;
    });
  }

  Future<void> _handleSync() async {
    final success = await ref.read(syncStateProvider.notifier).syncData();
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Synchronisation réussie ! Les données ont été envoyées.')),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Échec de la synchronisation. Vérifiez votre connexion ou le serveur.')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
      _loadData();
    }
  }

  Future<void> _confirmDelete(Enquete enquete) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Voulez-vous vraiment supprimer l\'enquête ${enquete.idEnquete} ? Toutes les données associées seront perdues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && enquete.id != null) {
      await _dbHelper.deleteEnquete(enquete.id!);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enquête supprimée'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSyncing = ref.watch(syncStateProvider);
    final avatarPath = ref.watch(avatarProvider);
    final int totalEnquetes = _enquetes.length;
    final int pendingSync = _enquetes.where((e) => e.syncStatus != 'synced').length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260.0,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE1660B),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                      : [const Color(0xFFF77F00), const Color(0xFFE1660B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 90.0, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Bonjour,',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                              Text(
                                'Enquêteur 👋',
                                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Naviguer vers les paramètres au clic sur l'avatar
                              // Mais ici c'est juste un feedback visuel, l'utilisateur ira via la BottomNavBar normalement
                              // On peut faire ScaffoldMessenger...
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Allez dans l\'onglet Paramètres pour modifier votre photo'))
                              );
                            },
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              backgroundImage: avatarPath != null ? FileImage(File(avatarPath)) : null,
                              child: avatarPath == null ? const Icon(Icons.person, color: Colors.white, size: 28) : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Aperçu global',
                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildStatCard('Synchronisées', (totalEnquetes - pendingSync).toString(), Icons.cloud_done, Colors.green)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildStatCard('À Sync.', pendingSync.toString(), Icons.cloud_upload, const Color(0xFFE1660B))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              isSyncing
                  ? const Padding(padding: EdgeInsets.all(16.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                  : IconButton(
                      icon: const Icon(Icons.sync, color: Colors.white),
                      onPressed: _handleSync,
                    ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dernières enquêtes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF242A5D),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EnqueteListScreen()),
                      ).then((_) => _loadData());
                    },
                    child: const Text("Voir toutes", style: TextStyle(color: Color(0xFFE1660B))),
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (_enquetes.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          children: [
                            Icon(Icons.assignment_add, size: 80, color: Colors.grey.withOpacity(isDark ? 0.3 : 0.5)),
                            const SizedBox(height: 16),
                            Text(
                              "Aucune enquête en cours",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Allez dans l'onglet Formulaire pour commencer.",
                              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Limiter aux 5 plus récentes
                  final displayList = _enquetes.take(5).toList();
                  final enquete = displayList[index];
                  final isSynced = enquete.syncStatus == 'synced';
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EnquetePapsScreen(enquete: enquete)),
                          );
                          _loadData();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isSynced ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  isSynced ? Icons.cloud_done_rounded : Icons.sync_problem_rounded,
                                  color: isSynced ? Colors.green : Colors.orange,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      enquete.idEnquete,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 18, 
                                        color: isDark ? Colors.white : const Color(0xFF242A5D),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Commune: ${enquete.communeCode ?? "N/A"}',
                                            style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _confirmDelete(enquete);
                                  } else if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EnqueteFormScreen(enqueteToEdit: enquete),
                                      ),
                                    ).then((_) => _loadData());
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: _enquetes.isEmpty ? 1 : (_enquetes.length > 5 ? 5 : _enquetes.length),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
