import 'package:flutter/material.dart';

//SEARCH CARD 
class SearchCard extends StatelessWidget {
  final Function(String) onChanged;
  final String hint;
  final double? width;

  const SearchCard({
    super.key,
    required this.onChanged,
    this.hint = "Cari data",
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, 
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF8294C4).withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF8294C4),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 24,
            color: Color(0xFF4B4376),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(
                color: Color(0xFF4B4376), 
                fontSize: 16,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF4B4376),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//ADD BUTTON 
class AddButtonCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;

  const AddButtonCard({
    super.key,
    required this.onTap,
    required this.title,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 395,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF4B4376),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
