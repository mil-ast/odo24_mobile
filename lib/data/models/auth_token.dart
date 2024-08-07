import 'dart:convert' show utf8, base64, json;
import 'dart:typed_data';

final class AuthData {
  final String accessToken;
  final String refreshToken;
  final int userID;
  final DateTime accessTokenExpires;
  final DateTime refreshTokenExpires;

  const AuthData({
    required this.userID,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpires,
    required this.refreshTokenExpires,
  });

  factory AuthData.fromStrings(String accessToken, String refreshToken) {
    // access token
    var split = accessToken.split('.');

    var normalize = base64.normalize(split[1]);
    Uint8List b64Decoded = base64.decode(normalize);
    String rawJson = utf8.decode(b64Decoded);
    Map<String, dynamic> claims = json.decode(rawJson);

    final userIDValue = claims['uid'] as int;
    DateTime accessTokenExpiresValue = DateTime.fromMillisecondsSinceEpoch((claims['exp'] as int) * 1000);

    // refresh token
    split = refreshToken.split('.');
    normalize = base64.normalize(split[1]);
    b64Decoded = base64.decode(normalize);
    rawJson = utf8.decode(b64Decoded);
    claims = json.decode(rawJson);

    DateTime refreshTokenExpiresValue = DateTime.fromMillisecondsSinceEpoch((claims['exp'] as int) * 1000);

    return AuthData(
      userID: userIDValue,
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpires: accessTokenExpiresValue,
      refreshTokenExpires: refreshTokenExpiresValue,
    );
  }

  bool isAccessExpired() {
    return accessTokenExpires.difference(DateTime.now()).inMilliseconds <= 1000 * 10;
  }

  bool isRefreshTokenExpired() {
    return refreshTokenExpires.difference(DateTime.now()).inMilliseconds <= 1000 * 30;
  }
}
