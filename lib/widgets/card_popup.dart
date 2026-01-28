import 'package:flutter/material.dart';

class CardPopup extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Widget content;
  final String submitText;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const CardPopup({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.content,
    required this.submitText,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF89A8B2),
              width: 3,
            ),
          ),
          child: Column(
            children: [
              // JUDUL
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              // CONTENT
              Expanded(child: content),

              const SizedBox(height: 12),

              // BUTTON
              Padding(
                padding: const EdgeInsets.only(left: 18), 
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onCancel,
                      child: _popupButton(
                        text: 'Batal',
                        opacity: 0.42,
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: onSubmit,
                      child: _popupButton(
                        text: submitText,
                        opacity: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BUTTON
Widget _popupButton({
  required String text,
  required double opacity,
}) {
  return Opacity(
    opacity: opacity,
    child: Container(
      width: 112,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF432E54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}


//POPUP TEXT BUTTON
class ConfirmActionPopup extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;

  const ConfirmActionPopup({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CardPopup(
      title: title,
      width: 350,
      height: 232,
      submitText: confirmText,
      onCancel: () => Navigator.pop(context),
      onSubmit: () {
        onConfirm();
        Navigator.pop(context);
      },
      content: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF0E0A26),
          ),
        ),
      ),
    );
  }
}