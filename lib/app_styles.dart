import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static const Color backgroundColor = Color(0xFF121212); // Dark charcoal gray
  static const Color cardColor = Color(0xFF1E1E1E); // Slightly lighter dark gray
  static const Color inputColor = Color(0xFF2C2C2C); // Dark gray for input fields
  static const Color accentColor = Color(0xFFD17842); // Warm orange accent
  static const Color textColor = Colors.white;

  static TextStyle appBarTextStyle = GoogleFonts.poppins(fontSize: 20, color: textColor);
  static TextStyle buttonTextStyle = GoogleFonts.poppins(fontSize: 18);
  static TextStyle inputTextStyle = TextStyle(color: textColor, fontSize: 16);
  static TextStyle hintTextStyle = TextStyle(color: Colors.grey[500]);

  static BoxDecoration inputBoxDecoration = BoxDecoration(
    color: inputColor,
    borderRadius: BorderRadius.circular(12),
  );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: accentColor,
    foregroundColor: Colors.white,
    elevation: 6,
  );
}
