import 'package:flutter/material.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/widgets/app_sidebar.dart';
import 'package:brantaspinjam/services/auth_service.dart';
import 'package:brantaspinjam/services/user_session.dart';
import 'package:brantaspinjam/model/model_user.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';

// ADMIN
import 'package:brantaspinjam/screen/admin/alat/alat_screen.dart';
import 'package:brantaspinjam/screen/admin/kategori/kategori_screen.dart';
import 'package:brantaspinjam/screen/admin/denda/denda_screen.dart';
import 'package:brantaspinjam/screen/admin/user/user_screen.dart';
import 'package:brantaspinjam/screen/admin/peminjaman/peminjaman_screen.dart';
import 'package:brantaspinjam/screen/admin/log_aktivitas.dart';

//SEMUA
import 'package:brantaspinjam/screen/dashboard/dashboard_screen.dart';

// PETUGAS
import 'package:brantaspinjam/screen/petugas/peminjaman_screen.dart';
import 'package:brantaspinjam/screen/petugas/pengembalian_screen.dart';

// PEMINJAM
import 'package:brantaspinjam/screen/peminjam/peminjaman_list_screen.dart';
import 'package:brantaspinjam/screen/peminjam/pinjam_alat_screen.dart';

class MainScreen extends StatefulWidget {
  final UserRole role;

  const MainScreen({
    super.key,
    required this.role,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UserSessionService _sessionService = UserSessionService();
  late Future<UserModel> _userFuture;

  String activeMenu = 'dashboard';

  @override
  void initState() {
    super.initState();
    _userFuture = _sessionService.getCurrentUser();
  }

  //APP TITLE
  String getAppBarTitle() {
    switch (activeMenu) {
      case 'dashboard':
        return 'Dashboard';
      case 'user':
        return 'Pengguna';
      case 'peminjaman':
        return 'Peminjaman';
      case 'pengembalian':
        return 'Pengembalian';
      case 'pinjaman_saya':
        return 'Pinjaman Saya';
      case 'alat':
        return 'Alat';
      case 'kategori':
        return 'Kategori';
      case 'denda':
        return 'Denda';
      case 'log':
        return 'Log Aktivitas';
      default:
        return 'Dashboard';
    }
  }

  // ACTIVE SCREEN
  Widget getActiveScreen() {
    switch (activeMenu) {
      case 'dashboard':
        return DashboardScreen(role: widget.role);

      case 'user':
        return const UserScreen();

      case 'peminjaman':
        if (widget.role == UserRole.admin) {
          return const PeminjamanAdminScreen();
        }
        if (widget.role == UserRole.petugas) {
          return const PeminjamanPetugasScreen();
        }
        return const PinjamAlatScreen();

      case 'pengembalian':
        return const PengembalianPetugasScreen();

      case 'pinjaman_saya':
        return const PeminjamanListScreen();

      case 'alat':
        return const AlatScreen();

      case 'kategori':
        return const KategoriScreen();

      case 'denda':
        return const DendaScreen();

      case 'log':
        return const LogAktivitasScreen();

      default:
        return DashboardScreen(role: widget.role);
    }
  }

  // BUILD 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _userFuture,
      builder: (context, snapshot) {
        // LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ERROR
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final user = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),

          // SIDEBAR
          drawer: AppSidebar(
            role: widget.role,
            user: user, 
            activeMenu: activeMenu,
            onMenuTap: (menu) {
              if (menu == 'logout') {
                showDialog(
                  context: context,
                  builder: (dialogContext) => ConfirmActionPopup(
                    title: 'Konfirmasi Logout',
                    message: 'Apakah Anda yakin ingin keluar?',
                    confirmText: 'Logout',
                    onConfirm: () async {
                      Navigator.pop(dialogContext);
                      await AuthService().signOut();
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                );
                return;
              }

              setState(() => activeMenu = menu);
              Navigator.pop(context);
            },
          ),

          //APP BAR
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
      },
    );
  }
}
