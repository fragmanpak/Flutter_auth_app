part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpEvent(
      {required this.email,
      required this.password,
      required this.confirmPassword});
}

//Change Password
class ForgetPasswordEvent extends AuthEvent {
  final String? currentPassword;
  final String? newPassword;
  final String? confirmPassword;
  final String? checkEmail;

  const ForgetPasswordEvent({
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
    this.checkEmail,
  });

// @override
// List<Object> get props => [currentPassword, newPassword, confirmPassword,checkEmail];
}

class AuthStarted extends AuthEvent {
  @override
  List<Object> get props => [];
}

class GoogleAuthEventStart extends AuthEvent {}

class FacebookAuthEventStart extends AuthEvent {}

class FirebaseAuthExitedState extends AuthEvent {}

class FacebookAuthExitedState extends AuthEvent {}

class GoogleAuthExitedState extends AuthEvent {}
