class AuthResultModel {
  final String accessToken;
  final String refreshToken;

  const AuthResultModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}
