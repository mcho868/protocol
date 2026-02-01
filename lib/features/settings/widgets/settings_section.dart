import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget child;

  const SettingsSection({
    super.key,
    required this.title,
    required this.child,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            if (actionText != null && onAction != null)
              TextButton(
                onPressed: onAction,
                child: Text(actionText!, style: const TextStyle(color: Colors.black)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
