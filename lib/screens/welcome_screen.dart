import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zem_auth/logic/auth_bloc/auth_bloc.dart';

import '../common_widgets/model_progress_hud.dart';
import '../logic/repository/repository.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final Repository repository;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        } else if (state is LogoutFailState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${state.message}')));
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: state is LogoutLoadingState,
        dismissible: false,
        child: Scaffold(
          appBar: AppBar(title: const Text('Welcome Screen'), actions: [
            IconButton(
              onPressed: () async {
                context.read<AuthBloc>().add(FirebaseAuthExitedState());
              },
              icon: const Icon(Icons.logout_outlined),
            ),
          ]),
          body: Center(
            child: state is LoginSuccessState
                ? const Text('Login success')
                : state is GoogleUserState
                    ? Column(
                        children: [
                          Text(state.authenticationDetail!.displayName!),
                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add((GoogleAuthExitedState()));
                            },
                            child: const Text('Logout Google'),
                          ),
                        ],
                      )
                    : state is FacebookUserState
                        ? Column(
                            children: [
                              Text(state.authenticationDetail!.displayName!),
                              const SizedBox(height: 50),
                              ElevatedButton(
                                onPressed: () {
                                  FacebookAuthExitedState();
                                },
                                child: const Text('Logout facebook'),
                              ),
                            ],
                          )
                        : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
