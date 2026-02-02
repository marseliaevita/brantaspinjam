import 'package:flutter/material.dart';

class CardUser extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback? onEdit;
  final VoidCallback? onDisable;
  final bool isActive;

  const CardUser({
    super.key,
    required this.name,
    required this.role,
    this.onEdit,
    this.onDisable,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor = isActive ? const Color(0xFF0E0A26) : Colors.grey;
    final Color cardBg = isActive
        ? const Color(0xFFDBDFEA).withOpacity(0.5)
        : Colors.grey.withOpacity(0.2);
    return Stack(
      children: [
        // MAIN CARD
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: mainColor, width: 1),
          ),
          child: Row(
            children: [
              // PROFILE
              Container(
                height: 76,
                width: 76,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // NAME + ROLE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: mainColor,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      isActive ? role : "$role (Nonaktif)",
                      style: TextStyle(
                        fontSize: 20,
                        color: mainColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // EDIT
        if (onEdit != null)
          Positioned(
            top: 20,
            right: 50,
            child: GestureDetector(
              onTap: onEdit,
              child: _iconCircle(Icons.edit),
            ),
          ),

        // DISABLE
        if (onDisable != null)
          Positioned(
            top: 20,
            right: 10,
            child: GestureDetector(
              onTap: onDisable,
              child: _iconCircle(Icons.block),
            ),
          ),
      ],
    );
  }
}

// HELPER

Widget _iconCircle(IconData icon) {
  return Container(
    width: 30,
    height: 30,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: 20, color: Color(0xFF0E0A26)),
  );
}
