import 'package:dio/dio.dart';
import '../models/document.dart';
import 'database_helper.dart';
import 'api_client.dart';

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ApiClient _apiClient = ApiClient();

  /// Pousse toutes les données locales vers le backend
  Future<bool> syncAll() async {
    bool allSuccess = true;

    try {
      // 1. Synchroniser les Enquêtes
      final unsyncedEnquetes = await _dbHelper.getUnsyncedEnquetes();
      print('[SYNC] Enquêtes à synchroniser: ${unsyncedEnquetes.length}');

      if (unsyncedEnquetes.isEmpty) {
        final unsyncedPaps = await _dbHelper.getUnsyncedPaps();
        print('[SYNC] PAPs à synchroniser: ${unsyncedPaps.length}');
        if (unsyncedPaps.isEmpty) {
          print('[SYNC] Rien à synchroniser - tout est déjà synced');
          return true; // rien à faire = succès
        }
      }

      for (var enquete in unsyncedEnquetes) {
        final enqueteMap = enquete.toMap();
        // Retirer uniquement les champs purement locaux (id SQLite, photo/signature locale)
        enqueteMap.remove('id');
        enqueteMap.remove('photoPath');
        enqueteMap.remove('signaturePath');
        // S'assurer que communeCode n'est jamais null (contrainte @NotNull backend)
        enqueteMap['communeCode'] ??= 'N/A';

        final payload = {'enquete': enqueteMap};
        print('[SYNC] Envoi enquête: ${enquete.idEnquete}');
        bool success = await _retryPost('/sync/push', payload);
        print('[SYNC] Résultat enquête ${enquete.idEnquete}: $success');
        
        if (success) {
          final syncedEnquete = enquete.copyWith(syncStatus: 'synced');
          await _dbHelper.insertEnquete(syncedEnquete);
        } else {
          allSuccess = false;
        }
      }

      // 2. Synchroniser les PAPs et leurs entités rattachées
      final unsyncedPaps = await _dbHelper.getUnsyncedPaps();
      print('[SYNC] PAPs à synchroniser: ${unsyncedPaps.length}');

      for (var pap in unsyncedPaps) {
        final idPap = pap.identifiantPap!;
        
        // UPLOAD DES DOCUMENTS
        final documents = await _dbHelper.getDocumentsByPap(idPap);
        List<Document> syncedDocs = [];
        
        for (var doc in documents) {
          if (doc.syncStatus != 'synced') {
            final serverPath = await _uploadFile(doc.cheminFichier, idPap, doc.codeTypeDoc);
            if (serverPath != null) {
              syncedDocs.add(doc.copyWith(syncStatus: 'synced'));
              doc = Document(idPap: idPap, codeTypeDoc: doc.codeTypeDoc, cheminFichier: serverPath);
            }
          }
        }

        final menage = await _dbHelper.getMenageByPap(idPap);
        final activite = await _dbHelper.getActiviteByPap(idPap);
        final sante = await _dbHelper.getSanteByPap(idPap);
        final education = await _dbHelper.getEducationByPap(idPap);
        final avis = await _dbHelper.getAvisProjetByPap(idPap);
        final localisation = await _dbHelper.getLocalisationByPap(idPap);

        final payload = {
          'pap': pap.toMap()..remove('id')..remove('syncStatus'),
          'documents': documents.map((d) => d.toMap()..remove('idDocument')..remove('syncStatus')).toList(),
          if (menage != null) 'menage': menage.toMap()..remove('idMenage')..remove('syncStatus'),
          if (activite != null) 'activite': activite.toMap()..remove('idActivite')..remove('syncStatus'),
          if (sante != null) 'sante': sante.toMap()..remove('idSante')..remove('syncStatus'),
          if (education != null) 'education': education.toMap()..remove('idEducation')..remove('syncStatus'),
          if (avis != null) 'avisProjet': avis.toMap()..remove('idAvis')..remove('syncStatus'),
          if (localisation != null) 'localisation': localisation.toMap()..remove('idLocalisation')..remove('syncStatus'),
        };
        
        print('[SYNC] Envoi PAP: $idPap');
        bool success = await _retryPost('/sync/push', payload);
        print('[SYNC] Résultat PAP $idPap: $success');
        
        if (success) {
          await _dbHelper.insertPap(pap.copyWith(syncStatus: 'synced'));
          for (var sd in syncedDocs) {
            await _dbHelper.insertDocument(sd);
          }
          if (menage != null) await _dbHelper.insertMenage(menage.copyWith(syncStatus: 'synced'));
          if (activite != null) await _dbHelper.insertActivite(activite.copyWith(syncStatus: 'synced'));
          if (sante != null) await _dbHelper.insertSante(sante.copyWith(syncStatus: 'synced'));
          if (education != null) await _dbHelper.insertEducation(education.copyWith(syncStatus: 'synced'));
          if (avis != null) await _dbHelper.insertAvisProjet(avis.copyWith(syncStatus: 'synced'));
          if (localisation != null) await _dbHelper.insertLocalisation(localisation.copyWith(syncStatus: 'synced'));
        } else {
          allSuccess = false;
        }
      }

      print('[SYNC] Résultat global: $allSuccess');
      return allSuccess;
    } catch (e) {
      print('[SYNC] EXCEPTION GLOBALE: $e');
      return false;
    }
  }

  /// Tente d'envoyer la donnée 3 fois maximum
  Future<bool> _retryPost(String path, Map<String, dynamic> data) async {
    int maxTries = 3;
    for (int i = 0; i < maxTries; i++) {
      try {
        print('[SYNC] Tentative ${i+1}/$maxTries vers $path');
        final response = await _apiClient.dio.post(path, data: data);
        print('[SYNC] Réponse HTTP: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        }
      } catch (e) {
        print('[SYNC] Erreur tentative ${i+1}: $e');
        if (i == maxTries - 1) return false;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    return false;
  }

  /// Upload une image via Multipart
  Future<String?> _uploadFile(String filePath, String idPap, String typeDoc) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: "${typeDoc}_${idPap}.jpg"),
        'idPap': idPap,
        'typeDoc': typeDoc,
      });

      final response = await _apiClient.dio.post(
        '/sync/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return response.data.toString(); // Retourne le chemin serveur
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
