import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../models/enquete.dart';
import '../models/localisation.dart';
import '../services/database_helper.dart';
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
  
  int _currentStep = 0;
  bool _isSaving = false;

  final _idEnqueteController = TextEditingController();
  final _communeCodeController = TextEditingController();
  final _enqueteurController = TextEditingController();

  File? _photoFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.enqueteToEdit != null) {
      _idEnqueteController.text = widget.enqueteToEdit!.idEnquete;
      _communeCodeController.text = widget.enqueteToEdit!.communeCode ?? '';
      _enqueteurController.text = widget.enqueteToEdit!.enqueteur ?? '';
      if (widget.enqueteToEdit!.photoPath != null && File(widget.enqueteToEdit!.photoPath!).existsSync()) {
        _photoFile = File(widget.enqueteToEdit!.photoPath!);
      }
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
      // 1. Demander la permission et récupérer le GPS
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position? position;
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }
      
      // 2. Traitement de la photo
      final newEnquete = Enquete(
        id: widget.enqueteToEdit?.id,
        idEnquete: _idEnqueteController.text.trim(),
        communeCode: _communeCodeController.text.trim(),
        enqueteur: _enqueteurController.text.trim(),
        dateEnquete: widget.enqueteToEdit?.dateEnquete ?? DateTime.now(),
        createdAt: widget.enqueteToEdit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 'local', // Toujours marquer comme 'local' après modification pour forcer la synchro
        photoPath: _photoFile?.path,
        signaturePath: null,
      );

      if (widget.enqueteToEdit != null) {
        await _dbHelper.updateEnquete(newEnquete);
      } else {
        await _dbHelper.insertEnquete(newEnquete);
      }

      if (position != null) {
        final loc = Localisation(
          idEnquete: newEnquete.idEnquete,
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: position.altitude,
          precisionGps: position.accuracy,
          createdAt: DateTime.now(),
        );
        await _dbHelper.insertLocalisation(loc);
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
          // Reset
          _idEnqueteController.clear();
          _communeCodeController.clear();
          _enqueteurController.clear();
          _photoFile = null;
          setState(() => _currentStep = 0);
          
          // Retour Dashboard
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

  List<Step> getSteps() {
    return [
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: const Text("Identification", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          children: [
            const SizedBox(height: 16),
            _buildTextField(
              controller: _idEnqueteController, 
              label: 'ID Enquête (Ex: ENQ-001)', 
              icon: Icons.badge,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'L\'ID de l\'enquête est requis';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _communeCodeController, 
              label: 'Code Commune (Ex: COM-1)', 
              icon: Icons.map,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Le code commune est requis';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _enqueteurController, 
              label: 'Nom de l\'enquêteur', 
              icon: Icons.person,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s\-]'))],
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Le nom de l\'enquêteur est requis';
                if (value.trim().length < 2) return 'Le nom doit faire au moins 2 caractères';
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text("Médias", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text("Photo du Bâti", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF242A5D))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _pickImage,
                        child: Center(
                          child: _photoFile != null && (_photoFile!.path.endsWith('.jpg') || _photoFile!.path.endsWith('.png') || _photoFile!.path.endsWith('.jpeg'))
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(_photoFile!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: const Color(0xFFE1660B).withValues(alpha: 0.1), shape: BoxShape.circle),
                                      child: Icon(_photoFile != null ? Icons.check_circle : Icons.camera_alt, size: 32, color: _photoFile != null ? Colors.green : const Color(0xFFE1660B)),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(_photoFile != null ? "Photo prête" : "Appareil photo", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _pickFile,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFF242A5D).withValues(alpha: 0.1), shape: BoxShape.circle),
                                child: const Icon(Icons.folder_open, size: 32, color: Color(0xFF242A5D)),
                              ),
                              const SizedBox(height: 12),
                              const Text("Importer fichier", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_photoFile != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => setState(() => _photoFile = null),
                  icon: const Icon(Icons.clear, size: 18),
                  label: const Text("Retirer le fichier"),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.enqueteToEdit != null ? 'Modifier Enquête' : 'Nouvelle Enquête', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE1660B),
        elevation: 0,
        automaticallyImplyLeading: widget.enqueteToEdit != null,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: const Color(0xFFE1660B)),
          ),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            steps: getSteps(),
            physics: const BouncingScrollPhysics(),
            onStepContinue: () {
              final isLastStep = _currentStep == getSteps().length - 1;
              
              // Validation avant de changer d'étape
              if (_currentStep == 0) {
                if (!_formKey.currentState!.validate()) {
                  return; // Bloquer si c'est invalide
                }
              }

              if (isLastStep) {
                _saveEnquete();
              } else {
                setState(() => _currentStep += 1);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            controlsBuilder: (context, details) {
              final isLastStep = _currentStep == getSteps().length - 1;
              return Container(
                margin: const EdgeInsets.only(top: 32),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE1660B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isSaving && isLastStep
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                isLastStep ? 'ENREGISTRER' : 'SUIVANT', 
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                      ),
                    ),
                    if (_currentStep > 0) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: _isSaving ? null : details.onStepCancel,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('RETOUR', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFFE1660B)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE1660B), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        validator: validator ?? ((value) => value!.isEmpty ? 'Ce champ est requis' : null),
      ),
    );
  }
}
