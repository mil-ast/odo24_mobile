import 'dart:convert' show utf8, base64, json;
import 'dart:typed_data';

class AuthToken {
  final String accessToken;
  final String refreshToken;
  final int userID;
  final DateTime accessTokenExpires;
  final DateTime refreshTokenExpires;

  const AuthToken({
    required this.userID,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpires,
    required this.refreshTokenExpires,
  });

  factory AuthToken.fromStrings(String accessToken, String refreshToken) {
    // access token
    List<String> split = accessToken.split('.');
    Uint8List b64Decoded = base64.decode(split[1]);
    String rawJson = utf8.decode(b64Decoded);
    Map<String, dynamic> claims = json.decode(rawJson);

    final userIDValue = claims['uid'] as int;
    DateTime accessTokenExpiresValue = DateTime.fromMillisecondsSinceEpoch((claims['exp'] as int) * 1000);

    // refresh token
    split = refreshToken.split('.');
    b64Decoded = base64.decode(split[1]);
    rawJson = utf8.decode(b64Decoded);
    claims = json.decode(rawJson);

    DateTime refreshTokenExpiresValue = DateTime.fromMillisecondsSinceEpoch((claims['exp'] as int) * 1000);

    return AuthToken(
      userID: userIDValue,
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpires: accessTokenExpiresValue,
      refreshTokenExpires: refreshTokenExpiresValue,
    );
  }

  bool isExpired() {
    return accessTokenExpires.difference(DateTime.now()).inMilliseconds <= 1000 * 10;
  }

  bool isRefreshTokenExpired() {
    return refreshTokenExpires.difference(DateTime.now()).inMilliseconds <= 1000 * 30;
  }
}
