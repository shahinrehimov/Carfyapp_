import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color confirmColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.confirmColor = const Color(0xFFF6683C),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: 370,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF242323),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  // Confirm (destructive) button
                  Expanded(
                    child: _OutlinedColorButton(
                      text: confirmText,
                      color: confirmColor,
                      onTap: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Cancel button
                  Expanded(
                    child: _GradientButton(
                      text: cancelText,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String confirmText,
  required String cancelText,
  required VoidCallback onConfirm,
  Color confirmColor = const Color(0xFFF6683C),
}) {
  return showDialog(
    context: context,
    builder: (_) => ConfirmationDialog(
      title: title,
      description: description,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      confirmColor: confirmColor,
    ),
  );
}

class _OutlinedColorButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _OutlinedColorButton({required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GradientButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3696E7), Color(0xFF00569C)],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
