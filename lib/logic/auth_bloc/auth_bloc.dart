import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zem_auth/logic/models/auth_detail_model.dart';
import 'package:zem_auth/logic/models/user_model.dart';
import 'package:zem_auth/logic/repository/repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Repository repository;

  AuthBloc({required this.repository}) : super(AuthInitialState()) {
    on<LoginEvent>(_loginEvent);
    on<SignUpEvent>(_signupEvent);
    on<AuthStarted>(_retrieveCurrentUser);
    on<GoogleAuthEventStart>(_googleSignIn);
    on<FacebookAuthEventStart>(_facebookSignIn);
    on<GoogleAuthExitedState>(_googleAuthLogout);
    on<ForgetPasswordEvent>(_forgetPasswordEvent);
    on<FirebaseAuthExitedState>(_firebaseAuthLogout);
    on<FacebookAuthExitedState>(_facebookAuthLogout);
  }

  Future<void> _googleSignIn(
      GoogleAuthEventStart event, Emitter<AuthState> emit) async {
    emit(GoogleUserState()
        .copyWith(status: GoogleStatus.loading, isLoading: true));
    try {
      AuthenticationDetailModel authenticationDetail =
          await repository.signInGoogle();
      debugPrint('display google auth data :: $authenticationDetail');
      if (authenticationDetail.isValid!) {
        emit(GoogleUserState().copyWith(
            status: GoogleStatus.success,
            authenticationDetail: authenticationDetail,
            isLoading: false));

        /// Save user in firebase
        await repository.createGoogleUser(authenticationDetail);
      } else {
        emit(GoogleUserState().copyWith(
            status: GoogleStatus.error,
            errorMessage: "Google user not verified",
            isLoading: false));
      }
    } on FirebaseAuthException catch (error) {
      if (kDebugMode) {
        print('Error At Auth bloc google : $error');
        emit(GoogleUserState().copyWith(
            status: GoogleStatus.error,
            isLoading: false,
            errorMessage: error.message.toString()));
      }
    }
  }

  /// facebook sign in
  Future<void> _facebookSignIn(
      FacebookAuthEventStart event, Emitter<AuthState> emit) async {
    emit(FacebookUserState()
        .copyWith(status: FacebookStatus.loading, isLoading: true));
    try {
      AuthenticationDetailModel authenticationDetail =
          await repository.signInFacebook();
      debugPrint(
          'display facebook auth data :: ${authenticationDetail.isValid}');
      if (authenticationDetail.isValid == true) {
        emit(FacebookUserState().copyWith(
            status: FacebookStatus.success,
            authenticationDetail: authenticationDetail,
            isLoading: false));

        /// Save user in firebase
        await repository.createGoogleUser(authenticationDetail);
        // bool check = await repository.facebookLogOut();
        // if (check == false) {
        //   emit(FacebookUserState().copyWith(
        //       status: FacebookStatus.error,
        //       errorMessage: "facebook user not logout",
        //       isLoading: false));
        // }
      } else {
        emit(FacebookUserState().copyWith(
            status: FacebookStatus.error,
            errorMessage: "facebook user not verified",
            isLoading: false));
      }
    } on FirebaseAuthException catch (error) {
      debugPrint('Error At Auth bloc facebook : $error');
      emit(FacebookUserState().copyWith(
          status: FacebookStatus.error,
          isLoading: false,
          errorMessage: error.message.toString()));
    }
  }

  /// Sign in With firebase
  Future<void> _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    if (event.email.isEmpty) {
      emit(LoginSuccessState().copyWith(errorEmail: 'Please enter email'));
    } else if (await repository.emailChecker(event.email)) {
      emit(LoginSuccessState().copyWith(errorEmail: 'Email not valid'));
    } else if (event.password.isEmpty || event.password.length < 8) {
      event.password.isEmpty
          ? emit(LoginSuccessState()
              .copyWith(errorPassword: 'Please enter password'))
          : emit(LoginSuccessState().copyWith(
              errorPassword: 'Password should be minimum 8 character'));
    } else {
      emit(LoginSuccessState()
          .copyWith(status: LoginStatus.loading, isLoading: true));
      try {
        UserModel user = UserModel(
          email: event.email,
          password: event.password,
          isVerified: true,
        );

        /// signin user in firebase
        await repository.signIn(user);

        emit(
          LoginSuccessState()
              .copyWith(status: LoginStatus.success, isLoading: false),
        );
      } on FirebaseAuthException catch (error) {
        if (kDebugMode) {
          print('Error At Auth bloc : $error');
          emit(LoginSuccessState().copyWith(
              status: LoginStatus.error,
              isLoading: false,
              errorMessage: error.message.toString()));
        }
      }
    }
  }

  /// Sign Up With firebase
  Future<void> _signupEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    if (event.email.isEmpty) {
      emit(SignUpUserState().copyWith(errorEmail: 'Please enter email'));
    } else if (await repository.emailChecker(event.email)) {
      emit(SignUpUserState().copyWith(errorEmail: 'Email not valid'));
    } else if (event.password.isEmpty || event.password.length < 8) {
      event.password.isEmpty
          ? emit(SignUpUserState().copyWith(errorNew: 'Please enter password'))
          : emit(SignUpUserState()
              .copyWith(errorNew: 'Password should be minimum 8 character'));
    } else if (event.password.isEmpty ||
        event.password.length != event.confirmPassword.length) {
      event.password.isEmpty
          ? emit(
              SignUpUserState().copyWith(errorConfirm: 'Please enter password'))
          : emit(SignUpUserState()
              .copyWith(errorConfirm: 'Password does not match'));
    } else {
      emit(SignUpUserState()
          .copyWith(status: SignUpStatus.loading, isLoading: true));
      try {
        UserModel user =
            UserModel(email: event.email, password: event.password);
        UserCredential? authUser = await repository.signUp(user);
        UserModel addUser = user.copyWith(
          uid: authUser!.user!.uid,
          isVerified: authUser.user!.emailVerified,
          email: event.email,
          password: event.password,
        );

        /// Save user in firebase
        await repository.createUser(addUser);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('UidToken', authUser.user!.uid);
        emit(
          SignUpUserState()
              .copyWith(status: SignUpStatus.success, isLoading: false),
        );
      } on FirebaseAuthException catch (error) {
        if (kDebugMode) {
          print('Sign In Error At Auth bloc : $error');
          emit(SignUpUserState().copyWith(
              status: SignUpStatus.error,
              isLoading: false,
              mainMessage: error.message.toString()));
        }
      }
    }
  }

  /// Get Current User
  Future<void> _retrieveCurrentUser(
      AuthStarted event, Emitter<AuthState> emit) async {
    UserModel user = await repository.getCurrentUser().first;
    if (user.uid != "uid") {
      bool? displayEmail = await repository.retrieveUser(user);
      emit(LoginSuccessState());
      debugPrint('Show Email At Auth bloc : $displayEmail');
    } else {
      emit(AuthFailureState());
    }
  }

  /// email forget password
  Future<void> _forgetPasswordEvent(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    try {
      emit(UpdatePasswordState().copyWith(
          status: ForgetPasswordStatus.loading, isLoadingPassword: true));
      await repository.emailPasswordReset(event.checkEmail);
      emit(UpdatePasswordState().copyWith(
          status: ForgetPasswordStatus.loading, isLoadingPassword: false));
    } on FirebaseAuthException catch (error) {
      emit(UpdatePasswordState().copyWith(
        status: ForgetPasswordStatus.error,
        errorEmail: error.message.toString(),
        isLoadingPassword: false,
      ));
    }
  }

  /// logout firebase
  Future<void> _firebaseAuthLogout(
      FirebaseAuthExitedState event, Emitter<AuthState> emit) async {
    try {
      emit(LogoutLoadingState());
      await repository.unAuthenticate();
      emit(LogoutSuccessState());
    } on FirebaseAuthException catch (error) {
      debugPrint(
          'Error occurred while logging out fire. : ${error.message.toString()}');
      emit(
          LogoutFailState(message: 'Unable to logout fire. Please try again.'));
    }
  }

  /// logout facebook
  Future<void> _facebookAuthLogout(
      FacebookAuthExitedState event, Emitter<AuthState> emit) async {
    try {
      emit(LogoutLoadingState());
      await repository.facebookLogOut();
      emit(LogoutSuccessState());
    } on FirebaseAuthException catch (error) {
      debugPrint(
          'Error occurred while logging out facebook. : ${error.message.toString()}');
      emit(LogoutFailState(message: 'Unable to logout fb. Please try again.'));
    }
  }

  /// logout google

  Future<void> _googleAuthLogout(
      GoogleAuthExitedState event, Emitter<AuthState> emit) async {
    try {
      emit(LogoutLoadingState());
      await repository.googleLogOut();
      emit(LogoutSuccessState());
    } on FirebaseAuthException catch (error) {
      debugPrint(
          'Error occurred while logging out google. : ${error.message.toString()}');
      emit(LogoutFailState(
          message: 'Unable to logout google. Please try again.'));
    }
  }
}
