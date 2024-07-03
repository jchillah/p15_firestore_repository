import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p15_firestore_repository/src/data/database_repository.dart';
import 'package:p15_firestore_repository/src/data/firebase_auth.dart';
import 'package:p15_firestore_repository/src/features/authentication/application/validators.dart';
import 'package:p15_firestore_repository/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:p15_firestore_repository/src/features/main_screen/presentation/main_screen.dart';

class LoginScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;

  const LoginScreen({
    super.key,
    required this.databaseRepository,
    required this.authRepository,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _pwController;
  bool showPassword = false;
  bool isLoading = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _pwController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      if (_emailController.text.isEmpty || _pwController.text.isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-input',
          message: 'Email und Passwort dürfen nicht leer sein.',
        );
      }

      await widget.authRepository.loginWithEmailAndPassword(
        _emailController.text,
        _pwController.text,
      );

      // Navigiere zum MainScreen nach erfolgreichem Login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainScreen(
            databaseRepository: widget.databaseRepository,
            authRepository: widget.authRepository,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'empty-input':
            errorText = 'Email und Passwort dürfen nicht leer sein.';
            break;
          case 'invalid-email':
            errorText = 'Ungültige Email-Adresse.';
            break;
          case 'user-not-found':
          case 'wrong-password':
            errorText = 'Ungültige Email oder Passwort.';
            break;
          default:
            errorText = 'Ein Fehler ist aufgetreten. Bitte versuche es erneut.';
        }
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              children: [
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorText!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                TextFormField(
                  controller: _emailController,
                  validator: validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    icon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pwController,
                  validator: validatePw,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Passwort",
                    icon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: showPassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isLoading ? null : _signInWithEmailAndPassword,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Login"),
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(
                          databaseRepository: widget.databaseRepository,
                          authRepository: widget.authRepository,
                        ),
                      ),
                    );
                  },
                  child: const Text("Noch keinen Account? Zur Registrierung"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
