import 'package:flutter/material.dart';
import '../models/bien_impacte.dart';
import '../services/database_helper.dart';
import 'bien_impacte_form_screen.dart';

class BiensImpactesListScreen extends StatefulWidget {
  final String idPap;
  const BiensImpactesListScreen({super.key, required this.idPap});

  @override
  State<BiensImpactesListScreen> createState() => _BiensImpactesListScreenState();
}

class _BiensImpactesListScreenState extends State<BiensImpactesListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<BienImpacte> _biens = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBiens();
  }

  Future<void> _loadBiens() async {
    setState(() => _isLoading = true);
    final biensMap = await _dbHelper.getBiensImpactes(widget.idPap);
    setState(() {
      _biens = biensMap.map((map) => BienImpacte.fromMap(map)).toList();
      _isLoading = false;
    });
  }

  Future<void> _deleteBien(int id) async {
    await _dbHelper.deleteBienImpacte(id);
    _loadBiens();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bien supprimé')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Biens Impactés', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E224A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _biens.isEmpty
              ? const Center(child: Text('Aucun bien impacté enregistré.'))
              : ListView.builder(
                  itemCount: _biens.length,
                  itemBuilder: (context, index) {
                    final bien = _biens[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE1660B),
                          child: Icon(
                            bien.categorie == 'Foncier' ? Icons.landscape :
                            bien.categorie == 'Bati' ? Icons.home :
                            bien.categorie == 'Agricole' ? Icons.agriculture :
                            bien.categorie == 'ActiviteCommerciale' ? Icons.store : Icons.build,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(bien.categorie ?? 'Inconnu', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(bien.caracBienImpactes ?? 'Pas de détail'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => BienImpacteFormScreen(idPap: widget.idPap, bienToEdit: bien)),
                                );
                                if (result == true) _loadBiens();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteBien(bien.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BienImpacteFormScreen(idPap: widget.idPap)),
          );
          if (result == true) _loadBiens();
        },
        backgroundColor: const Color(0xFFE1660B),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajouter un bien', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
