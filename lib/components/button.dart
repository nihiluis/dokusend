import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: switch (variant) {
          ButtonVariant.primary => theme.colorScheme.primary,
          ButtonVariant.secondary || ButtonVariant.outline => Colors.transparent,
        },
        foregroundColor: switch (variant) {
          ButtonVariant.primary => theme.colorScheme.onPrimary,
          ButtonVariant.secondary || ButtonVariant.outline => theme.colorScheme.primary,
        },
        side: switch (variant) {
          ButtonVariant.outline => BorderSide(color: theme.colorScheme.primary),
          _ => null,
        },
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: variant == ButtonVariant.primary
                    ? theme.colorScheme.onPrimary 
                    : theme.colorScheme.primary,
              ),
            )
          : Text(text),
    );
  }
}