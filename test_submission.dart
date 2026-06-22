import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse('https://ptua-backend-api.onrender.com/sync/push');
  
  // Construction du payload exhaustif qui correspond à la nouvelle architecture
  final payload = {
    'enquete': {
      'idEnquete': 'ENQ-TEST-002',
      'codeUnique': 'TEST-002',
      'idLocalisation': 'LOC-002',
      'status': 'Terminé',
      'agentId': 'enqueteur01',
      'photoBati': 'test.jpg'
    },
    'pap': {
      'identifiantPap': 'PAP-TEST-002',
      'idEnquete': 'ENQ-TEST-002',
      'nomPap': 'Koffi Yao',
      'genre': 'Homme',
      'nationalite': 'Ivoirien',
      'ethnie': 'Baoulé',
      'niveauInstruc': 'Supérieur',
      'dateNaissance': '1985-06-15T00:00:00.000'
    },
    'menage': {
      'idPap': 'PAP-TEST-002',
      'nbrePersonnesMenage': 4,
      'isChefMen': true,
      'isPersonneVulMenage': false,
      'typeMenage': 'Ménage composé d\'un couple et d\'enfants'
    },
    'infoLogement': {
      'idPap': 'PAP-TEST-002',
      'statutOccupation': 'Propriétaire',
      'typeBatiment': 'Construction individuelle',
      'materiauMur': 'Brique',
      'materiauSol': 'Ciment',
      'materiauToit': 'Tôle',
      'sourceEau': 'Eau de SODECI à la maison',
      'typeToilette': 'Toilette avec chasse d\'eau',
      'energieCuisson': 'gaz butane',
      'energieEclairage': 'CIE'
    },
    'infoFinanciere': {
      'idPap': 'PAP-TEST-002',
      'aCompteBanque': true,
      'pratiqueTontine': false,
      'recoitAide': false
    },
    'credits': [
      {
        'idPap': 'PAP-TEST-002',
        'institution': 'Banque',
        'raison': 'Construction',
        'statut': 'En cours de remboursement',
        'montant': 1500000
      }
    ],
    'agriculture': {
      'idPap': 'PAP-TEST-002',
      'typeCulture': 'Cultures Vivrières',
      'modeAcquisition': 'Achat',
      'exploiteSoiMeme': true,
      'nbBovins': 0,
      'nbOvins': 0,
      'nbVolailles': 10
    },
    'activite': {
      'idPap': 'PAP-TEST-002',
      'activitePrincipMenage': 'Salarié du privé',
      'revenuMoyeActPrin': 250000.0
    },
    'sante': {
      'idPap': 'PAP-TEST-002',
      'isAssurance': true,
      'assureur': 'MUPEMENET',
      'typeSoinMen': 'Centre de santé privée'
    }
  };

  print('Envoi de la requête de test à $url...');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    print('Status Code: ${response.statusCode}');
    print('Réponse: ${response.body}');
  } catch (e) {
    print('Erreur: $e');
  }
}
