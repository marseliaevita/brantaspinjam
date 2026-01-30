import 'package:flutter/material.dart';
import 'package:brantaspinjam/screen/login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF8294C4),
                Color(0xFFDBDFEA),
              ],
            ),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 200,
            ),
          ),
        ),
      ),
    );
  }
}
