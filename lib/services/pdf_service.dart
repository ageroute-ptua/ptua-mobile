import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/enquete.dart';
import '../models/pap.dart';
import 'database_helper.dart';

class PdfService {
  static Future<void> generateAndPrintEnquetePdf(Enquete enquete) async {
    final pdf = pw.Document();
    final dbHelper = DatabaseHelper();
    final paps = await dbHelper.getPapsForEnquete(enquete.idEnquete);

    // Charger le logo AGEROUTE si disponible dans assets, sinon on fait sans
    pw.ImageProvider? logoImage;
    try {
      final logoData = await rootBundle.load('assets/images/ageroute_logo.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      // Pas de logo
    }

    // Charger les images (Photo Bâti et Signature)
    pw.ImageProvider? batiImage;
    if (enquete.photoPath != null && File(enquete.photoPath!).existsSync()) {
      batiImage = pw.MemoryImage(File(enquete.photoPath!).readAsBytesSync());
    }



    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            // En-tête du document
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.orange50,
                border: pw.Border.all(color: PdfColors.orange800, width: 2),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("PROJET DE TRANSPORT URBAIN D'ABIDJAN (PTUA)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, color: PdfColors.orange900)),
                        pw.SizedBox(height: 5),
                        pw.Text("FICHE DE RECENSEMENT BÂTI ET PAP", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.blue900)),
                      ],
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      if (logoImage != null) pw.Image(logoImage, width: 60),
                      pw.SizedBox(height: 5),
                      pw.Text("Date : ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Section 1: Informations de l'Enquête (Bâti)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text("1. INFORMATIONS DU BÂTI", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              data: <List<String>>[
                ['ID Enquête', enquete.idEnquete],
                ['Commune', enquete.communeCode ?? 'Non renseignée'],
                ['Quartier', enquete.quartierCode ?? 'Non renseigné'],
                ['Enquêteur', enquete.enqueteur ?? 'Non renseigné'],
              ],
            ),
            pw.SizedBox(height: 20),

            // Section 2: Personnes Affectées (PAP)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text("2. PERSONNES AFFECTÉES (PAP)", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
            ),
            pw.SizedBox(height: 10),
            if (paps.isEmpty)
              pw.Text("Aucune personne n'a été recensée pour ce bâti.", style: pw.TextStyle(color: PdfColors.grey700, fontStyle: pw.FontStyle.italic))
            else
              pw.Table.fromTextArray(
                context: context,
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(fontSize: 10),
                data: <List<String>>[
                  ['Nom complet', 'Genre', 'Âge', 'Contact', 'Vulnérable'],
                  ...paps.map((pap) => [
                    pap.nomPap,
                    pap.genre ?? 'N/A',
                    pap.dateNaissance != null ? '${DateTime.now().year - pap.dateNaissance!.year} ans' : 'N/A',
                    pap.telephone1 ?? 'N/A',
                    'NON',
                  ]),
                ],
              ),
              
            pw.SizedBox(height: 20),

            // Section 3: Médias (Photo)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text("3. PREUVES VISUELLES", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
            ),
            pw.SizedBox(height: 10),
            if (batiImage != null)
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text("Photographie du Bâti", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400, width: 2),
                      ),
                      child: pw.Image(batiImage, width: 250, height: 200, fit: pw.BoxFit.cover),
                    ),
                  ],
                ),
              )
            else
              pw.Text("Aucune photo n'a été jointe à cette enquête.", style: pw.TextStyle(color: PdfColors.grey700, fontStyle: pw.FontStyle.italic)),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Fiche_PTUA_${enquete.idEnquete}.pdf',
    );
  }
}
