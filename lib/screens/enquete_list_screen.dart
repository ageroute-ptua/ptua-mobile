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
  List<Enquete> _filteredEnquetes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;

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
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredEnquetes = _enquetes.where((e) {
        final query = _searchQuery.toLowerCase();
        final matchesSearch = query.isEmpty || 
          e.idEnquete.toLowerCase().contains(query) || 
          (e.communeCode ?? '').toLowerCase().contains(query) ||
          (e.quartierCode ?? '').toLowerCase().contains(query);
          
        bool matchesDate = true;
        if (_selectedDateRange != null && e.createdAt != null) {
          final date = e.createdAt!;
          final start = _selectedDateRange!.start;
          final end = _selectedDateRange!.end.add(const Duration(days: 1)); // Includes the whole end day
          matchesDate = date.isAfter(start) && date.isBefore(end);
        }
        
        return matchesSearch && matchesDate;
      }).toList();
    });
  }


  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
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
        backgroundColor: const Color(0xFF1E224A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          if (!_isLoading) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        _searchQuery = val;
                        _applyFilters();
                      },
                      decoration: InputDecoration(
                        hintText: "Rechercher ID, ville ou commune...",
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: _selectedDateRange,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFFE1660B),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDateRange = picked;
                          _applyFilters();
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _selectedDateRange != null ? const Color(0xFFE1660B) : (isDark ? Colors.grey[800] : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: _selectedDateRange != null ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                  if (_selectedDateRange != null) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDateRange = null;
                          _applyFilters();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.clear, color: Colors.red),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE1660B)))
                : _filteredEnquetes.isEmpty
                    ? RefreshIndicator(
                  onRefresh: _loadData,
                  color: const Color(0xFFE1660B),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text("Aucune enquête enregistrée.")),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  color: const Color(0xFFE1660B),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: _filteredEnquetes.length,
                    itemBuilder: (context, index) {
                      final enquete = _filteredEnquetes[index];
                      final isSynced = enquete.syncStatus == 'synced';
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
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
                                      color: isSynced ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
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
                                                'Ville: ${enquete.communeCode ?? "N/A"} - Commune: ${enquete.quartierCode ?? "N/A"}',
                                                style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 12, color: Colors.blueGrey[400]),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Créé: ${_formatDate(enquete.createdAt)}',
                                              style: TextStyle(color: Colors.blueGrey[400], fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        if (enquete.updatedAt != null) ...[
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(Icons.edit_calendar, size: 12, color: Colors.orange[400]),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Modif: ${_formatDate(enquete.updatedAt)}',
                                                style: TextStyle(color: Colors.orange[400], fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
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
                ),
          ),
        ],
      ),
    );
  }
}
