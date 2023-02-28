import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zem_auth/common_widgets/common_button.dart';
import 'package:zem_auth/common_widgets/model_progress_hud.dart';
import 'package:zem_auth/common_widgets/my_text_field.dart';
import 'package:zem_auth/logic/auth_bloc/auth_bloc.dart';
import 'package:zem_auth/screens/login_screen.dart';
import 'package:zem_auth/screens/welcome_screen.dart';
import 'package:zem_auth/utils/app_colors.dart';
import 'package:zem_auth/utils/app_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    //emailController.text = '@gmail.com';
   // passwordController.text = '12341234';
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailNumberFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is SignUpUserState) {
        debugPrint(state.isSignUpLoading.toString());
        if (state.status == SignUpStatus.success) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()));
        } else if (state.status == SignUpStatus.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${state.mainMessage}')));
        }
      }
    }, builder: (context, state) {
      return ModalProgressHUD(
        inAsyncCall: state.isSignUpLoading!,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.appBarBgColor,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 28,
              ),
            ),
            elevation: 0,
            title: Text(
              "Create Basic Account",
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.kTextStyleTwentyWithBlackColor400,
            ),
          ),
          body: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// login text
                      Text(
                        'Sign Up',
                        style: AppTextStyles.kTextStyleTwentyWithBlackColor400,
                      ),
                      const SizedBox(
                        height: 31,
                      ),
                      const Text(
                        "Email",
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      /// email input field
                      MyTextField(
                        controller: emailController,
                        focusNode: _emailNumberFocus,
                        nextFocus: _passwordFocus,
                        text: 'Email',
                        onChanging: (email) {},
                      ),

                      /// email error text show bloc
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is SignUpUserState) {
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
                      const SizedBox(
                        height: 15,
                      ),

                      /// password text and show text click
                      const Text(
                        "Password",
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      /// password input field
                      MyTextField(
                        focusNode: _passwordFocus,
                        controller: passwordController,
                        text: 'Input',
                        isObscure: true,
                      ),

                      /// password error text show bloc
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is SignUpUserState) {
                            return state.errorNew != null &&
                                state.errorNew!.isNotEmpty
                                ? Text(
                              '${state.errorNew}',
                            )
                                : const SizedBox();
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      /// confirm password text and show text click
                      const Text(
                        "Confirm Password",
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      /// confirm password input field
                      MyTextField(
                        focusNode: _confirmPasswordFocus,
                        controller: confirmPasswordController,
                        text: 'Input',
                        isObscure: true,
                      ),

                      /// confirm password error text show bloc
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is SignUpUserState) {
                            return state.errorConfirm != null &&
                                state.errorConfirm!.isNotEmpty
                                ? Text(
                              '${state.errorConfirm}',
                            )
                                : const SizedBox();
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  context.read<AuthBloc>().add(
                                    SignUpEvent(
                                        email: emailController.text.trim(),
                                        password:
                                        passwordController.text.trim(),
                                        confirmPassword:
                                        confirmPasswordController.text
                                            .trim()),
                                  );
                                });
                              },
                              child: CommonButton(
                                text: 'Sign Up',
                                color: AppColors.kL1GreenColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don’t have an account? ",
                            ),
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            context) => const LoginScreen()));
                              },
                              child: const Text(
                                "Sign In!",
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      );
    });
  }
}
