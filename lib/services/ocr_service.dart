import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrResult {
  final String? nom;
  final String? prenoms;
  final String? dateNaissance;
  final String? numeroPiece;
  final String? sexe;
  final String? nationalite;
  final String? imagePath;

  OcrResult({this.nom, this.prenoms, this.dateNaissance, this.numeroPiece, this.sexe, this.nationalite, this.imagePath});
}

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final ImagePicker _picker = ImagePicker();

  Future<OcrResult?> scanCni({ImageSource source = ImageSource.camera}) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return null;

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      final result = _parseTextForCni(recognizedText.text);
      return OcrResult(
        nom: result.nom,
        prenoms: result.prenoms,
        dateNaissance: result.dateNaissance,
        numeroPiece: result.numeroPiece,
        sexe: result.sexe,
        nationalite: result.nationalite,
        imagePath: image.path,
      );
    } catch (e) {
      print("Erreur OCR: $e");
      return null;
    }
  }

  OcrResult _parseTextForCni(String fullText) {
    String? nom;
    String? prenoms;
    String? dateNaissance;
    String? numeroPiece;
    String? sexe;
    String? nationalite;

    List<String> lines = fullText.split('\n');

    final dateRegExp = RegExp(r'\b\d{2}/\d{2}/\d{4}\b');
    
    // Pour tout type de numéro de pièce (mix de lettres et chiffres, 7 à 15 caractères)
    final genericNumRegExp = RegExp(r'\b[A-Z0-9]{7,15}\b');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim().toUpperCase();

      // Extraction Date de Naissance
      if (dateNaissance == null && dateRegExp.hasMatch(line)) {
        dateNaissance = dateRegExp.firstMatch(line)?.group(0);
      }

      // Extraction Numéro CNI
      if (numeroPiece == null) {
        // Exclure des mots communs qui font entre 7 et 15 caractères
        if (genericNumRegExp.hasMatch(line) && !line.contains('REPUBLIQUE') && !line.contains('NATIONALE') && !line.contains('PRENOMS') && !line.contains('IVOIRIEN')) {
          // Si la ligne contient le mot NUMERO, on prend le token suivant ou on cherche
          String cleanedLine = line.replaceAll(RegExp(r'[^A-Z0-9 ]'), '');
          var tokens = cleanedLine.split(' ');
          for (var t in tokens) {
            if (t.length >= 7 && t.length <= 15 && RegExp(r'[0-9]').hasMatch(t)) {
              numeroPiece = t;
              break;
            }
          }
        }
      }

      // Extraction Nom / Prénoms (plus robuste)
      if (nom == null && line.contains('NOM')) {
        String restOfLine = line.replaceAll(RegExp(r'^.*?NOM[\s:;]*'), '').trim();
        if (restOfLine.isNotEmpty && restOfLine != 'S') {
          nom = restOfLine;
        } else if (i + 1 < lines.length) {
          nom = lines[i + 1].trim();
        }
      }
      
      if (prenoms == null && line.contains('PRENOM')) {
        String restOfLine = line.replaceAll(RegExp(r'^.*?PRENOM[S]?[\s:;]*'), '').trim();
        if (restOfLine.isNotEmpty) {
          prenoms = restOfLine;
        } else if (i + 1 < lines.length) {
          prenoms = lines[i + 1].trim();
        }
      }
      
      // Extraction Sexe
      if (sexe == null) {
        if (line.contains('SEXE M') || line.contains('SEXE:M') || line == 'M' || line.endsWith(' M')) {
          sexe = 'Homme';
        } else if (line.contains('SEXE F') || line.contains('SEXE:F') || line == 'F' || line.endsWith(' F')) {
          sexe = 'Femme';
        }
      }

      // Extraction Nationalité
      if (nationalite == null) {
        if (line.contains('CIV') || line.contains("COTE D'IVOIRE") || line.contains("CÔTE D'IVOIRE") || line.contains('IVOIRIEN')) {
          nationalite = 'Ivoirien';
        }
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

  void dispose() {
    _textRecognizer.close();
  }
}
