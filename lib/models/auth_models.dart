class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final String type;
  final String username;

  LoginResponse({
    required this.token,
    required this.type,
    required this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      type: json['type'] ?? 'Bearer',
      username: json['username'],
    );
  }
}
