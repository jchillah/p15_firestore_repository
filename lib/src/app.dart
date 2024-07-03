import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p15_firestore_repository/src/data/database_repository.dart';
import 'package:p15_firestore_repository/src/data/firebase_auth.dart';
import 'package:p15_firestore_repository/src/features/authentication/presentation/login_screen.dart';
import 'package:p15_firestore_repository/src/features/main_screen/presentation/main_screen.dart';


class App extends StatelessWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const App(
      {super.key,
      required this.databaseRepository,
      required this.authRepository});

  @override
  Widget build(BuildContext context) {
    const loginKey = ValueKey('loginScreen');
    const mainKey = ValueKey('MainScreen');

    return StreamBuilder(
        stream: authRepository.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          final user = snapshot.data;
          return MaterialApp(
            key: user == null ? loginKey : mainKey,
            home: user == null
                ? LoginScreen(
                    databaseRepository: databaseRepository,
                    authRepository: authRepository,
                  )
                : MainScreen(
                    databaseRepository: databaseRepository,
                    authRepository: authRepository),
          );
        });
  }
}
