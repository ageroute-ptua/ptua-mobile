import 'package:flutter/material.dart';
import '../models/membre_menage.dart';
import '../services/database_helper.dart';
import 'membre_menage_form_screen.dart';

class MembresMenageListScreen extends StatefulWidget {
  final String idPap;
  const MembresMenageListScreen({super.key, required this.idPap});

  @override
  State<MembresMenageListScreen> createState() => _MembresMenageListScreenState();
}

class _MembresMenageListScreenState extends State<MembresMenageListScreen> {
  final _dbHelper = DatabaseHelper();
  List<MembreMenage> _membres = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembres();
  }

  Future<void> _loadMembres() async {
    setState(() => _isLoading = true);
    final data = await _dbHelper.getMembresMenageByPap(widget.idPap);
    setState(() {
      _membres = data.map((e) => MembreMenage.fromMap(e)).toList();
      _isLoading = false;
    });
  }

  Future<void> _deleteMembre(int id) async {
    await _dbHelper.deleteMembreMenage(id);
    _loadMembres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Membres du Ménage', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E224A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _membres.isEmpty
              ? const Center(child: Text('Aucun membre enregistré.'))
              : ListView.builder(
                  itemCount: _membres.length,
                  itemBuilder: (context, index) {
                    final membre = _membres[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF1E224A),
                          child: Text(membre.nomPrenom.isNotEmpty ? membre.nomPrenom[0] : '?', style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(membre.nomPrenom, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${membre.lienChefMenage} - ${membre.sexe ?? ''} - ${membre.age != null ? '${membre.age} ans' : ''}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: const Text('Supprimer'),
                                content: const Text('Voulez-vous supprimer ce membre ?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(c), child: const Text('Non')),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(c);
                                      _deleteMembre(membre.idMembre!);
                                    },
                                    child: const Text('Oui', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE1660B),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MembreMenageFormScreen(idPap: widget.idPap),
            ),
          );
          if (result == true) {
            _loadMembres();
          }
        },
      ),
    );
  }
}
