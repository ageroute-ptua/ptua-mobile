import 'package:flutter/material.dart';
import '../widgets/photo_gallery_viewer.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/premium_single_select.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  final _prenomController = TextEditingController();
  final _surnomController = TextEditingController();
  final _identifiantPapController = TextEditingController();
  final _numPieceController = TextEditingController();
  final _lieuResidenceController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _telephone2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _nomPrenomPersContacterController = TextEditingController();
  final _telephonePersContacterController = TextEditingController();
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
  String? _religion;
  String? _appCulture;
  int? _anneeInst;

  final List<String> _statutsBien = [
    'Propriétaire (Foncier/Bâti avec Titre)',
    'Propriétaire (Terres Coutumières)',
    'Opérateur Economique (Activité)',
    'Locataire / Autre'
  ];

  // Photos
  List<File> _photosPap = [];
  List<File> _photosPieceRecto = [];
  List<File> _photosPieceVerso = [];
  List<File> _photosBati = [];
  List<File> _photosACD = [];
  List<File> _photosAttestation = [];
  List<File> _photosAutorisation = [];
  List<File> _photosAutreDoc = [];

  final List<String> _ethnies = ['Bakwé', 'Bété', 'Kouya', 'Kouzié', 'Baoulé', 'Agni', 'Abron', 'Guéré', 'Yacouba', 'Malinké', 'Sénoufo', 'Kroumen', 'Gouro', 'Abbey', 'Attié', 'Ebrié', 'Abouré', 'Godié', 'Adjoukrou', 'Alladjan', 'Ahizi', 'Abidji', 'Agouri', 'Dida', 'M\'batto', 'Koul ango', 'Lobi', 'Wan', 'Naturalisé', 'Autre'];
  final List<String> _nationalites = ['Ivoirien', 'Burkinabé', 'Malien', 'Nigérien', 'Libérien', 'Guinéen', 'Togolais', 'Bissau-guinéen', 'Mauritanien', 'Béninois', 'Ghanéen', 'Nigérian', 'Sierra-Léonais', 'Gambien', 'Sénégalais', 'Cap-verdien', 'Américain', 'Autre africain', 'Asiatique', 'Européen', 'Autre'];
  final List<String> _niveaux = ['Non scolarisé', 'Primaire', 'Secondaire', 'Supérieur', 'Coranique', 'Ne sais pas/ne souhaite pas répondre'];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.papToEdit != null;
    if (_isEditing) {
      if (widget.papToEdit!.photoPap != null) _photosPap = widget.papToEdit!.photoPap!.split(',').map((p) => File(p)).toList();
      if (widget.papToEdit!.photoPieceRecto != null) _photosPieceRecto = widget.papToEdit!.photoPieceRecto!.split(',').map((p) => File(p)).toList();
      if (widget.papToEdit!.photoPieceVerso != null) _photosPieceVerso = widget.papToEdit!.photoPieceVerso!.split(',').map((p) => File(p)).toList();
      _nomController.text = widget.papToEdit!.nomPap;
      _prenomController.text = widget.papToEdit!.prenomPap ?? '';
      _surnomController.text = widget.papToEdit!.surnom ?? '';
      _identifiantPapController.text = widget.papToEdit!.identifiantPap ?? '';
      _numPieceController.text = widget.papToEdit!.numPiece ?? '';
      _lieuResidenceController.text = widget.papToEdit!.lieuResidenceAct ?? '';
      _telephoneController.text = widget.papToEdit!.telephone1 ?? '';
      _telephone2Controller.text = widget.papToEdit!.telephone2 ?? '';
      _emailController.text = widget.papToEdit!.email ?? '';
      _nomPrenomPersContacterController.text = widget.papToEdit!.nomPrenomPersContacter ?? '';
      _telephonePersContacterController.text = widget.papToEdit!.telephonePersContacter ?? '';
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
      _religion = widget.papToEdit!.religion;
      _appCulture = widget.papToEdit!.appCulture;
      _anneeInst = widget.papToEdit!.anneeInst;
      _loadExistingLocalisation();
    } else {
      _generateIdPap();
      _autoLocate();
    }
  }

  Future<void> _generateIdPap() async {
    final allPaps = await _dbHelper.getPaps();
    int maxId = 0;
    for (var p in allPaps) {
      if (p.id != null && p.id! > maxId) maxId = p.id!;
    }
    final newIdStr = (maxId + 1).toString().padLeft(3, '0');
    if (mounted) {
      setState(() {
        _identifiantPapController.text = 'PAP_$newIdStr';
      });
    }
  }

  @override
  void dispose() {
    _ocrService.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _surnomController.dispose();
    _identifiantPapController.dispose();
    _numPieceController.dispose();
    _lieuResidenceController.dispose();
    _telephoneController.dispose();
    _telephone2Controller.dispose();
    _emailController.dispose();
    _nomPrenomPersContacterController.dispose();
    _telephonePersContacterController.dispose();
    _nomProprioController.dispose();
    _motifInstallController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingLocalisation() async {
    if (widget.papToEdit?.identifiantPap != null) {
      final loc = await _dbHelper.getLocalisationByPap(widget.papToEdit!.identifiantPap!);
      if (loc != null && loc.latitude != null && loc.longitude != null && mounted) {
        setState(() {
          _currentPosition = Position(
            latitude: loc.latitude!,
            longitude: loc.longitude!,
            timestamp: loc.createdAt ?? DateTime.now(),
            accuracy: loc.precisionGps ?? 0.0,
            altitude: loc.altitude ?? 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );
        });
      }
    }
  }

  Future<void> _autoLocate() async {
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
      final result = await _ocrService.scanCniWithGemini(source: source);
      if (result != null && mounted) {
        // Afficher le texte brut reconnu pour debug (à retirer en production)
        if (result.rawText != null && result.rawText!.isNotEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Row(children: [Icon(Icons.document_scanner, color: Color(0xFFE1660B)), SizedBox(width: 8), Text('Texte OCR Reconnu', style: TextStyle(fontSize: 16))]),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Texte brut lu par la caméra :', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                      child: Text(result.rawText!, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const Text('Champs extraits :', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE1660B), fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('NOM: ${result.nom ?? "Non trouvé"}'),
                    Text('PRÉNOMS: ${result.prenoms ?? "Non trouvé"}'),
                    Text('DATE NAISS.: ${result.dateNaissance ?? "Non trouvé"}'),
                    Text('N° PIÈCE: ${result.numeroPiece ?? "Non trouvé"}'),
                    Text('SEXE: ${result.sexe ?? "Non trouvé"}'),
                  ],
                ),
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fermer & Appliquer', style: TextStyle(color: Color(0xFFE1660B))))],
            ),
          );
        }
        int fieldsFound = 0;
        setState(() {
          // Nom de famille (champ NOM)
          if (result.nom != null && result.nom!.isNotEmpty) {
            _nomController.text = result.nom!;
            fieldsFound++;
          }
          // Prénoms (champ PRENOMS séparé)
          if (result.prenoms != null && result.prenoms!.isNotEmpty) {
            _prenomController.text = result.prenoms!;
            fieldsFound++;
          }
          // Numéro de pièce
          if (result.numeroPiece != null && result.numeroPiece!.isNotEmpty) {
            _numPieceController.text = result.numeroPiece!;
            fieldsFound++;
          }
          // Sexe
          if (result.sexe != null) {
            _sexe = result.sexe;
            fieldsFound++;
          }
          // Nationalité (MRZ renvoie souvent CIV ou FRA)
          if (result.nationalite != null) {
            final nat = result.nationalite!.toUpperCase();
            if (nat.contains('CIV') || nat.contains('IVOIR')) {
              _nationalite = 'Ivoirien';
            } else {
              _nationalite = 'Autre';
            }
            if (_nationalite != 'Ivoirien') _ethnie = null;
            fieldsFound++;
          }
          // Date de naissance
          if (result.dateNaissance != null) {
            try {
              final parts = result.dateNaissance!.split('/');
              _dateNaissance = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
              fieldsFound++;
            } catch (_) {}
          }
          // Photo
          if (result.imagePath != null) {
            if (isVerso) {
              _photosPieceVerso.add(File(result.imagePath!));
            } else {
              _photosPieceRecto.add(File(result.imagePath!));
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
        if (type == 'PAP') _photosPap.add(File(image.path));
        else if (type == 'RECTO') _photosPieceRecto.add(File(image.path));
        else if (type == 'VERSO') _photosPieceVerso.add(File(image.path));
        else if (type == 'BATI') _photosBati.add(File(image.path));
        else if (type == 'ACD') _photosACD.add(File(image.path));
        else if (type == 'ATTESTATION_VILLAGEOISE' || type == 'ATTESTATION') _photosAttestation.add(File(image.path));
        else if (type == 'AUTORISATION') _photosAutorisation.add(File(image.path));
        else if (type == 'AUTRE') _photosAutreDoc.add(File(image.path));
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
        prenomPap: _prenomController.text.trim(),
        surnom: _surnomController.text.trim(),
        typePiece: _typePiece,
        numPiece: _numPieceController.text.trim(),
        dateNaissance: _dateNaissance,
        genre: _sexe,
        nationalite: _nationalite,
        ethnie: _ethnie,
        niveauInstruc: _niveauInstruc,
        situationMat: _situationMat,
        religion: _religion,
        appCulture: _appCulture,
        anneeInst: _anneeInst,
        motifInstall: _motifInstallController.text.trim(),
        telephone1: _telephoneController.text.trim(),
        telephone2: _telephone2Controller.text.trim(),
        email: _emailController.text.trim(),
        nomPrenomPersContacter: _nomPrenomPersContacterController.text.trim(),
        telephonePersContacter: _telephonePersContacterController.text.trim(),
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
      if (_currentPosition == null) {
        try {
          _currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high, 
              timeLimit: const Duration(seconds: 5));
        } catch (_) {}
      }

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
      if (_photosPap.isNotEmpty) { for (var file in _photosPap) { await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PHOTO_PAP', cheminFichier: file.path)); } }
      if (_photosBati.isNotEmpty) {
        for (var file in _photosBati) {
          await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PHOTO_BATI', cheminFichier: file.path));
        }
      }
      if (_photosPieceRecto.isNotEmpty) { for (var file in _photosPieceRecto) { await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PIECE_RECTO', cheminFichier: file.path)); } }
      if (_photosPieceVerso.isNotEmpty) { for (var file in _photosPieceVerso) { await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'PIECE_VERSO', cheminFichier: file.path)); } }
      if (_photosACD.isNotEmpty) { for (var file in _photosACD) { await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'ACD', cheminFichier: file.path)); } }
      if (_photosAttestation.isNotEmpty) { for (var file in _photosAttestation) { await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'ATTESTATION_VILLAGEOISE', cheminFichier: file.path)); } }
      if (_photosAutorisation.isNotEmpty) { for (var file in _photosAutorisation) { await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'AUTORISATION_EXPLOITATION', cheminFichier: file.path)); } }
      if (_photosAutreDoc.isNotEmpty) { for (var file in _photosAutreDoc) { await _dbHelper.insertDocument(Document(idPap: papId, codeTypeDoc: 'AUTRE_DOC', cheminFichier: file.path)); } }

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

  Widget _buildStepIndicator() {
    return Container(
      color: const Color(0xFFF7F8FA),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 2, child: _buildStepDot(0, Icons.badge_outlined, 'Identité')),
          _buildStepLine(0),
          Expanded(flex: 2, child: _buildStepDot(1, Icons.info_outline, 'Détails')),
          _buildStepLine(1),
          Expanded(flex: 2, child: _buildStepDot(2, Icons.camera_alt_outlined, 'Photos')),
        ],
      ),
    );
  }

  Widget _buildStepLine(int stepIndex) {
    bool isActive = _currentStep > stepIndex;
    return Expanded(
      child: Container(
        height: 3,
        color: isActive ? const Color(0xFFE1660B) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildStepDot(int stepIndex, IconData icon, String label) {
    bool isActive = _currentStep >= stepIndex;
    bool isCompleted = _currentStep > stepIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE1660B) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? const Color(0xFFE1660B) : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isActive ? [
              BoxShadow(
                color: const Color(0xFFE1660B).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : [],
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive ? Colors.white : Colors.grey.shade400,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF1E224A) : Colors.grey.shade500,
          ),
        )
      ],
    );
  }

    
  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E224A))),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Identité PAP', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E224A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_currentPosition != null)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.location_on, color: Color(0xFFE1660B), size: 24),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: Form(
              key: _formKey,
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep -= 1),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text('RETOUR', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep += 1);
                    } else {
                      if (_formKey.currentState!.validate()) _savePap();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFFE1660B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isSaving 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(_currentStep == 2 ? 'ENREGISTRER' : 'SUIVANT', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          _buildSectionCard(
            title: 'Scan Pièce d\'Identité',
            children: [
              const Text('Scannez la pièce pour remplir automatiquement les champs.', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FittedBox(fit: BoxFit.scaleDown, child: ElevatedButton.icon(
                      onPressed: _isScanning ? null : () => _scanCni(ImageSource.camera),
                      icon: _isScanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.document_scanner),
                      label: const Text('RECTO'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E224A), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FittedBox(fit: BoxFit.scaleDown, child: ElevatedButton.icon(
                      onPressed: _isScanning ? null : () => _scanCni(ImageSource.camera, isVerso: true),
                      icon: _isScanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.qr_code_scanner),
                      label: const Text('VERSO'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A2E5D), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),),
                    ),
                  ),
                ],
              ),
              if (_photosPieceRecto.isNotEmpty || _photosPieceVerso.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (_photosPieceRecto.isNotEmpty) const Expanded(child: Text('✅ Recto lu', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold))),
                    if (_photosPieceVerso.isNotEmpty) const Expanded(child: Text('✅ Verso lu', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ],
          ),
          _buildSectionCard(
            title: 'Informations Générales',
            children: [
              TextFormField(
                controller: _identifiantPapController,
                decoration: const InputDecoration(labelText: 'Identifiant PAP (Ex: PAP_001)', prefixIcon: Icon(Icons.badge)),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom', prefixIcon: Icon(Icons.person)),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _surnomController,
                decoration: const InputDecoration(labelText: 'Surnom (Facultatif)', prefixIcon: Icon(Icons.stars)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          _buildSectionCard(
            title: 'Démographie',
            children: [
              PremiumSingleSelect<String>(
                value: _typePiece,
                label: 'Type de pièce',
                icon: Icons.credit_card,
                items: ['CNI', 'Passeport', 'Carte de séjour', 'Permis de conduire', 'Acte de naissance', 'Autre'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _typePiece = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numPieceController,
                decoration: const InputDecoration(labelText: 'Numéro de pièce', prefixIcon: Icon(Icons.numbers)),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                title: Text(_dateNaissance != null ? DateFormat('dd/MM/yyyy').format(_dateNaissance!) : 'Date de naissance'),
                leading: const Icon(Icons.calendar_today, color: Color(0xFFE1660B)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide.none),
                tileColor: Colors.grey.shade100,
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PremiumSingleSelect<String>(
                      value: _sexe,
                      label: 'Sexe',
                      icon: Icons.wc,
                      items: ['Homme', 'Femme'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => _sexe = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PremiumSingleSelect<String>(
                      value: _nationalite,
                      label: 'Nationalité',
                      icon: Icons.public,
                      items: _nationalites.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() { _nationalite = v; if (v != 'Ivoirien') _ethnie = null; }),
                      showSearch: true,
                    ),
                  ),
                ],
              ),
              if (_nationalite == 'Ivoirien') ...[
                const SizedBox(height: 16),
                PremiumSingleSelect<String>(
                  value: _ethnie,
                  label: 'Ethnie',
                  icon: Icons.people,
                  items: _ethnies.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _ethnie = v),
                  showSearch: true,
                ),
              ],
            ],
          ),
          _buildSectionCard(
            title: 'Coordonnées',
            children: [
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Téléphone Principal', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              const Text('Contact d\'urgence', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nomPrenomPersContacterController,
                decoration: const InputDecoration(labelText: 'Nom et prénoms', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telephonePersContacterController,
                decoration: const InputDecoration(labelText: 'Téléphone urgence', prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          _buildSectionCard(
            title: 'Profil Socio-économique',
            children: [
              PremiumSingleSelect<String>(
                value: _niveauInstruc,
                label: 'Niveau d\'étude',
                icon: Icons.school,
                items: _niveaux.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _niveauInstruc = v),
              ),
              const SizedBox(height: 16),
              PremiumSingleSelect<String>(
                value: _statutBien,
                label: 'Statut vis-à-vis du bien',
                icon: Icons.gavel,
                items: _statutsBien.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _statutBien = v),
              ),
            ],
          ),
          _buildSectionCard(
            title: 'Localisation GPS',
            children: [
              TextFormField(
                controller: _lieuResidenceController,
                decoration: InputDecoration(
                  labelText: 'Lieu de résidence actuel', 
                  prefixIcon: const Icon(Icons.location_city),
                  suffixIcon: IconButton(
                    icon: _isLocating ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.my_location, color: Color(0xFFE1660B)),
                    onPressed: _isLocating ? null : _autoLocate,
                  ),
                ),
              ),
              if (_currentPosition != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF81C784)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.gps_fixed, color: Color(0xFF2E7D32), size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Coordonnées GPS capturées', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2E7D32))),
                            const SizedBox(height: 4),
                            Text('Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}\nLng: ${_currentPosition!.longitude.toStringAsFixed(6)}', style: const TextStyle(color: Color(0xFF388E3C), fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          _buildSectionCard(
            title: 'Photos Recommandées',
            children: [
              _buildPhotoTile('Photo du PAP', Icons.person, _photosPap, (s) => _pickImage('PAP', s)),
              _buildPhotoTile('Photo de l\'ACD', Icons.description, _photosACD, (s) => _pickImage('ACD', s)),
              _buildPhotoTile('Attestation Villageoise', Icons.file_present, _photosAttestation, (s) => _pickImage('ATTESTATION_VILLAGEOISE', s)),
              _buildPhotoTile('Autre Document', Icons.attachment, _photosAutreDoc, (s) => _pickImage('AUTRE', s)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTile(String title, IconData icon, List<File> photos, Function(ImageSource) onCapture) {
    bool hasPhoto = photos.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: hasPhoto ? const Color(0xFFE8F5E9) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hasPhoto ? const Color(0xFF81C784) : Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => PhotoGalleryViewer(
              title: title,
              photos: photos,
              onAddPhoto: onCapture,
              onUpdate: () {
                setState(() {}); // trigger rebuild
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: hasPhoto ? const Color(0xFF4CAF50) : const Color(0xFF1E224A), shape: BoxShape.circle),
                child: Icon(hasPhoto ? Icons.check : icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: hasPhoto ? const Color(0xFF2E7D32) : const Color(0xFF1E224A))),
                    const SizedBox(height: 4),
                    hasPhoto ? Text('${photos.length} photo(s) (Cliquez pour gérer)', style: const TextStyle(color: Color(0xFF388E3C), fontSize: 12)) : const Text('Cliquez pour prendre/gérer', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(icon: Icon(hasPhoto ? Icons.add_a_photo : Icons.camera_alt, color: const Color(0xFFE1660B)), onPressed: () => onCapture(ImageSource.camera)),
              IconButton(icon: const Icon(Icons.image, color: const Color(0xFF2A2E5D)), onPressed: () => onCapture(ImageSource.gallery)),
            ],
          ),
        ),
      ),
    );
  }
}
