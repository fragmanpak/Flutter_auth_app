import 'package:firebase_auth/firebase_auth.dart';
import 'package:zem_auth/logic/models/auth_detail_model.dart';
import 'package:zem_auth/logic/models/user_model.dart';

abstract class Repository {
  Stream<UserModel> getCurrentUser();

  Future<UserCredential?> signUp(UserModel user);

  Future<UserCredential?> signIn(UserModel user);

  Future<bool> emailChecker(String email);

  Future<void> createUser(UserModel userData);

  Future<void> createGoogleUser(AuthenticationDetailModel userData);

  Future<bool?> retrieveUser(UserModel user);

  Future<AuthenticationDetailModel> signInGoogle();

  Future<AuthenticationDetailModel> signInFacebook();

  Future<void> unAuthenticate();

  Future<bool> facebookLogOut();

  Future<bool> googleLogOut();

  Future<void> emailPasswordReset(String? email);
}
