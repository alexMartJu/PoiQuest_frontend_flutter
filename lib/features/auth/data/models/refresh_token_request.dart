/// DTO para la petición de refresh token.
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({
    required this.refreshToken,
  });

  /// Convierte a JSON para enviar al servidor.
  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}
