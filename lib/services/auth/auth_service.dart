import 'package:firebase_auth/firebase_auth.dart';
import 'package:odo24_mobile/services/auth/user_model.dart';

class AuthService {
  Future<UserModel> signInWithEmailAndPassword(String email, String password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((UserCredential user) => UserModel.fromUserCredential(user));
  }

  Future<UserModel> createUserWithEmailAndPassword(String email, String password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((UserCredential user) => UserModel.fromUserCredential(user));
  }

  static Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  static Stream<UserModel?> getUser() {
    return FirebaseAuth.instance.userChanges().map((User? user) {
      if (user == null) {
        return null;
      }

      return UserModel.fromUser(user);
    });
  }
}
