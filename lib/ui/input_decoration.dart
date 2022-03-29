import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String hint, required String label, IconData? icon}) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primary)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primary, width: 2)),
        hintText: hint,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: AppTheme.primary,
              )
            : null);
  }
}
