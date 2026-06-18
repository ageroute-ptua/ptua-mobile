import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrResult {
  final String? nom;
  final String? prenoms;
  final String? dateNaissance;
  final String? numeroPiece;

  OcrResult({this.nom, this.prenoms, this.dateNaissance, this.numeroPiece});
}

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final ImagePicker _picker = ImagePicker();

  Future<OcrResult?> scanCniFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      return _parseTextForCni(recognizedText.text);
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

    List<String> lines = fullText.split('\n');

    // Regex simples pour trouver les formats habituels
    final dateRegExp = RegExp(r'\b\d{2}/\d{2}/\d{4}\b');
    final cniNumRegExp = RegExp(r'\bC\d{9}\b'); // Exemple format Ivoirien: C012345678 ou Numéros 11 chiffres

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim().toUpperCase();

      // Extraction Date de Naissance
      if (dateNaissance == null && dateRegExp.hasMatch(line)) {
        dateNaissance = dateRegExp.firstMatch(line)?.group(0);
      }

      // Extraction Numéro CNI
      if (numeroPiece == null && (line.contains("C0") || line.contains("C1") || cniNumRegExp.hasMatch(line))) {
        numeroPiece = line.replaceAll(RegExp(r'[^A-Z0-9]'), '');
      }

      // Heuristique simplifiée pour Nom / Prénoms (dépend de la position sur la CNI Ivoirienne)
      if (line.startsWith('NOM') && i + 1 < lines.length) {
        nom = lines[i + 1].trim();
      }
      if (line.startsWith('PRENOMS') && i + 1 < lines.length) {
        prenoms = lines[i + 1].trim();
      }
    }

    return OcrResult(
      nom: nom,
      prenoms: prenoms,
      dateNaissance: dateNaissance,
      numeroPiece: numeroPiece,
    );
  }

  void dispose() {
    _textRecognizer.close();
  }
}
