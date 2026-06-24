import 'package:flutter/material.dart';

class PremiumMultiSelect extends StatefulWidget {
  final String? initialValue;
  final String label;
  final IconData icon;
  final List<String> items;
  final void Function(String?) onChanged;
  final bool showSearch;

  const PremiumMultiSelect({
    super.key,
    required this.initialValue,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.showSearch = false,
  });

  @override
  State<PremiumMultiSelect> createState() => _PremiumMultiSelectState();
}

class _PremiumMultiSelectState extends State<PremiumMultiSelect> {
  List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _parseInitialValue();
  }

  @override
  void didUpdateWidget(covariant PremiumMultiSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _parseInitialValue();
    }
  }

  void _parseInitialValue() {
    if (widget.initialValue == null || widget.initialValue!.isEmpty) {
      _selectedItems = [];
    } else {
      _selectedItems = widget.initialValue!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
  }

  void _showBottomSheet(BuildContext context) {
    String searchQuery = '';
    // Copie locale pour le bottom sheet (permet d'annuler si on ferme sans valider, bien qu'ici on valide direct ou par bouton)
    List<String> tempSelected = List.from(_selectedItems);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredItems = widget.items.where((item) {
              if (searchQuery.isEmpty) return true;
              return item.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(widget.icon, color: const Color(0xFFE1660B)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E224A),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(ctx),
                        )
                      ],
                    ),
                  ),
                  if (widget.showSearch || widget.items.length > 8)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        onChanged: (val) {
                          setState(() {
                            searchQuery = val;
                          });
                        },
                      ),
                    ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = tempSelected.contains(item);
                        return CheckboxListTile(
                          title: Text(item, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          value: isSelected,
                          activeColor: const Color(0xFFE1660B),
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                tempSelected.add(item);
                              } else {
                                tempSelected.remove(item);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  // Bouton Valider
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Sauvegarder
                          String? finalValue;
                          if (tempSelected.isNotEmpty) {
                            finalValue = tempSelected.join(', ');
                          }
                          widget.onChanged(finalValue);
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE1660B),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Valider la sélection', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayText = 'Sélectionner...';
    if (_selectedItems.isNotEmpty) {
      displayText = _selectedItems.join(', ');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showBottomSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(widget.icon, color: const Color(0xFFE1660B)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.label,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1660B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Choix Multiple', style: TextStyle(fontSize: 10, color: Color(0xFFE1660B), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedItems.isEmpty ? 'Sélectionner...' : displayText,
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedItems.isEmpty ? Colors.grey.shade400 : Colors.black87,
                          fontWeight: _selectedItems.isEmpty ? FontWeight.normal : FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.checklist, color: Color(0xFF1E224A)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
