import 'package:flutter/material.dart';
import 'package:brantaspinjam/services/user_service.dart';
import 'package:brantaspinjam/widgets/card_popup.dart';

class UserAddEdit extends StatefulWidget {
  final Map<String, dynamic>? user;

  const UserAddEdit({super.key, this.user});

  @override
  State<UserAddEdit> createState() => _UserAddEditState();
}

class _UserAddEditState extends State<UserAddEdit> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController roleController;

  bool get isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.user?['email'] ?? '');
    passwordController = TextEditingController();
    nameController = TextEditingController(text: widget.user?['name'] ?? '');
    roleController = TextEditingController(text: widget.user?['role'] ?? '');
  }

  Future<void> _submit() async {
    try {
      final service = UserService();

      if (isEdit) {
        await service.updateUser(
          widget.user!['user_id'],
          nameController.text,
          roleController.text,
        );
      } else {
        await service.createUser(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          role: roleController.text,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => ConfirmActionPopup(
          title: 'Gagal',
          message: e.toString().replaceAll('Exception:', ''),
          confirmText: 'OK',
          onConfirm: () => Navigator.pop(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: isEdit ? 'Edit Pengguna' : 'Tambah Pengguna',
      width: 350,
      height: 498,
      submitText: isEdit ? 'Update' : 'Simpan',
      onCancel: () => Navigator.pop(context),
      onSubmit: _submit,

      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEdit) ...[
                _label('Email'),
                _textField(width: 257, controller: emailController),
                const SizedBox(height: 14),

                _label('Password'),
                _textField(
                  width: 257,
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
              ],

              _label('Nama'),
              _textField(width: 257, controller: nameController),
              const SizedBox(height: 14),

              _label('Posisi'),
              SizedBox(
                width: 257,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: roleController.text.isEmpty
                      ? 'peminjam'
                      : roleController.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF4B4376),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF4B4376),
                        width: 1.5,
                      ),
                    ),
                  ),
                  items: ['admin', 'petugas', 'peminjam'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      roleController.text = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET

  Widget _textField({
    required double width,
    TextEditingController? controller,
    bool enabled = true,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: width,
      height: 48,
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4B4376), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4B4376), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, color: Color(0xFF0E0A26)),
      ),
    );
  }
}
