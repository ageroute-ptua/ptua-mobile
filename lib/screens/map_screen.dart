import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../models/localisation.dart';
import '../models/enquete.dart';
import '../services/database_helper.dart';

class MapMarkerData {
  final Localisation loc;
  final Enquete enquete;

  MapMarkerData(this.loc, this.enquete);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<MapMarkerData> _allMarkers = [];
  List<MapMarkerData> _filteredMarkers = [];
  List<String> _communes = [];
  String? _selectedCommune;
  bool _isLoading = true;
  String _searchQuery = '';
  final MapController _mapController = MapController();
  bool _isSatellite = false;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  String? _selectedVille;
  final Map<String, Map<String, dynamic>> _villesData = {
    'Abidjan': {
      'center': const LatLng(5.30966, -4.01266),
      'communes': ['Abobo', 'Adjamé', 'Attécoubé', 'Cocody', 'Koumassi', 'Marcory', 'Plateau', 'Port-Bouët', 'Treichville', 'Yopougon']
    },
    'Bouaké': {
      'center': const LatLng(7.68959, -5.02808),
      'communes': ['Bouaké', 'Ahougnanssou', 'Dar-Es-Salam', 'Koko']
    },
    'Yamoussoukro': {
      'center': const LatLng(6.82762, -5.28934),
      'communes': ['Yamoussoukro', 'Attiégouakro']
    },
    'San-Pédro': {
      'center': const LatLng(4.74851, -6.6363),
      'communes': ['San-Pédro', 'Bardot', 'Séwéké']
    }
  };

  List<String> _getFilteredCommunes() {
    if (_selectedVille == null || _selectedVille == 'Toutes') {
      return _communes;
    }
    return (_villesData[_selectedVille]?['communes'] as List<String>?) ?? [];
  }

  @override
  void initState() {
    super.initState();
    _loadLocalisations();
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    _positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (mounted) setState(() => _currentPosition = position);
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _loadLocalisations() async {
    final locs = await _dbHelper.getAllLocalisations();
    final enquetes = await _dbHelper.getEnquetes();
    
    final Map<String, Enquete> enqueteMap = { for (var e in enquetes) e.idEnquete: e };
    
    List<MapMarkerData> markers = [];
    Set<String> communesSet = {};

    for (var loc in locs) {
      if (enqueteMap.containsKey(loc.idEnquete)) {
        final enq = enqueteMap[loc.idEnquete]!;
        markers.add(MapMarkerData(loc, enq));
        if (enq.communeCode != null && enq.communeCode!.isNotEmpty) {
          communesSet.add(enq.communeCode!);
        }
      }
    }

    if (mounted) {
      setState(() {
        _allMarkers = markers;
        _filteredMarkers = markers;
        _communes = communesSet.toList()..sort();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredMarkers = _allMarkers.where((m) {
        final matchesSearch = m.enquete.idEnquete.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCommune = _selectedCommune == null || _selectedCommune == 'Toutes' || m.enquete.communeCode == _selectedCommune;
        return matchesSearch && matchesCommune;
      }).toList();
    });
  }

  void _filterLocalisations(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  Future<void> _openRoute(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Impossible d'ouvrir l'itinéraire GPS.")),
        );
      }
    }
  }

  void _fitBounds() {
    if (_filteredMarkers.isEmpty) return;
    final validLocs = _filteredMarkers.where((m) => m.loc.latitude != null && m.loc.longitude != null).map((m) => m.loc).toList();
    if (validLocs.isEmpty) return;
    
    final points = validLocs.map((l) => LatLng(l.latitude!, l.longitude!)).toList();
    if (points.length == 1) {
      _mapController.move(points.first, 15.0);
    } else {
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)));
    }
  }

  void _showMarkerDetails(Localisation loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1660B).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on, color: Color(0xFFE1660B), size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.idEnquete,
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF242A5D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Enquête localisée",
                          style: TextStyle(color: Colors.grey[500], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(Icons.gps_fixed, "Latitude", loc.latitude?.toStringAsFixed(5) ?? "N/A"),
                  _buildDetailItem(Icons.gps_not_fixed, "Longitude", loc.longitude?.toStringAsFixed(5) ?? "N/A"),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(Icons.radar, "Précision", "${loc.precisionGps?.toStringAsFixed(1) ?? '--'} m"),
                  _buildDetailItem(Icons.height, "Altitude", "${loc.altitude?.toStringAsFixed(1) ?? '--'} m"),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text("Fermer"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        if (loc.latitude != null && loc.longitude != null) {
                          _openRoute(loc.latitude!, loc.longitude!);
                        }
                      },
                      icon: const Icon(Icons.directions_car, color: Colors.white),
                      label: const Text("S'y rendre", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009E60),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  String get _tileUrl {
    if (_isSatellite) {
      return 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}';
    } else {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return isDark 
          ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
          : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng center = _filteredMarkers.isNotEmpty
        ? LatLng(_filteredMarkers.first.loc.latitude ?? 5.30966, _filteredMarkers.first.loc.longitude ?? -4.01266)
        : const LatLng(5.3096600, -4.0126600);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFE1660B)))
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: center,
                          initialZoom: 12.0,
                          minZoom: 3.0,
                          maxZoom: 18.0,
                          interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: _tileUrl,
                            maxZoom: 19.0,
                            userAgentPackageName: 'ci.ageroute.ptua_mobile',
                          ),
                          MarkerClusterLayerWidget(
                            options: MarkerClusterLayerOptions(
                              maxClusterRadius: 45,
                              size: const Size(40, 40),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(50),
                              maxZoom: 15,
                              markers: _filteredMarkers.map((m) {
                                return Marker(
                                  point: LatLng(m.loc.latitude ?? 0.0, m.loc.longitude ?? 0.0),
                                  width: 50,
                                  height: 50,
                                  child: GestureDetector(
                                    onTap: () => _showMarkerDetails(m.loc),
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Color(0xFFE1660B),
                                      size: 40,
                                    ),
                                  ),
                                );
                              }).toList(),
                              builder: (context, markers) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFF242A5D),
                                  ),
                                  child: Center(
                                    child: Text(
                                      markers.length.toString(),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_currentPosition != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                  width: 30,
                                  height: 30,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                      border: Border.all(color: Colors.white, width: 3),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5)],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                
                // Floating Action Buttons (Map Types & Center)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        heroTag: 'mapCenterFab',
                        mini: true,
                        backgroundColor: Theme.of(context).cardColor,
                        onPressed: _fitBounds,
                        child: const Icon(Icons.center_focus_strong, color: Color(0xFFE1660B)),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'mapTypeFab',
                        mini: true,
                        backgroundColor: Theme.of(context).cardColor,
                        onPressed: () {
                          setState(() {
                            _isSatellite = !_isSatellite;
                          });
                        },
                        child: Icon(
                          _isSatellite ? Icons.map : Icons.satellite_alt, 
                          color: const Color(0xFFE1660B)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Panneau de Filtre (En Bas)
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filtres de la carte",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF242A5D),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1660B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${_filteredMarkers.length} résultat(s)",
                          style: const TextStyle(color: Color(0xFFE1660B), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: _filterLocalisations,
                    decoration: InputDecoration(
                      hintText: "Rechercher un ID...",
                      prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                              onPressed: () {
                                _filterLocalisations('');
                                FocusScope.of(context).unfocus();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedVille,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.location_city, color: Colors.grey, size: 20),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          ),
                          hint: const Text('Ville...'),
                          isExpanded: true,
                          items: ['Toutes', ..._villesData.keys].map((v) {
                            return DropdownMenuItem<String>(
                              value: v == 'Toutes' ? null : v,
                              child: Text(v, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedVille = val;
                              _selectedCommune = null;
                              _applyFilters();
                            });
                            if (val != null && val != 'Toutes') {
                              final center = _villesData[val]!['center'] as LatLng;
                              _mapController.move(center, 12.0);
                            } else {
                              _fitBounds();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCommune,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.map, color: Colors.grey, size: 20),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          ),
                          hint: const Text('Commune...'),
                          isExpanded: true,
                          items: ['Toutes', ..._getFilteredCommunes()].map((c) {
                            return DropdownMenuItem<String>(
                              value: c == 'Toutes' ? null : c,
                              child: Text(c, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedCommune = val;
                              _applyFilters();
                            });
                            if (val != null && val != 'Toutes') {
                              _fitBounds();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
