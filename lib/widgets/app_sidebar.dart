import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brantaspinjam/services/supabase_config.dart';

class AppSidebar extends StatefulWidget {
  final String activeMenu;
  final Function(String) onMenuTap;

  const AppSidebar({
    super.key,
    required this.activeMenu,
    required this.onMenuTap,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final SupabaseClient _client = SupabaseConfig.client;

  String name = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

Future<void> _loadUserProfile() async {
  try {
    final user = _client.auth.currentUser;
    if (user == null) return;

    
    final List<dynamic> result = await _client
        .from('users')
        .select('name, role')
        .eq('user_id', user.id)
        .limit(1);

    if (result.isNotEmpty) {
      final data = result.first as Map<String, dynamic>;
      setState(() {
        name = data['name'] ?? '';
        role = data['role'] ?? '';
      });
    } else {
      setState(() {
        name = '';
        role = '';
      });
    }
  } catch (e) {
    print('Error load user profile: $e');
    setState(() {
      name = '';
      role = '';
    });
  }
}


  String getInitial() {
    if (name.isEmpty) return 'U';
    return name[0].toUpperCase();
  }
  @override
  Widget build(BuildContext context) {
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
                    // avatar
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
                        Text(
                          name.isEmpty ? 'Loading...' : name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          role,
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
              _menuItem(
                icon: Icons.dashboard_rounded,
                title: "Dashboard",
                menuKey: "dashboard",
              ),
              _menuItem(
                icon: Icons.people_rounded,
                title: "Pengguna",
                menuKey: "user",
              ),
              _menuItem(
                icon: Icons.inventory_2_rounded,
                title: "Alat",
                menuKey: "alat",
              ),
              _menuItem(
                icon: Icons.category_rounded,
                title: "Kategori",
                menuKey: "kategori",
              ),
              _menuItem(
                icon: Icons.payments_rounded,
                title: "Denda",
                menuKey: "denda",
              ),
              _menuItem(
                icon: Icons.receipt_long_rounded,
                title: "Log Aktivitas",
                menuKey: "log",
              ),
              _menuItem(
                icon: Icons.logout_rounded,
                title: "Logout",
                menuKey: "logout",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String menuKey,
  }) {
    final bool isActive = widget.activeMenu == menuKey;

    return GestureDetector(
      onTap: () => widget.onMenuTap(menuKey),
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
