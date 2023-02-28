import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zem_auth/logic/auth_bloc/auth_bloc.dart';
import 'package:zem_auth/logic/repository/authentication_repository_impl.dart';
import 'package:zem_auth/screens/login_screen.dart';
import 'package:zem_auth/utils/app_dynamic_link.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDynamicLink().initDynamicLinks;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationRepositoryImpl(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              repository: AuthenticationRepositoryImpl(),
            )..add(AuthStarted()),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
