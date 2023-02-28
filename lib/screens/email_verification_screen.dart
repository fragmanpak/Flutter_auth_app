import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zem_auth/common_widgets/common_button.dart';
import 'package:zem_auth/logic/services/authentication_service.dart';
import 'package:zem_auth/screens/welcome_screen.dart';
import 'package:zem_auth/utils/app_colors.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  final authService = AuthenticationService();
  Timer? timer;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      setState(() {
        canResendEmail = false;
      });
      Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
      authService.sendVerifyEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3),
          (_) async => isEmailVerified =
              await authService.checkVerifyEmail(isEmailVerified));
      setState(() {
        isEmailVerified;
      });
      if (isEmailVerified) {
        timer?.cancel();
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const WelcomeScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify Email'),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Email verification code is send to this email account ${widget.email}',
                    style: const TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0),
                  InkWell(
                      onTap: () =>
                          canResendEmail ? authService.sendVerifyEmail() : null,
                      child: CommonButton(
                        text: 'Resend Email',
                        color: canResendEmail
                            ? AppColors.greenTextColor
                            : AppColors.kL2BlackColor,
                      )),
                  const SizedBox(height: 30.0),
                  InkWell(
                      onTap: () => FirebaseAuth.instance.signOut(),
                      child: CommonButton(
                        text: 'Cancel',
                        color: AppColors.kHintBackBlackColor,
                      )),
                ],
              ),
            ),
          );
  }
}
