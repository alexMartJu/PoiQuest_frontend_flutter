/// DTO para la petición de logout.
class LogoutRequest {
  final String refreshToken;

  const LogoutRequest({
    required this.refreshToken,
  });

  /// Convierte a JSON para enviar al servidor.
  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}
