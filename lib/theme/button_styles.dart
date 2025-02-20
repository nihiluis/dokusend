import 'package:flutter/material.dart';

class AppButtonStyles {
  static ButtonStyle primaryButton(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      minimumSize: const Size(200, 50),
    );
  }
} 