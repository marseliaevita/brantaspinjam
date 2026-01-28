import 'package:flutter/material.dart';
import 'package:brantaspinjam/shared/enums.dart';
import 'package:brantaspinjam/shared/colors.dart';

class StatusBadge extends StatelessWidget {
  final PeminjamanStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
