import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColor: const Color(0xFF1D2F6F),
  colorScheme: const ColorScheme.light(secondary: Color(0xFF797B84), primary: const Color(0xFFEBEBEB)  ),
  scaffoldBackgroundColor: const Color(0xFFEBEBEB),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF1D2F6F),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),


  ),
);