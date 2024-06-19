import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:database_chat_app/screens/welcome_screen.dart';
import 'package:database_chat_app/screens/login_screen.dart';
import 'package:database_chat_app/screens/registration_screen.dart';
import 'package:database_chat_app/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const StockTradingApp());
}

class StockTradingApp extends StatelessWidget {
  const StockTradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        MainScreen.id: (context) => const MainScreen(),
      },
    );
  }
}
