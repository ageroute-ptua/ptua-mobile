import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/enquete.dart';
import '../services/database_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/navigation_provider.dart';

class EnqueteFormScreen extends ConsumerStatefulWidget {
  final Enquete? enqueteToEdit;
  const EnqueteFormScreen({super.key, this.enqueteToEdit});

  @override
  ConsumerState<EnqueteFormScreen> createState() => _EnqueteFormScreenState();
}

class _EnqueteFormScreenState extends ConsumerState<EnqueteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  final _secureStorage = const FlutterSecureStorage();
  
  int _currentStep = 0;
  bool _isSaving = false;
  bool _isLocating = false; // GPS en cours

  final _idEnqueteController = TextEditingController();
  final _communeCodeController = TextEditingController();
  final _quartierCodeController = TextEditingController();
  final _enqueteurController = TextEditingController();

  File? _photoFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.enqueteToEdit != null) {
      // Mode édition : pre-remplir les champs
      _idEnqueteController.text = widget.enqueteToEdit!.idEnquete;
      _communeCodeController.text = widget.enqueteToEdit!.communeCode ?? '';
      _quartierCodeController.text = widget.enqueteToEdit!.quartierCode ?? '';
      _enqueteurController.text = widget.enqueteToEdit!.enqueteur ?? '';
      if (widget.enqueteToEdit!.photoPath != null && File(widget.enqueteToEdit!.photoPath!).existsSync()) {
        _photoFile = File(widget.enqueteToEdit!.photoPath!);
      }
    } else {
      // Nouvelle enquête : auto-détection GPS, ID et Enqueteur
      _generateIdEnquete();
      _loadEnqueteur();
      _autoLocateEnquete();
    }
  }


  Future<void> _generateIdEnquete() async {
    final enquetes = await _dbHelper.getEnquetes();
    int maxId = 0;
    for (var e in enquetes) {
      if (e.id != null && e.id! > maxId) maxId = e.id!;
    }
    final newIdStr = (maxId + 1).toString().padLeft(3, '0');
    if (mounted) {
       setState(() {
         _idEnqueteController.text = "ENQ-$newIdStr";
       });
    }
  }

  Future<void> _loadEnqueteur() async {
    final username = await _secureStorage.read(key: 'username');
    if (username != null && mounted) {
      setState(() {
        _enqueteurController.text = username;
      });
    }
  }

  /// Détecte automatiquement la position GPS et remplit Commune + Quartier
  Future<void> _autoLocateEnquete() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position? position = await Geolocator.getLastKnownPosition();
        if (position == null) {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 5),
          );
        }
        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty && mounted) {
          final place = placemarks.first;
          // Commune = ville ou sous-région administrative
          final commune = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? '';
          // Quartier = sous-localité ou rue
          final quartier = place.subLocality ?? place.thoroughfare ?? place.name ?? '';
          setState(() {
            if (commune.isNotEmpty) _communeCodeController.text = commune.toUpperCase();
            if (quartier.isNotEmpty) _quartierCodeController.text = quartier;
          });
        }
      }
    } catch (e) {
      // Silencieux - l'enquêteur peut remplir manuellement
      debugPrint('GPS enquête non disponible: $e');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _photoFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur Caméra: $e')));
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _photoFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur Fichier: $e')));
    }
  }

  Future<void> _saveEnquete() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      
      final newEnquete = Enquete(
        id: widget.enqueteToEdit?.id,
        idEnquete: _idEnqueteController.text.trim(),
        communeCode: _communeCodeController.text.trim(),
        quartierCode: _quartierCodeController.text.trim(),
        enqueteur: _enqueteurController.text.trim(),
        dateEnquete: widget.enqueteToEdit?.dateEnquete ?? DateTime.now(),
        createdAt: widget.enqueteToEdit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 'local',
        photoPath: _photoFile?.path,
        signaturePath: null,
      );

      if (widget.enqueteToEdit != null) {
        await _dbHelper.updateEnquete(newEnquete);
      } else {
        await _dbHelper.insertEnquete(newEnquete);
      }


      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enquête enregistrée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        
        if (widget.enqueteToEdit != null) {
          Navigator.pop(context);
        } else {
          _idEnqueteController.clear();
          _communeCodeController.clear();
          _quartierCodeController.clear();
          _enqueteurController.clear();
          _photoFile = null;
          setState(() => _currentStep = 0);
          
          ref.read(navigationProvider.notifier).state = 0;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.enqueteToEdit != null ? 'Modifier Enquête' : 'Nouvelle Enquête', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E224A),
        elevation: 0,
        automaticallyImplyLeading: widget.enqueteToEdit != null,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Identification", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF242A5D))),
                    const SizedBox(height: 12),
                    
                    // Indicateur GPS
                    if (_isLocating)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF009E60).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF009E60).withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF009E60))),
                            SizedBox(width: 12),
                            Text('Détection de la position GPS...', style: TextStyle(color: Color(0xFF009E60), fontWeight: FontWeight.w500, fontSize: 13)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _idEnqueteController, 
                      label: 'ID Enquête (Généré automatiquement)', 
                      icon: Icons.qr_code,
                      readOnly: true,
                      fillColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _communeCodeController, 
                      label: 'Ville', 
                      icon: Icons.location_city,
                      textCapitalization: TextCapitalization.characters,
                      suffixIcon: IconButton(
                        icon: _isLocating 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF009E60)))
                          : const Icon(Icons.my_location, color: Color(0xFFE1660B), size: 20),
                        tooltip: 'Actualiser la position GPS',
                        onPressed: _isLocating ? null : _autoLocateEnquete,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'La ville est requise';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _quartierCodeController, 
                      label: 'Commune', 
                      icon: Icons.map,
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'La commune est requise';
                        return null;
                      },
                    ),

                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE1660B), Color(0xFFFF9800)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE1660B).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveEnquete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isSaving 
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_rounded, color: Colors.white),
                              SizedBox(width: 8),
                              Text('ENREGISTRER L\'ENQUÊTE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.1)),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    bool readOnly = false,
    Color? fillColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? Colors.white,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFFE1660B)),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE1660B), width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        validator: validator ?? ((value) => value!.isEmpty ? 'Ce champ est requis' : null),
      ),
    );
  }
}
