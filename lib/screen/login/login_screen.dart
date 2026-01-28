import 'package:flutter/material.dart';
import 'package:brantaspinjam/services/auth_service.dart';
import 'package:brantaspinjam/screen/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 170),

              const Center(
                child: Text(
                  "Brantas Pinjam",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B4376),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Masuk ke akun anda untuk melanjutkan",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              const Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),

              Center(
                child: SizedBox(
                  width: 376,
                  height: 62,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBABABA), width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _emailController, 
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text("Kata Sandi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),

              Center(
                child: SizedBox(
                  width: 376,
                  height: 62,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBABABA), width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _passwordController, 
                        obscureText: true,
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Center(
                child: SizedBox(
                  width: 356,
                  height: 67,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F9AAE),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: _isLoading ? null : _login, 
                    child: const Text(
                      "Masuk",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}