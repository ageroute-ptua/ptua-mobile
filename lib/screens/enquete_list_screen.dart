import 'package:flutter/material.dart';
import '../models/enquete.dart';
import '../services/database_helper.dart';
import 'enquete_paps_screen.dart';
import 'enquete_form_screen.dart';

class EnqueteListScreen extends StatefulWidget {
  const EnqueteListScreen({super.key});

  @override
  State<EnqueteListScreen> createState() => _EnqueteListScreenState();
}

class _EnqueteListScreenState extends State<EnqueteListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Enquete> _enquetes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final enquetes = await _dbHelper.getEnquetes();
    setState(() {
      _enquetes = enquetes;
      _isLoading = false;
    });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les enquêtes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF77F00),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE1660B)))
          : _enquetes.isEmpty
              ? const Center(child: Text("Aucune enquête enregistrée."))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: _enquetes.length,
                  itemBuilder: (context, index) {
                    final enquete = _enquetes[index];
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
                ),
    );
  }
}
