import 'package:flutter/material.dart';

const Color authPrimaryColor = Color(0xFF5CC8CC);
const Color authLightCyan = Color(0xFFC8F1F3);
const Color authTextColor = Color(0xFF202124);

/// Dekorasi input yang dipakai di halaman login & lupa kata sandi.
InputDecoration authInputDecoration({
  required String label,
  required IconData icon,
  Widget? suffix,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );

  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: authPrimaryColor),
    suffixIcon: suffix,
    filled: true,
    fillColor: const Color(0xFFF6FBFB),
    contentPadding: const EdgeInsets.symmetric(vertical: 16),
    border: border(Colors.transparent),
    enabledBorder: border(authLightCyan),
    focusedBorder: border(authPrimaryColor, 1.6),
    errorBorder: border(Colors.redAccent),
    focusedErrorBorder: border(Colors.redAccent, 1.6),
  );
}
