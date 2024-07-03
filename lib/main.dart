import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:p15_firestore_repository/firebase_options.dart';
import 'package:p15_firestore_repository/src/app.dart';
import 'package:p15_firestore_repository/src/data/firebase_auth.dart';
import 'package:p15_firestore_repository/src/data/firebase_repository.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirestoreDatabase databaseRepository =
      FirestoreDatabase(FirebaseFirestore.instance);
  AuthRepository authRepository = AuthRepository(FirebaseAuth.instance);

  runApp(App(
    databaseRepository: databaseRepository,
    authRepository: authRepository,
  ));
}
