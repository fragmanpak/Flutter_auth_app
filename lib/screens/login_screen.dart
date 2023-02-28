import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zem_auth/common_widgets/common_button.dart';
import 'package:zem_auth/common_widgets/model_progress_hud.dart';
import 'package:zem_auth/common_widgets/my_text_field.dart';
import 'package:zem_auth/logic/auth_bloc/auth_bloc.dart';
import 'package:zem_auth/logic/models/auth_detail_model.dart';
import 'package:zem_auth/screens/reset_password.dart';
import 'package:zem_auth/screens/signup_screen.dart';
import 'package:zem_auth/screens/welcome_screen.dart';
import 'package:zem_auth/utils/app_colors.dart';
import 'package:zem_auth/utils/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final globalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  AuthenticationDetailModel? authenticationDetail;
  bool seePass = true;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          if (state.status == LoginStatus.success) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()));
          } else if (state.status == LoginStatus.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${state.errorMessage}')));
          }
        } else if (state is GoogleUserState) {
          if (state.status == GoogleStatus.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${state.errorMessage}')));
          } else if (state.status == GoogleStatus.success) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()));
          }
        } else if (state is FacebookUserState) {
          if (state.status == FacebookStatus.success) {
            debugPrint("facebook state ");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()));
          } else if (state.status == FacebookStatus.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${state.errorMessage}')));
          }
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.isLoginLoading! ||
              state.isGoogleLoading! ||
              state.isFacebookLoading!,
          dismissible: false,
          child: Scaffold(
            body: Form(
              key: globalKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            /// login text
                            ///
                            Text(
                              'Login',
                              style: AppTextStyles
                                  .kTextStyleTwentyWithBlackColor400,
                            ),
                            const SizedBox(height: 31),
                            const Text("Email"),
                            const SizedBox(height: 5),

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
                                if (state is LoginSuccessState) {
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
                            const SizedBox(height: 15),

                            /// password text and show text click
                            const Text("Password"),
                            const SizedBox(height: 5),

                            /// password input field
                            MyTextField(
                              focusNode: _passwordFocus,
                              controller: passwordController,
                              text: 'Input',
                              isObscure: seePass,
                              eyeIcon:
                                  const Icon(Icons.remove_red_eye_outlined),
                              onSuffixTap: () {
                                if (seePass == true) {
                                  setState(() {
                                    seePass = false;
                                  });
                                } else {
                                  setState(() {
                                    seePass = true;
                                  });
                                }
                              },
                            ),

                            /// password error text show bloc
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is LoginSuccessState) {
                                  return state.errorPassword != null &&
                                          state.errorPassword!.isNotEmpty
                                      ? Text(
                                          '${state.errorPassword}',
                                        )
                                      : const SizedBox();
                                }
                                return const SizedBox();
                              },
                            ),
                            const SizedBox(height: 5),

                            /// forget password click
                            GestureDetector(
                              onTap: (() {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ResetPassword(),
                                ));
                              }),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Forgot password?",
                                ),
                              ),
                            ),
                            const SizedBox(height: 29),

                            /// Login button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<AuthBloc>().add(
                                            LoginEvent(
                                              email:
                                                  emailController.text.trim(),
                                              password: passwordController.text
                                                  .trim(),
                                            ),
                                          );
                                    },
                                    child: CommonButton(
                                      text: 'Login',
                                      color: AppColors.greenTextColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                            const SizedBox(height: 21),

                            /// sign up button
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don’t have an account? "),
                                  InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpScreen()));
                                    },
                                    child: const Text("Sign up!"),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// click to create dynamic link
                            // Center(
                            //   child: InkWell(
                            //     onTap: () {
                            //       AppDynamicLink()
                            //           .createLink("45356g46")
                            //           .then((value) => Share.share(value));
                            //     },
                            //     child: CommonButton(
                            //         text: 'Get This app Link',
                            //         color: AppColors.kLemenLimeColor),
                            //   ),
                            // ),
                            const SizedBox(height: 20),

                            /// social medias
                            ///
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(GoogleAuthEventStart());
                                    },
                                    child: const CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                          'assets/images/google.png'),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(FacebookAuthEventStart());
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40,
                                      backgroundImage: AssetImage(
                                          'assets/images/facebook.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
