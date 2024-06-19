import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:database_chat_app/screens/main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  late String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Your Email',
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Your Password',
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  username = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Your Username',
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Update user's display name with username
                    await newUser.user!.updateDisplayName(username);

                    // Navigate to your desired screen after successful registration
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const MainScreen(); // Replace with your screen
                        },
                      ),
                    );

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    // print('Error: $e');
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
