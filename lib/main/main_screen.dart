import 'package:flutter/material.dart';
import 'package:brantaspinjam/screen/login/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String activeMenu = "login";

  String getAppBarTitle() {
    switch (activeMenu) {
      case "login":
        return "Login";
      case "dashboard":
        return "Dashboard";
      default:
        return "Brantas Pinjam";
    }
  }

  Widget getActiveScreen() {
    switch (activeMenu) {
      case "login":
        return const LoginScreen();

      // nanti tinggal tambah:
      // case "dashboard":
      //   return DashboardScreen();

      default:
        return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getAppBarTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: getActiveScreen(),
    );
  }
}
