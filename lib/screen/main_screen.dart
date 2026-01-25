import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/app_sidebar.dart';
import 'package:brantaspinjam/screen/admin/alat/alat_screen.dart';
import 'package:brantaspinjam/screen/admin/kategori/kategori_screen.dart';
import 'package:brantaspinjam/screen/admin/denda/denda_screen.dart';
import 'package:brantaspinjam/screen/admin/user/user_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String activeMenu = "dashboard";

  String getAppBarTitle() {
    switch (activeMenu) {
      case "dashboard":
        return "Dashboard";
      case "user":
        return "Pengguna";
      case "alat":
        return "Alat";
      case "kategori":
        return "Kategori";
      case "denda":
        return "Denda";
      case "log":
        return "Log Aktivitas";
      default:
        return "Dashboard";
    }
  }

  Widget getActiveScreen() {
    switch (activeMenu) {
      case "alat":
        return const AlatScreen();

      case "dashboard":
        return const Center(child: Text("Dashboard"));

      case "user":
        return const UserScreen();

      case "kategori":
        return const KategoriScreen();

      case "denda":
        return const DendaScreen();

      case "log":
        return const Center(child: Text("Log Aktivitas"));

      default:
        return const Center(child: Text("Dashboard"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      drawer: AppSidebar(
        activeMenu: activeMenu,
        onMenuTap: (menu) {
          if (menu == "logout") {
            Navigator.pop(context);
            return;
          }

          setState(() => activeMenu = menu);
          Navigator.pop(context); 
        },
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.only(top: 56, left: 16, right: 16),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0E0A26),
            titleSpacing: 0,
            title: Text(
              getAppBarTitle(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B4376),
              ),
            ),
          ),
        ),
      ),
      body: getActiveScreen(),
    );
  }
}
