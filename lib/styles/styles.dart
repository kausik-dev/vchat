import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VStyle {
  static const primaryBlue = Color(0xff005FFF);
  static const darkBlack = Color(0xff070A0D);
  static const darkgrey = Color(0xff101418);
  static const white = Color(0xffFFFFFF);
  static const lightGrey = Color(0xffF2F2F2);

  static ThemeData darkTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: darkgrey, elevation: 1),
      backgroundColor: darkBlack,
      scaffoldBackgroundColor: darkBlack,
      primaryColor: primaryBlue,
      textTheme: TextTheme(
        headline1: GoogleFonts.inter(fontSize: 16, color: white),
      ),
      iconTheme: const IconThemeData(color: white),
      canvasColor: darkgrey
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.white, elevation: 1),
      backgroundColor: white,
      scaffoldBackgroundColor: white,
      primaryColor: primaryBlue,
      textTheme: TextTheme(
        headline1: GoogleFonts.inter(fontSize: 16, color: darkBlack),
      ),
      iconTheme: const IconThemeData(color: darkBlack),
      canvasColor: lightGrey
    );
  }

   
}
