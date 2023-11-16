import 'package:odo24_mobile/data/repository/auth/auth_result.dto.dart';
import 'package:odo24_mobile/domain/services/auth/models/auth_token.dart';

class UserModel {
  String email;
  AuthToken token;

  UserModel({
    required this.email,
    required this.token,
  });

  factory UserModel.fromDTO(String email, AuthResultDTO dto) {
    return UserModel(
      email: email,
      token: AuthToken.fromStrings(dto.accessToken, dto.refreshToken),
    );
  }
}
