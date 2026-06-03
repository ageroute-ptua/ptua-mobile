import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_models.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final _secureStorage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    try {
      final request = LoginRequest(username: username, password: password);
      
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        
        // Sauvegarder le token de manière sécurisée
        await _secureStorage.write(key: 'jwt_token', value: loginResponse.token);
        await _secureStorage.write(key: 'username', value: loginResponse.username);
        
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        print("Erreur de connexion : ${e.message}");
      }
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _secureStorage.delete(key: 'username');
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }
}
