import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/pap.dart';
import '../models/document.dart';
import '../services/database_helper.dart';
import '../services/ocr_service.dart';

class PapStepperScreen extends StatefulWidget {
  final String idEnquete;
  const PapStepperScreen({super.key, required this.idEnquete});

  @override
  State<PapStepperScreen> createState() => _PapStepperScreenState();
}

class _PapStepperScreenState extends State<PapStepperScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();
  final OcrService _ocrService = OcrService();

  int _currentStep = 0;
  bool _isSaving = false;
  bool _isScanning = false;

  // Controllers
  final _nomController = TextEditingController();
  final _identifiantPapController = TextEditingController();
  final _numPieceController = TextEditingController();
  DateTime? _dateNaissance;

  // Photos
  File? _photoPap;
  File? _photoPieceRecto;
  File? _photoPieceVerso;

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _scanCni() async {
    setState(() => _isScanning = true);
    try {
      final result = await _ocrService.scanCniFromCamera();
      if (result != null && mounted) {
        setState(() {
          if (result.nom != null) _nomController.text = "${result.nom} ${result.prenoms ?? ''}".trim();
          if (result.numeroPiece != null) _numPieceController.text = result.numeroPiece!;
          if (result.dateNaissance != null) {
            try {
              final parts = result.dateNaissance!.split('/');
              _dateNaissance = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
            } catch (_) {}
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Données extraites avec succès!')));
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (image != null) {
      setState(() {
        if (type == 'PAP') _photoPap = File(image.path);
        else if (type == 'RECTO') _photoPieceRecto = File(image.path);
        else if (type == 'VERSO') _photoPieceVerso = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateNaissance = picked);
    }
  }

  Future<void> _savePap() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final papId = _identifiantPapController.text.trim();
      final newPap = Pap(
        identifiantPap: papId,
        idEnquete: widget.idEnquete,
        nomPap: _nomController.text.trim(),
        numPiece: _numPieceController.text.trim(),
        dateNaissance: _dateNaissance,
      );

      await _dbHelper.insertPap(newPap);

      // Save photos
      if (_photoPap != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PHOTO_PAP', cheminFichier: _photoPap!.path));
      }
      if (_photoPieceRecto != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PIECE_RECTO', cheminFichier: _photoPieceRecto!.path));
      }
      if (_photoPieceVerso != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PIECE_VERSO', cheminFichier: _photoPieceVerso!.path));
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identité PAP'), backgroundColor: const Color(0xFFF77F00)),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) setState(() => _currentStep += 1);
            else _savePap();
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep -= 1);
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _isSaving ? null : details.onStepContinue,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009E60)),
                    child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : Text(_currentStep == 2 ? 'ENREGISTRER' : 'SUIVANT', style: const TextStyle(color: Colors.white)),
                  ),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('RETOUR', style: TextStyle(color: Colors.grey)),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Informations Générales'),
              isActive: _currentStep >= 0,
              content: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isScanning ? null : _scanCni,
                    icon: _isScanning ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.document_scanner),
                    label: const Text('SCANNER LA CNI (Auto-Remplissage)'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _identifiantPapController,
                    decoration: const InputDecoration(labelText: 'Identifiant PAP (Ex: PAP-001)', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(labelText: 'Nom Complet', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Détails & Date de naissance'),
              isActive: _currentStep >= 1,
              content: Column(
                children: [
                  TextFormField(
                    controller: _numPieceController,
                    decoration: const InputDecoration(labelText: 'Numéro de Pièce (CNI)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(_dateNaissance != null ? DateFormat('dd/MM/yyyy').format(_dateNaissance!) : 'Sélectionner une date'),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                    onTap: _selectDate,
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Photos (Caméra)'),
              isActive: _currentStep >= 2,
              content: Column(
                children: [
                  _buildPhotoTile('Photo du PAP', 'PAP', _photoPap),
                  const SizedBox(height: 10),
                  _buildPhotoTile('Pièce Identité (Recto)', 'RECTO', _photoPieceRecto),
                  const SizedBox(height: 10),
                  _buildPhotoTile('Pièce Identité (Verso)', 'VERSO', _photoPieceVerso),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTile(String title, String type, File? file) {
    return ListTile(
      leading: file != null ? Image.file(file, width: 50, height: 50, fit: BoxFit.cover) : const Icon(Icons.camera_alt, size: 40),
      title: Text(title),
      subtitle: Text(file != null ? 'Photo capturée' : 'Appuyez pour prendre une photo'),
      trailing: IconButton(
        icon: const Icon(Icons.add_a_photo, color: Color(0xFF009E60)),
        onPressed: () => _pickImage(type),
      ),
    );
  }
}
