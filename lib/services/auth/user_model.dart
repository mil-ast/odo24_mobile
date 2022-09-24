import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uid;
  String? email;

  UserModel({
    required this.uid,
    this.email,
  });

  factory UserModel.fromUserCredential(UserCredential user) => UserModel(
        uid: user.user!.uid,
        email: user.user!.email,
      );

  factory UserModel.fromUser(User user) => UserModel(
        uid: user.uid,
        email: user.email,
      );
}
