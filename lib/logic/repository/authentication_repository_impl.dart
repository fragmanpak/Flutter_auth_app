import 'package:firebase_auth/firebase_auth.dart';
import 'package:zem_auth/logic/models/user_model.dart';
import 'package:zem_auth/logic/repository/repository.dart';
import 'package:zem_auth/logic/services/authentication_service.dart';
import 'package:zem_auth/logic/services/database_service.dart';

import '../models/auth_detail_model.dart';

class AuthenticationRepositoryImpl implements Repository {
  AuthenticationService authService = AuthenticationService();
  DatabaseService dbService = DatabaseService();

  @override
  Future<void> createGoogleUser(AuthenticationDetailModel userData) {
    return dbService.addGoogleUserData(userData);
  }

  @override
  Future<void> createUser(UserModel userData) {
    return dbService.addUserData(userData);
  }

  @override
  Stream<UserModel> getCurrentUser() {
    return authService.retrieveCurrentUser();
  }

  @override
  Future<UserCredential?> signUp(UserModel user) {
    try {
      return authService.signUp(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential?> signIn(UserModel user) {
    try {
      return authService.signIn(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<bool> emailChecker(String email) {
    return authService.isNotValid(email);
  }

  @override
  Future<bool?> retrieveUser(UserModel user) {
    return dbService.retrieveUser(user);
  }

  @override
  Future<AuthenticationDetailModel> signInGoogle() {
    return authService.signInWithGoogle();
  }

  @override
  Future<AuthenticationDetailModel> signInFacebook() {
    return authService.signInWithFacebook();
  }

  @override
  Future<void> unAuthenticate() async {
    return authService.signOut();
  }  @override
  Future<bool> facebookLogOut() async {
    return authService.signOutFacebook();
  }

  @override
  Future<void> emailPasswordReset(email) {
    return authService.resetPassword(email!);
  }

  @override
  Future<bool> googleLogOut() {
    return authService.signOutGoogle();
  }
}
