part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final bool? isLoginLoading = false;
  final bool? isSignUpLoading = false;
  final bool? isGoogleLoading = false;
  final bool? isFacebookLoading = false;
  final bool? updatePasswordLoading = false;
  final bool? userProfileLoading = false;

  @override
  List<Object?> get props => [
        isLoginLoading,
        isSignUpLoading,
        isGoogleLoading,
        isFacebookLoading,
      ];
}

class AuthInitialState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthFailureState extends AuthState {
  final String? message;

  AuthFailureState({this.message});
}

/// Google
enum GoogleStatus {
  initial,
  success,
  error,
  loading,
}

extension GoogleUserStatusX on GoogleStatus {
  bool get isInitial => this == GoogleStatus.initial;

  bool get isSuccess => this == GoogleStatus.success;

  bool get isError => this == GoogleStatus.error;

  bool get isLoading => this == GoogleStatus.loading;
}

class GoogleUserState extends AuthState {
  final AuthenticationDetailModel? authenticationDetail;
  final String? errorMessage;
  final bool? isLoading;
  final GoogleStatus status;

  GoogleUserState({
    this.authenticationDetail,
    this.errorMessage,
    this.status = GoogleStatus.initial,
    this.isLoading = false,
  });

  @override
  List<Object?> get props =>
      [authenticationDetail, status, errorMessage, isLoading];

  GoogleUserState copyWith({
    AuthenticationDetailModel? authenticationDetail,
    GoogleStatus? status,
    String? errorMessage,
    bool? isLoading,
  }) {
    return GoogleUserState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      authenticationDetail: authenticationDetail ?? authenticationDetail,
    );
  }

  @override
  bool? get isGoogleLoading => isLoading;
}

/// facebook sign in
enum FacebookStatus {
  initial,
  success,
  error,
  loading,
}

extension FacebookStatusX on FacebookStatus {
  bool get isInitial => this == FacebookStatus.initial;

  bool get isSuccess => this == FacebookStatus.success;

  bool get isError => this == FacebookStatus.error;

  bool get isLoading => this == FacebookStatus.loading;
}

class FacebookUserState extends AuthState {
  final AuthenticationDetailModel? authenticationDetail;
  final String? errorMessage;
  final bool? isLoading;
  final FacebookStatus status;

  FacebookUserState({
    this.authenticationDetail,
    this.errorMessage,
    this.status = FacebookStatus.initial,
    this.isLoading = false,
  });

  @override
  List<Object?> get props =>
      [authenticationDetail, status, errorMessage, isLoading];

  FacebookUserState copyWith({
    AuthenticationDetailModel? authenticationDetail,
    FacebookStatus? status,
    String? errorMessage,
    bool? isLoading,
  }) {
    return FacebookUserState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      authenticationDetail: authenticationDetail ?? authenticationDetail,
    );
  }

  @override
  bool? get isFacebookLoading => isLoading;
}

///Login
enum LoginStatus {
  initial,
  success,
  error,
  loading,
}

extension LoginStatusX on LoginStatus {
  bool get isInitial => this == LoginStatus.initial;

  bool get isSuccess => this == LoginStatus.success;

  bool get isError => this == LoginStatus.error;

  bool get isLoading => this == LoginStatus.loading;
}

class LoginSuccessState extends AuthState {
  final LoginStatus status;
  final String? errorMessage;
  final String? errorEmail;
  final String? errorPassword;

  final bool? isLoading;

  LoginSuccessState({
    this.errorMessage,
    this.errorEmail,
    this.errorPassword,
    this.status = LoginStatus.initial,
    int idSelected = 0,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
        status,
        errorEmail,
        errorPassword,
      ];

  LoginSuccessState copyWith({
    String? errorMessage,
    String? errorEmail,
    LoginStatus? status,
    String? errorPassword,
    bool? isLoading,
  }) {
    return LoginSuccessState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      errorEmail: errorEmail ?? this.errorEmail,
      errorPassword: errorPassword ?? this.errorPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool? get isLoginLoading => isLoading;
}

///Register User sign up
enum SignUpStatus {
  initial,
  success,
  error,
  loading,
}

extension SignUpUserStatusX on SignUpStatus {
  bool get isInitial => this == SignUpStatus.initial;

  bool get isSuccess => this == SignUpStatus.success;

  bool get isError => this == SignUpStatus.error;

  bool get isLoading => this == SignUpStatus.loading;
}

class SignUpUserState extends AuthState {
  final String? errorEmail;
  final String? errorNew;
  final String? errorConfirm;
  final String? mainMessage;
  final bool? isLoading;
  final SignUpStatus status;

  SignUpUserState({
    this.errorEmail,
    this.errorNew,
    this.errorConfirm,
    this.mainMessage,
    this.status = SignUpStatus.initial,
    this.isLoading = false,
  });

  @override
  List<Object?> get props =>
      [status, errorEmail, errorNew, mainMessage, errorConfirm, isLoading];

  SignUpUserState copyWith({
    SignUpStatus? status,
    String? errorEmail,
    String? errorNew,
    String? errorConfirm,
    String? mainMessage,
    bool? isLoading,
  }) {
    return SignUpUserState(
      status: status ?? this.status,
      errorEmail: errorEmail ?? this.errorEmail,
      errorNew: errorNew ?? this.errorNew,
      errorConfirm: errorConfirm ?? this.errorConfirm,
      isLoading: isLoading ?? this.isLoading,
      mainMessage: mainMessage ?? this.mainMessage,
    );
  }

  @override
  bool? get isSignUpLoading => isLoading;
}

///Change Password
enum ForgetPasswordStatus {
  initial,
  success,
  error,
  loading,
}

extension ForgetPasswordStatusX on ForgetPasswordStatus {
  bool get isInitial => this == ForgetPasswordStatus.initial;

  bool get isSuccess => this == ForgetPasswordStatus.success;

  bool get isError => this == ForgetPasswordStatus.error;

  bool get isLoading => this == ForgetPasswordStatus.loading;
}

class UpdatePasswordState extends AuthState {
  final String? errorEmail;
  final String? errorCurrent;
  final String? errorNew;
  final String? errorConfirm;
  final String? mainMessage;
  final bool? isLoadingPassword;
  final ForgetPasswordStatus status;

  UpdatePasswordState({
    this.errorEmail,
    this.errorCurrent,
    this.errorNew,
    this.errorConfirm,
    this.mainMessage,
    this.status = ForgetPasswordStatus.initial,
    this.isLoadingPassword = false,
  });

  @override
  List<Object?> get props => [
        status,
        errorCurrent,
        errorNew,
        mainMessage,
        errorConfirm,
        isLoadingPassword
      ];

  UpdatePasswordState copyWith({
    ForgetPasswordStatus? status,
    String? errorEmail,
    String? errorCurrent,
    String? errorNew,
    String? errorConfirm,
    String? mainMessage,
    bool? isLoadingPassword,
  }) {
    return UpdatePasswordState(
      errorCurrent: errorCurrent ?? this.errorCurrent,
      errorEmail: errorEmail ?? this.errorEmail,
      status: status ?? this.status,
      errorNew: errorNew ?? this.errorNew,
      errorConfirm: errorConfirm ?? this.errorConfirm,
      isLoadingPassword: isLoadingPassword ?? this.isLoadingPassword,
      mainMessage: mainMessage ?? this.mainMessage,
    );
  }

  @override
  bool? get updatePasswordLoading => isLoadingPassword;
}

class LogoutFailState extends AuthState {
  final String? message;

  LogoutFailState({this.message});
}

class LogoutLoadingState extends AuthState {}

class LogoutSuccessState extends AuthState {}
