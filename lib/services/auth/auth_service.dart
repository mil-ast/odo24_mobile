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
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((UserCredential user) => UserModel.fromUserCredential(user));
  }
}
