import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;
  final _secureStorage = const FlutterSecureStorage();

  // Lien Cloud (Render) au lieu de l'IP locale de votre ordinateur
  static const String baseUrl = 'https://ptua-backend-api.onrender.com/api'; 

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Ajout d'un intercepteur pour attacher le Token JWT automatiquement
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: 'jwt_token');
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Continuer la requête
        },
        onError: (DioException e, handler) async {
          // Gestion globale des erreurs (ex: 401 Unauthorized)
          if (e.response?.statusCode == 401) {
            // Déconnecter l'utilisateur
            await _secureStorage.delete(key: 'jwt_token');
          }
          return handler.next(e);
        },
      ),
    );
  }
}
