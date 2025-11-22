/// DTO para la petición de registro de usuario estándar.
class RegisterStandardUserRequest {
  final String name;
  final String lastname;
  final String email;
  final String password;
  final String? avatarUrl;
  final String? bio;

  const RegisterStandardUserRequest({
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
    this.avatarUrl,
    this.bio,
  });

  /// Convierte a JSON para enviar al servidor.
  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
    };

    if (avatarUrl != null) {
      json['avatarUrl'] = avatarUrl!;
    }

    if (bio != null) {
      json['bio'] = bio!;
    }

    return json;
  }
}
