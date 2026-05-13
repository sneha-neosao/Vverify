import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme { light, dark }

extension ThemeDataExtension on AppTheme {
  ThemeData get themeData {
    switch (this) {
      case AppTheme.light:
        return ThemeData.light().copyWith(
          primaryTextTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
          canvasColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.black),
          primaryColor: const Color(0xFFEE3B27),
          primaryColorLight: const Color(0xFFFEC051),
          primaryColorDark: const Color(0xFFFBA749),
          scaffoldBackgroundColor: const Color(0xFFF8F8F8),
          cardColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.5),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF8F8F8),
            foregroundColor: Colors.black,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            elevation: 0,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.transparent, //
            backgroundColor: Colors.transparent, // what you want
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: Colors.transparent,
          )),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: GoogleFonts.heebo(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            labelStyle: GoogleFonts.heebo(
              fontSize: 16,
              color: Colors.black, // Set the color for label text here
              fontWeight: FontWeight.w400,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEE3B27),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFEE3B27),
          ),
          textTheme: TextTheme(
              bodyLarge: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              bodySmall: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              bodyMedium: GoogleFonts.heebo(
                color: Colors.grey.shade700,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              titleLarge: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
              titleMedium: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              titleSmall: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
        );

      case AppTheme.dark:
        return ThemeData.light().copyWith(
          primaryTextTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
          canvasColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.black),
          primaryColor: const Color(0xFFEE3B27),
          primaryColorLight: const Color(0xFFFEC051),
          primaryColorDark: const Color(0xFFFBA749),
          scaffoldBackgroundColor: const Color(0xFFF8F8F8),
          cardColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.5),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF8F8F8),
            foregroundColor: Colors.black,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            elevation: 0,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.transparent, //
            backgroundColor: Colors.transparent, // what you want
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: Colors.transparent,
          )),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: GoogleFonts.heebo(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            labelStyle: GoogleFonts.heebo(
              fontSize: 16,
              color: Colors.black, // Set the color for label text here
              fontWeight: FontWeight.w400,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEE3B27),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFEE3B27),
          ),
          textTheme: TextTheme(
              bodyLarge: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              bodySmall: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              bodyMedium: GoogleFonts.heebo(
                color: Colors.grey.shade700,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              titleLarge: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
              titleMedium: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              titleSmall: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
        );
      // case AppTheme.dark:
      //   return ThemeData.dark().copyWith(
      //     primaryTextTheme:
      //         const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      //     iconTheme: const IconThemeData(color: Colors.white),
      //     focusColor: Colors.white,
      //     canvasColor: Colors.white,
      //     primaryColor: const Color(0xFFEE3B27),
      //     primaryColorLight: const Color(0xFFFEC051),
      //     primaryColorDark: const Color(0xFFFBA749),
      //     scaffoldBackgroundColor: const Color(0xFF373737),
      //     cardColor: const Color(0xFF343434),
      //     shadowColor: const Color(0xff121212).withOpacity(0.5),
      //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      //     appBarTheme: const AppBarTheme(
      //       backgroundColor: Color(0xFF373737),
      //       foregroundColor: Colors.white,
      //       titleTextStyle: TextStyle(
      //         color: Colors.white,
      //         fontSize: 22,
      //         fontWeight: FontWeight.w600,
      //       ),
      //       elevation: 0,
      //     ),
      //     elevatedButtonTheme: ElevatedButtonThemeData(
      //       style: ElevatedButton.styleFrom(
      //         foregroundColor: Colors.white,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(12),
      //         ),
      //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      //         backgroundColor: const Color(0xFFEE3B27),
      //       ),
      //     ),
      //     inputDecorationTheme: InputDecorationTheme(
      //       hintStyle: GoogleFonts.heebo(
      //         fontSize: 16,
      //         color: Colors.white,
      //         fontWeight: FontWeight.w400,
      //       ),
      //       labelStyle: GoogleFonts.heebo(
      //         fontSize: 16,
      //         color: Colors.white, // Set the color for label text here
      //         fontWeight: FontWeight.w400,
      //       ),
      //       border: const OutlineInputBorder(
      //         borderSide: BorderSide(width: 1, color: Colors.white),
      //         borderRadius: BorderRadius.all(Radius.circular(8)),
      //       ),
      //       filled: true,
      //       fillColor: const Color(0xFF333333),
      //     ),
      //     textButtonTheme: TextButtonThemeData(
      //       style: TextButton.styleFrom(
      //         foregroundColor: const Color(0xFFEE3B27),
      //       ),
      //     ),
      //     floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //       backgroundColor: Color(0xFFEE3B27),
      //     ),
      //     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //       backgroundColor: Color(0xFF1A1A1A),
      //       selectedItemColor: Color(0xFFEE3B27),
      //       unselectedItemColor: Colors.white,
      //     ),
      //     bottomSheetTheme: const BottomSheetThemeData(
      //       surfaceTintColor: Colors.transparent, //
      //       backgroundColor: Colors.transparent, // what you want
      //     ),
      //     textTheme: TextTheme(
      //         bodyLarge: GoogleFonts.outfit(
      //           color: Colors.white,
      //           fontSize: 16,
      //           fontWeight: FontWeight.w700,
      //         ),
      //         bodySmall: GoogleFonts.outfit(
      //           color: Colors.white,
      //           fontSize: 14,
      //           fontWeight: FontWeight.w500,
      //         ),
      //         bodyMedium: GoogleFonts.outfit(
      //           color: Colors.grey.shade200,
      //           fontSize: 15,
      //           fontWeight: FontWeight.w500,
      //         ),
      //         titleLarge: GoogleFonts.outfit(
      //           color: Colors.white,
      //           fontSize: 32,
      //           fontWeight: FontWeight.w700,
      //         ),
      //         titleMedium: GoogleFonts.outfit(
      //           color: Colors.white,
      //           fontSize: 24,
      //           fontWeight: FontWeight.w700,
      //         )),
      //   );
    }
  }
}
