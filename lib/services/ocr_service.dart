import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OcrResult {
  final String? nom;
  final String? prenoms;
  final String? dateNaissance;
  final String? numeroPiece;
  final String? sexe;
  final String? nationalite;
  final String? imagePath;
  final String? rawText;

  OcrResult({this.nom, this.prenoms, this.dateNaissance, this.numeroPiece, this.sexe, this.nationalite, this.imagePath, this.rawText});
}

class _Block {
  final String text;
  final double top;
  final double bottom;
  final double left;
  final double right;
  _Block({required this.text, required this.top, required this.bottom, required this.left, required this.right});
  double get centerX => (left + right) / 2;
  double get height => bottom - top;
}

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final ImagePicker _picker = ImagePicker();

  Future<OcrResult?> scanCni({ImageSource source = ImageSource.camera}) {
    return scanCniWithRaw(source: source);
  }

  Future<OcrResult?> scanCniWithRaw({ImageSource source = ImageSource.camera}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (image == null) return null;

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      final result = _parseCni(recognizedText);
      return OcrResult(
        nom: result.nom,
        prenoms: result.prenoms,
        dateNaissance: result.dateNaissance,
        numeroPiece: result.numeroPiece,
        sexe: result.sexe,
        nationalite: result.nationalite,
        imagePath: image.path,
        rawText: recognizedText.text,
      );
    } catch (e) {
      print("Erreur OCR: $e");
      return null;
    }
  }

  // Remplacez par votre vraie clé API Gemini (Google AI Studio)
  static String get GEMINI_API_KEY => dotenv.env['GEMINI_API_KEY'] ?? "";

  Future<OcrResult?> scanCniWithGemini({ImageSource source = ImageSource.camera}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
        maxHeight: 1600,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (image == null) return null;

      if (GEMINI_API_KEY == "VOTRE_CLE_API_GEMINI_ICI") {
        print("Erreur: Clé API Gemini manquante.");
        return OcrResult(
          nom: "ERREUR_API_KEY", 
          prenoms: "Veuillez insérer la clé API dans ocr_service.dart",
          imagePath: image.path
        );
      }

      GenerativeModel model = GenerativeModel(
        model: 'gemini-flash-latest',
        apiKey: GEMINI_API_KEY,
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      final imageBytes = await image.readAsBytes();
      final prompt = TextPart('''
Extrais les informations de cette pièce d'identité et renvoie un objet JSON strict avec EXACTEMENT les clés suivantes :
{
  "nom": "Nom de famille",
  "prenoms": "Prénoms complets",
  "numeroPiece": "Numéro de pièce (ex: CI000000000)",
  "sexe": "Homme" ou "Femme",
  "nationalite": "Ivoirien" (si c'est écrit IVOIRIENNE ou CIV),
  "dateNaissance": "jj/mm/aaaa"
}
Si une information est illisible ou manquante, mets null.
''');
      
      final imagePart = DataPart('image/jpeg', imageBytes);

      GenerateContentResponse? response;
      int retryCount = 0;
      while (retryCount < 3) {
        try {
          response = await model.generateContent([
            Content.multi([prompt, imagePart])
          ]);
          break; // Success
        } catch (e) {
          retryCount++;
          print("Tentative $retryCount échouée: $e");
          if (retryCount >= 3) {
            // Last try with alternative model
            model = GenerativeModel(
              model: 'gemini-2.5-flash',
              apiKey: GEMINI_API_KEY,
            );
            response = await model.generateContent([
              Content.multi([prompt, imagePart])
            ]);
          } else {
            await Future.delayed(Duration(seconds: 2)); // Wait before retry
          }
        }
      }

      if (response != null && response.text != null) {
        try {
          // Sometimes Gemini wraps JSON in ```json ... ```
          String raw = response.text!.trim();
          if (raw.startsWith('```json')) {
            raw = raw.replaceAll('```json', '').replaceAll('```', '').trim();
          } else if (raw.startsWith('```')) {
            raw = raw.replaceAll('```', '').trim();
          }

          final Map<String, dynamic> data = jsonDecode(raw);
          return OcrResult(
            nom: data['nom']?.toString(),
            prenoms: data['prenoms']?.toString(),
            numeroPiece: data['numeroPiece']?.toString(),
            sexe: data['sexe']?.toString(),
            nationalite: data['nationalite']?.toString(),
            dateNaissance: data['dateNaissance']?.toString(),
            imagePath: image.path,
            rawText: response.text, 
          );
        } catch (parseError) {
          return OcrResult(nom: "ERREUR DE LECTURE", prenoms: "Le format renvoyé par l'IA n'est pas correct", rawText: response!.text);
        }
      }
      return null;
    } catch (e) {
      print("Erreur Gemini OCR: $e");
      return OcrResult(nom: "ERREUR RESEAU/API", prenoms: e.toString());
    }
  }

OcrResult _parseCni(RecognizedText recognizedText) {
    String? nom;
    String? prenoms;
    String? dateNaissance;
    String? numeroPiece;
    String? sexe;
    String? nationalite;

    // 1. Collecter tous les blocs triés par position Y (haut → bas)
    final List<_Block> blocks = [];
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final text = line.text.trim();
        if (text.isEmpty) continue;
        blocks.add(_Block(
          text: text,
          top: line.boundingBox.top.toDouble(),
          bottom: line.boundingBox.bottom.toDouble(),
          left: line.boundingBox.left.toDouble(),
          right: line.boundingBox.right.toDouble(),
        ));
      }
    }
    blocks.sort((a, b) => a.top.compareTo(b.top));

    final dateRegex = RegExp(r'\b(\d{2})[/.\-](\d{2})[/.\-](\d{4})\b');
    final numRegex = RegExp(r'\b(CI\d{9,10}|[A-Z]\d{8,10})\b');

    // ----------------------------------------------------------------
    // 2. TENTATIVE MRZ (VERSO) - PARSEUR OFFICIEL MRZ
    // ----------------------------------------------------------------
    final mrzLines = <String>[];
    for (final block in blocks) {
      for (final line in block.text.split('\n')) {
        final cleanLine = line.replaceAll(RegExp(r'\s+'), '').toUpperCase();
        // Une ligne MRZ contient souvent des '<', ne contient pas d'espaces (nettoyé), 
        // et a une longueur standard (30, 36, ou 44)
        if (cleanLine.contains('<') && cleanLine.length >= 28 && cleanLine.length <= 44) {
          mrzLines.add(cleanLine);
        }
      }
    }

    if (mrzLines.isNotEmpty) {
      try {
        final mrzResult = MRZParser.parse(mrzLines);
        nom = _toTitleCase(mrzResult.surnames);
        prenoms = _toTitleCase(mrzResult.givenNames);
        numeroPiece = mrzResult.documentNumber;
        
        final sexStr = mrzResult.sex.toString().toLowerCase();
        if (sexStr.contains('f')) {
           sexe = 'Femme';
        } else if (sexStr.contains('m')) {
           sexe = 'Homme';
        }
        
        nationalite = mrzResult.nationalityCountryCode;
        try {
          dateNaissance = DateFormat('dd/MM/yyyy').format(mrzResult.birthDate);
        } catch(_) {}
        
        print("MRZ Parser SUCCESS! Nom: $nom, Pre: $prenoms, Doc: $numeroPiece");
        // Si le MRZ réussit, on peut même retourner directement car c'est la source la plus fiable.
        if (nom != null && nom.isNotEmpty && numeroPiece != null && numeroPiece.isNotEmpty) {
           return OcrResult(
             nom: nom,
             prenoms: prenoms,
             dateNaissance: dateNaissance,
             numeroPiece: numeroPiece,
             sexe: sexe,
             nationalite: nationalite
           );
        }
      } catch (e) {
        print("MRZ Parser a échoué (souvent à cause d'un chiffre mal lu par l'OCR). Fallback sur le texte brut. Erreur: $e");
      }
    }

    // ----------------------------------------------------------------
    // 3. LECTURE RECTO : labels connus (case-insensitive)
    //    Sur la CNI ivoirienne (photo 1) le layout est :
    //      - Libellé sur une ligne, valeur sur la ligne suivante (Nom, Prénom(s), Date...)
    //      - OU libellé + valeur inline (Sexe M, Nationalité IVOIRIENNE, N° CI...)
    // ----------------------------------------------------------------
    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final text = block.text;
      final upper = text.toUpperCase().trim();

      // --- N° (numéro de pièce, toujours inline) ---
      if (numeroPiece == null) {
        final numMatch = numRegex.firstMatch(text);
        if (numMatch != null) {
          numeroPiece = numMatch.group(1);
        }
      }

      // --- Date (inline ou ligne suivante) ---
      if (dateNaissance == null) {
        final m = dateRegex.firstMatch(text);
        if (m != null && !upper.contains('EXPIR') && !upper.contains('EMISS')) {
          dateNaissance = '${m.group(1)}/${m.group(2)}/${m.group(3)}';
        }
      }

      // --- Sexe (inline: "Sexe M" ou "SEXE: M") ---
      if (sexe == null && (upper.startsWith('SEXE') || upper.startsWith('SEX '))) {
        if (upper.contains(' M') || upper.endsWith(' M') || upper.contains(':M') || upper.contains(' MASCULIN')) {
          sexe = 'Homme';
        } else if (upper.contains(' F') || upper.endsWith(' F') || upper.contains(':F') || upper.contains(' FEMININ')) {
          sexe = 'Femme';
        } else if (i + 1 < blocks.length) {
          final next = blocks[i + 1].text.trim().toUpperCase();
          if (next == 'M' || next == 'MASCULIN') sexe = 'Homme';
          if (next == 'F' || next == 'FEMININ') sexe = 'Femme';
        }
      }

      // --- Nationalité (inline: "Nationalité IVOIRIENNE") ---
      if (nationalite == null && (upper.startsWith('NATIONAL') || upper == 'NATIONALITE' || upper == 'NATIONALITY')) {
        final rest = text.replaceAll(RegExp(r'^(Nationalit[eé]|Nationality)\s*:?\s*', caseSensitive: false), '').trim();
        if (rest.isNotEmpty) {
          final v = rest.toUpperCase();
          if (v.contains('IVOIR') || v.contains('CIV')) nationalite = 'Ivoirien';
          else nationalite = _toTitleCase(rest);
        } else if (i + 1 < blocks.length) {
          final next = blocks[i + 1].text.trim().toUpperCase();
          if (next.contains('IVOIR') || next.contains('CIV')) nationalite = 'Ivoirien';
          else nationalite = _toTitleCase(blocks[i + 1].text.trim());
        }
      }
      // Inline fallback: le mot IVOIRIENNE seul
      if (nationalite == null && (upper == 'IVOIRIENNE' || upper == 'IVOIRIEN')) {
        nationalite = 'Ivoirien';
      }

      // --- NOM (libellé seul sur la ligne, valeur en dessous) ---
      // NE PAS matcher "Prénom" qui contient "nom" aussi !
      if (nom == null) {
        final isNomLabel = upper == 'NOM' ||
            upper == 'NOM:' ||
            upper == 'SURNAME' ||
            upper.startsWith('NOM ') ||
            (upper.startsWith('NOM:') && upper.length < 8);

        if (isNomLabel) {
          // Inline : "Nom NGUESSAN"
          final inline = text.replaceAll(RegExp(r'^(Nom|NOM|Surname|SURNAME)\s*:?\s*', caseSensitive: false), '').trim();
          if (inline.isNotEmpty && !_isLikelyLabel(inline)) {
            nom = _toTitleCase(_cleanName(inline));
          } else {
            // Valeur en dessous : chercher spatially
            final below = _findBlockBelow(block, blocks, i);
            if (below != null && !_isLikelyLabel(below.text)) {
              nom = _toTitleCase(_cleanName(below.text));
            }
          }
        }
      }

      // --- PRÉNOM(S) (libellé seul sur la ligne, valeur en dessous) ---
      if (prenoms == null) {
        final isPrenomLabel = upper == 'PRENOM' ||
            upper == 'PRENOMS' ||
            upper == 'PRÉNOM' ||
            upper == 'PRÉNOMS' ||
            upper == 'PRENOM(S)' ||
            upper == 'PRÉNOM(S)' ||
            upper == 'GIVEN NAMES' ||
            upper == 'GIVEN NAME' ||
            upper == 'FIRST NAME' ||
            upper.startsWith('PRENOM(S)') ||
            upper.startsWith('PRÉNOM(S)');

        if (isPrenomLabel) {
          final inline = text.replaceAll(
            RegExp(r'^(Prénoms?|Prenoms?|Given Names?|First Name)\s*[\(S\)]?\s*:?\s*', caseSensitive: false), '').trim();
          if (inline.isNotEmpty && !_isLikelyLabel(inline)) {
            prenoms = _toTitleCase(_cleanName(inline));
          } else {
            final below = _findBlockBelow(block, blocks, i);
            if (below != null && !_isLikelyLabel(below.text)) {
              prenoms = _toTitleCase(_cleanName(below.text));
            }
          }
        }
      }
    }

    // ----------------------------------------------------------------
    // 4. Fallbacks globaux si rien trouvé encore
    // ----------------------------------------------------------------
    if (dateNaissance == null) {
      for (final b in blocks) {
        final m = dateRegex.firstMatch(b.text);
        if (m != null && !b.text.toUpperCase().contains('EXPIR')) {
          dateNaissance = '${m.group(1)}/${m.group(2)}/${m.group(3)}';
          break;
        }
      }
    }
    if (nationalite == null) {
      for (final b in blocks) {
        final u = b.text.toUpperCase();
        if (u.contains('IVOIR')) { nationalite = 'Ivoirien'; break; }
      }
    }

    return OcrResult(
      nom: nom,
      prenoms: prenoms,
      dateNaissance: dateNaissance,
      numeroPiece: numeroPiece,
      sexe: sexe,
      nationalite: nationalite,
    );
  }

  /// Cherche le bloc le plus proche SOUS un libellé dans la même colonne
  _Block? _findBlockBelow(_Block label, List<_Block> all, int currentIndex) {
    _Block? best;
    double bestDist = 999999;
    for (int j = currentIndex + 1; j < all.length; j++) {
      final b = all[j];
      if (b.top <= label.bottom) continue;
      // Overlap horizontal : même colonne
      final overlapLeft = [label.left, b.left].reduce((a, c) => a > c ? a : c);
      final overlapRight = [label.right, b.right].reduce((a, c) => a < c ? a : c);
      if (overlapRight - overlapLeft < 5) continue;
      final dist = b.top - label.bottom;
      if (dist < bestDist && dist < 300) {
        bestDist = dist;
        best = b;
      }
    }
    return best;
  }

  bool _isLikelyLabel(String text) {
    final u = text.toUpperCase().trim();
    final knownLabels = [
      'NOM', 'PRENOMS', 'PRENOM', 'PRÉNOM', 'PRÉNOMS', 'DATE DE NAISSANCE',
      'LIEU DE NAISSANCE', 'SEXE', 'NATIONALITE', 'NATIONALITÉ', 'TAILLE',
      'DATE D\'EXPIRATION', 'DATE D\'EMISSION', 'PROFESSION', 'SIGNATURE',
      'GIVEN NAMES', 'SURNAME', 'DATE OF BIRTH', 'SEX', 'NATIONALITY',
    ];
    return knownLabels.any((lbl) => u == lbl || u.startsWith('$lbl ') || u.startsWith('$lbl:'));
  }

  String _cleanName(String text) {
    return text.replaceAll(RegExp(r"[^a-zA-ZÀ-ÿ\s\-']"), '').trim();
  }

  String _toTitleCase(String text) {
    return text.split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');
  }

  void dispose() {
    _textRecognizer.close();
  }
}
