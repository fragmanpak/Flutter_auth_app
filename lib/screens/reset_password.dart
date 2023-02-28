import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zem_auth/common_widgets/common_button.dart';
import 'package:zem_auth/common_widgets/model_progress_hud.dart';
import 'package:zem_auth/common_widgets/my_text_field.dart';
import 'package:zem_auth/logic/auth_bloc/auth_bloc.dart';
import 'package:zem_auth/screens/login_screen.dart';
import 'package:zem_auth/utils/app_colors.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UpdatePasswordState) {
            if (state.status == ForgetPasswordStatus.success) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            } else if (state.status == ForgetPasswordStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${state.mainMessage}')));
            }
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state.updatePasswordLoading!,
            dismissible: false,
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Enter your email and we will send you a verification link check your eamil please!',
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 60.0),

                      /// emailController

                      MyTextField(
                        controller: emailController,
                        text: 'Input',
                      ),
                      const SizedBox(height: 20.0),

                      /// email error text show bloc
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is UpdatePasswordState) {
                            return state.errorEmail != null &&
                                    state.errorEmail!.isNotEmpty
                                ? Text(
                                    '${state.errorEmail}',
                                  )
                                : const SizedBox();
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 20),

                      /// reset button
                      GestureDetector(
                          onTap: () {
                            context.read<AuthBloc>().add(ForgetPasswordEvent(
                                checkEmail: emailController.text));
                          },
                          child: CommonButton(
                            text: "Reset Password",
                            color: AppColors.kL1RedColor,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
