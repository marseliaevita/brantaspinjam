import 'package:flutter/material.dart';
import 'package:brantaspinjam/shared/enums.dart';

class AppSidebar extends StatelessWidget {
  final UserRole role;
  final String activeMenu;
  final Function(String) onMenuTap;

  const AppSidebar({
    super.key,
    required this.role,
    required this.activeMenu,
    required this.onMenuTap,
  });

  static List<Map<String, dynamic>> getMenusByRoleStatic(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return [
          _menu(Icons.dashboard_rounded, 'Dashboard', 'dashboard'),
          _menu(Icons.people_rounded, 'Pengguna', 'user'),
          _menu(Icons.inventory_2_rounded, 'Peminjaman', 'peminjaman'),
          _menu(Icons.inventory_2_rounded, 'Alat', 'alat'),
          _menu(Icons.category_rounded, 'Kategori', 'kategori'),
          _menu(Icons.payments_rounded, 'Denda', 'denda'),
          _menu(Icons.receipt_long_rounded, 'Log Aktivitas', 'log'),
          _menu(Icons.logout_rounded, 'Logout', 'logout'),
        ];
      case UserRole.petugas:
        return [
          _menu(Icons.dashboard_rounded, 'Dashboard', 'dashboard'),
          _menu(Icons.inventory_2_rounded, 'Peminjaman', 'peminjaman'),
          _menu(Icons.assignment_return_rounded, 'Pengembalian', 'pengembalian'),
          _menu(Icons.logout_rounded, 'Logout', 'logout'),
        ];
      case UserRole.peminjam:
        return [
          _menu(Icons.dashboard_rounded, 'Dashboard', 'dashboard'),
          _menu(Icons.inventory_2_rounded, 'Peminjaman', 'peminjaman'),
          _menu(Icons.list_alt_rounded, 'Pinjaman Saya', 'pinjaman_saya'),
          _menu(Icons.logout_rounded, 'Logout', 'logout'),
        ];
    }
  }

  static Map<String, dynamic> _menu(
    IconData icon,
    String title,
    String key,
  ) {
    return {
      'icon': icon,
      'title': title,
      'key': key,
    };
  }

  String getInitial() {
  return role.name[0].toUpperCase();
}


  @override
  Widget build(BuildContext context) {
    final menus = AppSidebar.getMenusByRoleStatic(role);


    return Drawer(
      width: 260,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFDBDFEA),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // PROFILE 
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8294C4),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        getInitial(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B4376),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dummy User',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
  role.name.toUpperCase(),
  style: const TextStyle(
    fontSize: 12,
    color: Color.fromRGBO(255, 255, 255, 0.84),
  ),
),

                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MENU 
              ...menus.map(
                (menu) => _menuItem(
                  icon: menu['icon'],
                  title: menu['title'],
                  menuKey: menu['key'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MENU ITEM 
  Widget _menuItem({
    required IconData icon,
    required String title,
    required String menuKey,
  }) {
    final bool isActive = activeMenu == menuKey;

    return GestureDetector(
      onTap: () => onMenuTap(menuKey),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF8294C4)
              : const Color.fromRGBO(255, 255, 255, 0.84),
          borderRadius: BorderRadius.circular(24),
          border: isActive
              ? null
              : Border.all(
                  color: const Color.fromRGBO(75, 67, 118, 0.84),
                  width: 1,
                ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF4B4376),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : const Color(0xFF4B4376),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
