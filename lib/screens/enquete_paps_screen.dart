import 'package:flutter/material.dart';
import '../models/enquete.dart';
import '../models/pap.dart';
import '../services/database_helper.dart';
import '../services/pdf_service.dart';
import 'pap_stepper_screen.dart';
import 'pap_dashboard_screen.dart';

class EnquetePapsScreen extends StatefulWidget {
  final Enquete enquete;
  const EnquetePapsScreen({super.key, required this.enquete});

  @override
  State<EnquetePapsScreen> createState() => _EnquetePapsScreenState();
}

class _EnquetePapsScreenState extends State<EnquetePapsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Pap> _allPaps = [];
  List<Pap> _filteredPaps = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPaps();
    _searchController.addListener(_filterPaps);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPaps() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPaps = List.from(_allPaps);
      } else {
        _filteredPaps = _allPaps.where((pap) {
          final nomMatch = pap.nomPap.toLowerCase().contains(query);
          final idMatch = pap.identifiantPap?.toLowerCase().contains(query) ?? false;
          return nomMatch || idMatch;
        }).toList();
      }
    });
  }

  Future<void> _loadPaps() async {
    final paps = await _dbHelper.getPapsForEnquete(widget.enquete.idEnquete);
    setState(() {
      _allPaps = paps;
      _filterPaps();
    });
  }

  Future<void> _confirmDeletePap(Pap pap) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Voulez-vous vraiment supprimer le PAP ${pap.nomPap} ? Toutes ses données (Santé, Éducation, Activités) seront perdues.'),
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

    if (confirm == true && pap.id != null) {
      await _dbHelper.deletePap(pap.id!);
      _loadPaps();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PAP supprimé'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAPs de ${widget.enquete.idEnquete}', style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFFF77F00),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            tooltip: 'Générer Fiche PDF',
            onPressed: () async {
              try {
                await PdfService.generateAndPrintEnquetePdf(widget.enquete);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur PDF: $e")));
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un PAP (Nom, ID)',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFF77F00)),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredPaps.isEmpty
                ? RefreshIndicator(
                    onRefresh: _loadPaps,
                    color: const Color(0xFFE1660B),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(child: Text("Aucun PAP trouvé.")),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadPaps,
                    color: const Color(0xFFE1660B),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _filteredPaps.length,
                      itemBuilder: (context, index) {
                        final pap = _filteredPaps[index];
                        final isSynced = pap.syncStatus == 'synced';
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              isSynced ? Icons.cloud_done : Icons.cloud_off,
                              color: isSynced ? Colors.green : Colors.orange,
                            ),
                            title: Text(pap.nomPap, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('ID: ${pap.identifiantPap ?? "N/A"}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _confirmDeletePap(pap);
                                    } else if (value == 'edit') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('La modification se fait en cliquant sur le PAP.'))
                                      );
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
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                            onTap: () {
                              // Ouvre le Dashboard pour éditer toutes les sections du PAP
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => PapDashboardScreen(pap: pap)),
                              ).then((_) => _loadPaps());
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Crée un nouveau PAP
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PapStepperScreen(idEnquete: widget.enquete.idEnquete)),
          );
          if (result == true) _loadPaps();
        },
        backgroundColor: const Color(0xFF009E60),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Nouveau PAP', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
