class AuthResultDTO {
  final String accessToken;
  final String refreshToken;

  AuthResultDTO({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResultDTO.fromJson(Map<String, dynamic> json) {
    return AuthResultDTO(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}
