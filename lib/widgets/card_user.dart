import 'package:flutter/material.dart';

class CardUser extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback? onEdit;
  final VoidCallback? onDisable;

  const CardUser({
    super.key,
    required this.name,
    required this.role,
    this.onEdit,
    this.onDisable,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // MAIN CARD
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFDBDFEA).withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF0E0A26),
              width: 1,
            ),
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
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E0A26),
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
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E0A26),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 20,
                        color:
                            const Color(0xFF0E0A26).withOpacity(0.7),
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
    child: Icon(
      icon,
      size: 20,
      color: Color(0xFF0E0A26),
    ),
  );
}
