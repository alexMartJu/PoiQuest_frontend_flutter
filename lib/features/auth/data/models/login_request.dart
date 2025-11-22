/// DTO para la petición de login.
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  /// Convierte a JSON para enviar al servidor.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
