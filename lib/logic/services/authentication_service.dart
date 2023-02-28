import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zem_auth/logic/models/auth_detail_model.dart';
import 'package:zem_auth/logic/models/user_model.dart';

class AuthenticationService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<UserModel> retrieveCurrentUser() {
    return auth.authStateChanges().map((User? user) {
      if (user != null) {
        return UserModel(uid: user.uid, email: user.email);
      } else {
        return UserModel(uid: "uid");
      }
    });
  }

  Future<UserCredential?> signIn(UserModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email!, password: user.password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<UserCredential?> signUp(UserModel user) async {
    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future sendVerifyEmail() async {
    try {
      final user = auth.currentUser!;
      debugPrint('[Authentication service] Email verify $user');
      await user.sendEmailVerification();
    } catch (error) {
      debugPrint('[Authentication service] at send verify email :: $error');
    }
  }

  Future<bool> checkVerifyEmail(bool isEmailVerified) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        debugPrint('[Authentication service] at checkVerifyEmail ');
        return isEmailVerified = auth.currentUser!.emailVerified;
      }
    }
    return false;
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    bool success = false;

    //Create an instance of the current user.
    var user = auth.currentUser!;
    //Must re-authenticate user before updating the password.
    // Otherwise it may fail or user get signed out.

    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
        //usersRef.doc(uid).update({"password": newPassword});
      }).catchError((error) {
        debugPrint('[Authentication service] at change password $error');
      });
    }).catchError((err) {
      debugPrint('[Authentication service] at change pass $err');
    });

    return success;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> signOutFacebook() async {
    try {
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (err) {
      debugPrint('[Authentication service] facebook Out : $err');
      return false;
    }
  }

  Future<bool> signOutGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await signOut();
      return true;
    } catch (err) {
      debugPrint('[Authentication service] facebook Out : $err');
      return false;
    }
  }

  Future<AuthenticationDetailModel> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request in google
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in firebase, return the UserCredential
    UserCredential userCredential = await auth.signInWithCredential(credential);

    return _getAuthCredentialFromFirebaseUser(user: userCredential.user);
  }

  Future<AuthenticationDetailModel> signInWithFacebook() async {
    // Trigger the sign-in flow

    try {
      final result = await FacebookAuth.i.login(permissions: ['email']);

      switch (result.status) {
        case LoginStatus.success:
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          debugPrint(
              '[Authentication service] at facebook Auth Credential ::: $facebookAuthCredential');
          UserCredential userCredential =
              await auth.signInWithCredential(facebookAuthCredential);
          debugPrint(
              '[Authentication service] at User Credentials ::: ${userCredential.user?.displayName}');
          return _getFacebookAuthCredentialFromFirebaseUser(
              user: userCredential.user);
        case LoginStatus.cancelled:
          print("Cancelled");
          break;
        case LoginStatus.failed:
          print("error");
          break;
        case LoginStatus.operationInProgress:
          print("Logged In");
          break;
      }
      // if (result.status == LoginStatus.success) {
      //
      //   final userData = await FacebookAuth.i.getUserData();
      //   debugPrint("facebook data ::: $userData");
      //   debugPrint(
      //       '[Authentication service] at facebook status :::  ${result.status}');
      //   debugPrint(
      //       '[Authentication service] at facebook message :::  ${result.message}');
      //   // Create a credential from the access token
      //   final OAuthCredential facebookAuthCredential =
      //       FacebookAuthProvider.credential(result.accessToken!.token);
      //   debugPrint(
      //       '[Authentication service] at facebook ::: $facebookAuthCredential');
      //   UserCredential userCredential =
      //       await auth.signInWithCredential(facebookAuthCredential);
      //   debugPrint(
      //       '[Authentication service] at facebook credential ::: $userCredential');
      //   return _getAuthCredentialFromFirebaseUser(user: userCredential.user);
      // }
    } catch (error) {
      print("facebook ::  $error");
    }
    //final LoginResult loginResult = await FacebookAuth.instance.login();

    return AuthenticationDetailModel(isValid: false);
    // Once signed in, return the UserCredential
  }

  AuthenticationDetailModel _getAuthCredentialFromFirebaseUser(
      {required User? user}) {
    AuthenticationDetailModel authDetail;
    if (user != null) {
      authDetail = AuthenticationDetailModel(
        isValid: true,
        uid: user.uid,
        email: user.email,
        photoUrl: user.photoURL,
        displayName: user.displayName,
      );
    } else {
      authDetail = AuthenticationDetailModel(isValid: false);
    }
    return authDetail;
  }

  AuthenticationDetailModel _getFacebookAuthCredentialFromFirebaseUser(
      {required User? user}) {
    AuthenticationDetailModel authDetail;

    if (user != null) {
      //authDetail = AuthenticationDetailModel.fromMap(user!.profile);
      authDetail = AuthenticationDetailModel(
        isValid: true,
        uid: user.uid,
        email: user.email,
        photoUrl: user.photoURL,
        displayName: user.displayName,
      );
    } else {
      authDetail = AuthenticationDetailModel(isValid: false);
    }
    return authDetail;
  }

  Future<bool> isNotValid(String email) async {
    return !RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""")
        .hasMatch(email);
  }

  Future<void> resetPassword(String email) async {
    auth.sendPasswordResetEmail(email: email);
  }
}
// UserCredential(
//      additionalUserInfo:
//        AdditionalUserInfo(
//                           isNewUser: true,
//                           profile: {
//                             picture:
//                             {
//                              data:
//                             {
//                               height: 100,
//                               url: https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=1844103465953615&height=100&width=100&ext=1676637016&hash=AeTpE12O4XSB658p3As,
//                                width: 100, is_silhouette: false
//                             }
//                             },
//                               first_name: Niazi,
//                              id: 1844103465953615,
//                              name: Niazi Nia ZI,
//                              middle_name: Nia,
//                              last_name: ZI
//                             },
//                               providerId: facebook.com,
//                               username: null
//                             ),
//                             credential: AuthCredential(
//                             providerId: facebook.com,
//                             signInMethod: facebook.com,
//                             token: 789769620,
//                             accessToken: EAAOgeuhkISkBAMySIlNt79F6rk5ivIMgivzRiicKOZAMf9OuCpOakjArPvNY1mkCw1HGwVWUaIR9RmQEcj7dEgPM1ZAsa2aQNiaw962nU728GEqvesIIzu3J5ll8WvAgGemRWWuoofucQMmyLSSs3imfiT1EJCHoVYKOf76eMQWLZCxXdS9YfZC7ZBmB0uZAN69A1G657kY1ci2d1LhSLnmK8TnNmXZBBMPTtZBxyfZAC6wZDZD
//                           ),
