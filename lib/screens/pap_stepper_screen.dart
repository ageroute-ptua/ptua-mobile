import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import '../models/pap.dart';
import '../models/document.dart';
import '../models/localisation.dart';
import '../services/database_helper.dart';
import '../services/ocr_service.dart';
import 'pap_dashboard_screen.dart';

class PapStepperScreen extends StatefulWidget {
  final String idEnquete;
  final Pap? papToEdit;
  const PapStepperScreen({super.key, required this.idEnquete, this.papToEdit});

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
  bool _isLocating = false;
  Position? _currentPosition;

  // Controllers
  final _nomController = TextEditingController();
  final _identifiantPapController = TextEditingController();
  final _numPieceController = TextEditingController();
  final _lieuResidenceController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _nomProprioController = TextEditingController();
  final _motifInstallController = TextEditingController();
  DateTime? _dateNaissance;

  // Details
  String? _sexe;
  String? _nationalite;
  String? _ethnie;
  String? _niveauInstruc;
  String? _statutBien;
  String? _typePiece;
  String? _situationMat;
  String? _appCulture;
  int? _anneeInst;

  final List<String> _statutsBien = [
    'Propriétaire (Foncier/Bâti avec Titre)',
    'Propriétaire (Terres Coutumières)',
    'Opérateur Economique (Activité)',
    'Locataire / Autre'
  ];

  // Photos
  File? _photoPap;
  File? _photoPieceRecto;
  File? _photoPieceVerso;
  List<File> _photosBati = [];
  File? _photoACD;
  File? _photoAttestation;
  File? _photoAutorisation;
  File? _photoAutreDoc;

  final List<String> _ethnies = ['Bakwé', 'Bété', 'Kouya', 'Kouzié', 'Baoulé', 'Agni', 'Abron', 'Guéré', 'Yacouba', 'Malinké', 'Sénoufo', 'Kroumen', 'Gouro', 'Abbey', 'Attié', 'Ebrié', 'Abouré', 'Godié', 'Adjoukrou', 'Alladjan', 'Ahizi', 'Abidji', 'Agouri', 'Dida', 'M\'batto', 'Koul ango', 'Lobi', 'Wan', 'Naturalisé', 'Autre'];
  final List<String> _nationalites = ['Ivoirien', 'Burkinabé', 'Malien', 'Nigérien', 'Libérien', 'Guinéen', 'Togolais', 'Bissau-guinéen', 'Mauritanien', 'Béninois', 'Ghanéen', 'Nigérian', 'Sierra-Léonais', 'Gambien', 'Sénégalais', 'Cap-verdien', 'Américain', 'Autre africain', 'Asiatique', 'Européen', 'Autre'];
  final List<String> _niveaux = ['Non scolarisé', 'Primaire', 'Secondaire', 'Supérieur', 'Coranique', 'Ne sais pas/ne souhaite pas répondre'];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.papToEdit != null;
    if (_isEditing) {
      _nomController.text = widget.papToEdit!.nomPap;
      _identifiantPapController.text = widget.papToEdit!.identifiantPap ?? '';
      _numPieceController.text = widget.papToEdit!.numPiece ?? '';
      _lieuResidenceController.text = widget.papToEdit!.lieuResidenceAct ?? '';
      _telephoneController.text = widget.papToEdit!.telephone1 ?? '';
      _nomProprioController.text = widget.papToEdit!.nomProprio ?? '';
      _motifInstallController.text = widget.papToEdit!.motifInstall ?? '';
      _dateNaissance = widget.papToEdit!.dateNaissance;
      _sexe = widget.papToEdit!.genre;
      _nationalite = widget.papToEdit!.nationalite;
      _ethnie = widget.papToEdit!.ethnie;
      _niveauInstruc = widget.papToEdit!.niveauInstruc;
      _statutBien = widget.papToEdit!.statutBien;
      _typePiece = widget.papToEdit!.typePiece;
      _situationMat = widget.papToEdit!.situationMat;
      _appCulture = widget.papToEdit!.appCulture;
      _anneeInst = widget.papToEdit!.anneeInst;
    } else {
      _autoLocate();
    }
  }

  @override
  void dispose() {
    _ocrService.dispose();
    _lieuResidenceController.dispose();
    _telephoneController.dispose();
    _nomProprioController.dispose();
    _motifInstallController.dispose();
    super.dispose();
  }

  Future<void> _autoLocate() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() => _currentPosition = position);
        
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          setState(() {
            _lieuResidenceController.text = "${place.locality ?? place.subAdministrativeArea ?? ''}, ${place.subLocality ?? place.thoroughfare ?? ''}".trim();
            if (_lieuResidenceController.text.startsWith(',')) {
              _lieuResidenceController.text = _lieuResidenceController.text.substring(1).trim();
            }
          });
        }
      }
    } catch (e) {
      // Ignore
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _scanCni(ImageSource source, {bool isVerso = false}) async {
    setState(() => _isScanning = true);
    try {
      final result = await _ocrService.scanCni(source: source);
      if (result != null && mounted) {
        int fieldsFound = 0;
        setState(() {
          // Nom (seulement si pas encore rempli ou si verso apporte plus)
          if (result.nom != null && _nomController.text.isEmpty) {
            _nomController.text = "${result.nom} ${result.prenoms ?? ''}".trim();
            fieldsFound++;
          }
          // Numéro de pièce
          if (result.numeroPiece != null && _numPieceController.text.isEmpty) {
            _numPieceController.text = result.numeroPiece!;
            fieldsFound++;
          }
          // Sexe
          if (result.sexe != null && _sexe == null) {
            _sexe = result.sexe;
            fieldsFound++;
          }
          // Nationalité
          if (result.nationalite != null && _nationalite == null) {
            _nationalite = result.nationalite;
            if (_nationalite != 'Ivoirien') _ethnie = null;
            fieldsFound++;
          }
          // Date de naissance
          if (result.dateNaissance != null && _dateNaissance == null) {
            try {
              final parts = result.dateNaissance!.split('/');
              _dateNaissance = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
              fieldsFound++;
            } catch (_) {}
          }
          // Photo
          if (result.imagePath != null) {
            if (isVerso) {
              _photoPieceVerso = File(result.imagePath!);
            } else {
              _photoPieceRecto = File(result.imagePath!);
            }
          }
        });
        
        if (fieldsFound > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('$fieldsFound champ(s) rempli(s) automatiquement !'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo enregistrée (aucun texte lisible détecté - vérifiez la netteté)'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur OCR: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _pickImage(String type, ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      setState(() {
        if (type == 'PAP') _photoPap = File(image.path);
        else if (type == 'RECTO') _photoPieceRecto = File(image.path);
        else if (type == 'VERSO') _photoPieceVerso = File(image.path);
        else if (type == 'BATI') _photosBati.add(File(image.path));
        else if (type == 'ACD') _photoACD = File(image.path);
        else if (type == 'ATTESTATION') _photoAttestation = File(image.path);
        else if (type == 'AUTORISATION') _photoAutorisation = File(image.path);
        else if (type == 'AUTRE') _photoAutreDoc = File(image.path);
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
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir les champs obligatoires (ex: Identifiant PAP, Nom Complet) à l\'étape 1.', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }
    setState(() => _isSaving = true);

    try {
      final papId = _identifiantPapController.text.trim();
      
      // Vérification que l'ID PAP n'est pas vide
      if (papId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('L\'identifiant PAP est requis (ex: PAP-001)'), backgroundColor: Colors.red),
        );
        setState(() => _isSaving = false);
        return;
      }

      final newPap = Pap(
        id: widget.papToEdit?.id,
        identifiantPap: papId,
        idEnquete: widget.idEnquete,
        nomPap: _nomController.text.trim(),
        typePiece: _typePiece,
        numPiece: _numPieceController.text.trim(),
        dateNaissance: _dateNaissance,
        genre: _sexe,
        nationalite: _nationalite,
        ethnie: _ethnie,
        niveauInstruc: _niveauInstruc,
        situationMat: _situationMat,
        appCulture: _appCulture,
        anneeInst: _anneeInst,
        motifInstall: _motifInstallController.text.trim(),
        telephone1: _telephoneController.text.trim(),
        nomProprio: _nomProprioController.text.trim(),
        lieuResidenceAct: _lieuResidenceController.text.trim(),
        statutBien: _statutBien,
        createdAt: widget.papToEdit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 'local',
      );

      if (_isEditing) {
        await _dbHelper.updatePap(newPap);
      } else {
        await _dbHelper.insertPap(newPap);
      }

      // Sauvegarde GPS (séparée pour ne pas bloquer si erreur)
      if (_currentPosition != null) {
        try {
          final loc = Localisation(
            idPap: papId,
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude,
            altitude: _currentPosition!.altitude,
            precisionGps: _currentPosition!.accuracy,
            createdAt: DateTime.now(),
          );
          await _dbHelper.insertLocalisation(loc);
        } catch (locError) {
          // GPS non bloquant
          debugPrint('GPS save error (non-blocking): $locError');
        }
      }

      // Sauvegarde photos
      if (_photoPap != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PHOTO_PAP', cheminFichier: _photoPap!.path));
      }
      if (_photosBati.isNotEmpty) {
        for (var file in _photosBati) {
          await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PHOTO_BATI', cheminFichier: file.path));
        }
      }
      if (_photoPieceRecto != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PIECE_RECTO', cheminFichier: _photoPieceRecto!.path));
      }
      if (_photoPieceVerso != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PIECE_VERSO', cheminFichier: _photoPieceVerso!.path));
      }
      if (_photoACD != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'ACD', cheminFichier: _photoACD!.path));
      }
      if (_photoAttestation != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'ATTESTATION_VILLAGEOISE', cheminFichier: _photoAttestation!.path));
      }
      if (_photoAutorisation != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'AUTORISATION_EXPLOITATION', cheminFichier: _photoAutorisation!.path));
      }
      if (_photoAutreDoc != null) {
        await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'AUTRE_DOC', cheminFichier: _photoAutreDoc!.path));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PAP enregistré avec succès !'), backgroundColor: Colors.green),
        );
        
        if (_isEditing) {
          // Si on éditait, on retourne simplement en arrière (vers le dashboard ou la liste)
          Navigator.pop(context, true);
        } else {
          // Si c'est un nouveau PAP, on va directement sur son Dashboard pour répondre aux questions
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PapDashboardScreen(pap: newPap),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = 'Erreur lors de l\'enregistrement.';
        if (e.toString().contains('UNIQUE constraint')) {
          errorMsg = 'Cet identifiant PAP existe déjà. Utilisez un ID différent (ex: PAP-002).';
        } else if (e.toString().contains('FOREIGN KEY')) {
          errorMsg = 'Erreur de liaison de données. Vérifiez que l\'enquête associée existe.';
        } else if (e.toString().contains('database')) {
          errorMsg = 'Erreur base de données. Désinstallez et réinstallez l\'application.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red, duration: const Duration(seconds: 5)),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Identité PAP'),
            const Spacer(),
            if (_currentPosition != null)
              const Icon(Icons.location_on, color: Colors.white, size: 20),
          ],
        ),
        backgroundColor: const Color(0xFFF77F00),
      ),
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
                  const Text('Pièce d\'identité (Recto) - Auto-Remplissage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueAccent)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isScanning ? null : () => _scanCni(ImageSource.camera),
                          icon: _isScanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.camera_alt, size: 18),
                          label: const FittedBox(child: Text('SCAN RECTO')),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isScanning ? null : () => _scanCni(ImageSource.gallery),
                          icon: _isScanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.photo_library, size: 18),
                          label: const FittedBox(child: Text('IMPORT RECTO')),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 4)),
                        ),
                      ),
                    ],
                  ),
                  if (_photoPieceRecto != null)
                     const Padding(
                       padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                       child: Text('✅ Recto sélectionné', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                     ),
                   const SizedBox(height: 12),
                  const Text('Pièce d\'identité (Verso) - Complétion Auto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF009E60))),
                  const Text('Le verso complète les champs manquants du recto', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isScanning ? null : () => _scanCni(ImageSource.camera, isVerso: true),
                          icon: _isScanning 
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                            : const Icon(Icons.camera_alt, size: 18),
                          label: const FittedBox(child: Text('SCAN VERSO')),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009E60), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isScanning ? null : () => _scanCni(ImageSource.gallery, isVerso: true),
                          icon: _isScanning 
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                            : const Icon(Icons.photo_library, size: 18),
                          label: const FittedBox(child: Text('IMPORT VERSO')),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 4)),
                        ),
                      ),
                    ],
                  ),
                  if (_photoPieceVerso != null)
                     const Padding(
                       padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                       child: Text('✅ Verso sélectionné', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                     ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _identifiantPapController,
                    decoration: const InputDecoration(labelText: 'Identifiant PAP (Ex: PAP-001)', prefixIcon: Icon(Icons.badge)),
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(labelText: 'Nom Complet', prefixIcon: Icon(Icons.person)),
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Détails Démographiques'),
              isActive: _currentStep >= 1,
              content: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _typePiece,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Type de pièce d\'identité', prefixIcon: Icon(Icons.credit_card)),
                    items: ['CNI', 'Passeport', 'Carte de séjour', 'Permis de conduire', 'Acte de naissance', 'Autre']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => _typePiece = v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numPieceController,
                    decoration: const InputDecoration(labelText: 'Numéro de pièce', prefixIcon: Icon(Icons.credit_card)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _telephoneController,
                    decoration: const InputDecoration(labelText: 'Téléphone', prefixIcon: Icon(Icons.phone)),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(_dateNaissance != null ? DateFormat('dd/MM/yyyy').format(_dateNaissance!) : 'Date de naissance (JJ/MM/AAAA)'),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _sexe,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Sexe', prefixIcon: Icon(Icons.wc)),
                    items: ['Homme', 'Femme'].map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => _sexe = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _nationalite,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Nationalité', prefixIcon: Icon(Icons.public)),
                    items: _nationalites.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() {
                      _nationalite = v;
                      if (v != 'Ivoirien') _ethnie = null; // Clear ethnie if not Ivoirien
                    }),
                  ),
                  if (_nationalite == 'Ivoirien') ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _ethnie,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Ethnie (Si Ivoirien)', prefixIcon: Icon(Icons.people)),
                      items: _ethnies.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (v) => setState(() => _ethnie = v),
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _niveauInstruc,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Niveau d\'étude', prefixIcon: Icon(Icons.school)),
                    items: _niveaux.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => _niveauInstruc = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _situationMat,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Situation matrimoniale', prefixIcon: Icon(Icons.favorite)),
                    items: ['Célibataire', 'Marié(e) monogame', 'Marié(e) polygame', 'Divorcé(e)', 'Veuf/Veuve', 'Union libre']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => _situationMat = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _appCulture,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Appartenance culturelle', prefixIcon: Icon(Icons.diversity_3)),
                    items: ['Akan', 'Krou', 'Mandé du Nord', 'Mandé du Sud', 'Voltaïque/Gur', 'Etranger', 'Autre']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => _appCulture = v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Année d\'installation dans le lieu', prefixIcon: Icon(Icons.calendar_month)),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _anneeInst = int.tryParse(v),
                    controller: TextEditingController(text: _anneeInst?.toString() ?? ''),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _motifInstallController,
                    decoration: const InputDecoration(labelText: 'Motif d\'installation', prefixIcon: Icon(Icons.info_outline)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomProprioController,
                    decoration: const InputDecoration(labelText: 'Nom du propriétaire du terrain (si applicable)', prefixIcon: Icon(Icons.person_outline)),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _statutBien,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Statut vis-à-vis du bien affecté', prefixIcon: Icon(Icons.gavel)),
                    items: _statutsBien.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => _statutBien = v),
                  ),
                  const SizedBox(height: 16),
                  if (_isLocating)
                    const Padding(padding: EdgeInsets.only(bottom: 8), child: Row(children: [SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)), SizedBox(width: 8), Text("Recherche de la position...", style: TextStyle(color: Colors.grey, fontSize: 12))])),
                  TextFormField(
                    controller: _lieuResidenceController,
                    decoration: InputDecoration(
                      labelText: 'Lieu de résidence actuel (GPS)', 
                      prefixIcon: const Icon(Icons.location_city),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.my_location, color: Color(0xFFE1660B)),
                        tooltip: 'Rafraîchir la position',
                        onPressed: _isLocating ? null : _autoLocate,
                      ),
                    ),
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
                  _buildMultiPhotoTile('Photos du Bâti / Logement', 'BATI', _photosBati),
                  const SizedBox(height: 10),
                  if (_statutBien == 'Propriétaire (Foncier/Bâti avec Titre)') ...[
                    _buildPhotoTile('Photo de l\'ACD', 'ACD', _photoACD),
                    const SizedBox(height: 10),
                  ],
                  if (_statutBien == 'Propriétaire (Terres Coutumières)') ...[
                    _buildPhotoTile('Photo de l\'Attestation Villageoise', 'ATTESTATION', _photoAttestation),
                    const SizedBox(height: 10),
                  ],
                  if (_statutBien == 'Opérateur Economique (Activité)') ...[
                    _buildPhotoTile('Photo de l\'Autorisation d\'exploitation', 'AUTORISATION', _photoAutorisation),
                    const SizedBox(height: 10),
                  ],
                  _buildPhotoTile('Autre pièce ou document', 'AUTRE', _photoAutreDoc),
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
      leading: file != null ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(file, width: 50, height: 50, fit: BoxFit.cover)) : const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(file != null ? 'Photo sélectionnée' : 'Importez ou prenez une photo'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.photo_library, color: Color(0xFFE1660B)),
            onPressed: () => _pickImage(type, ImageSource.gallery),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Color(0xFF009E60)),
            onPressed: () => _pickImage(type, ImageSource.camera),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiPhotoTile(String title, String type, List<File> files) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.home_work, size: 40, color: Colors.grey),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('${files.length} photo(s) sélectionnée(s)'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tileColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.photo_library, color: Color(0xFFE1660B)),
                onPressed: () => _pickImage(type, ImageSource.gallery),
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Color(0xFF009E60)),
                onPressed: () => _pickImage(type, ImageSource.camera),
              ),
            ],
          ),
        ),
        if (files.isNotEmpty)
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: files.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(files[index], width: 80, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            files.removeAt(index);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
