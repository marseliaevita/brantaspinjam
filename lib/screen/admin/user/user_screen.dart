import 'package:flutter/material.dart';
import 'package:brantaspinjam/widgets/card_cariadd.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';
import 'package:brantaspinjam/widgets/card_user.dart';
import 'package:brantaspinjam/screen/admin/user/user_add_edit.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String searchQuery = "";

  final List<Map<String, dynamic>> userList = [
    {'nama': 'Marselia', 'role': 'Admin'},
    {'nama': 'Andi', 'role': 'Petugas'},
    {'nama': 'Sinta', 'role': 'Petugas'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUser = userList.where((user) {
      return user['nama'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // SEARCH
          SearchCard(
            hint: "Cari user",
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // ADD 
          AddButtonCard(
            title: "Tambah User",
            onTap: () {
              showDialog(context: context, builder: (_) => const UserAddEdit());
            },
          ),

          const SizedBox(height: 16),

          // LIST 
          Expanded(
            child: filteredUser.isEmpty
                ? const Center(child: Text("User tidak ditemukan"))
                : ListView.separated(
                    itemCount: filteredUser.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = filteredUser[index];

                      return CardUser(
                        name: user['nama'],
                        role: user['role'],

                        //EDIT
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (_) => UserAddEdit(user: user),
                          );
                        },

                        //DISABLE
                        onDisable: () {
                          showDialog(
                            context: context,
                            builder: (_) => ConfirmActionPopup(
                              title: "Nonaktifkan Akun",
                              message: "Anda yakin menonaktifkan akun ini?",
                              confirmText: "Nonaktifkan",
                              onConfirm: () {
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
