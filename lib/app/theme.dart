import 'package:flutter/material.dart';

class AppTheme {
  // Tekrar nesne oluşturulmasını engellemek için
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: false,
    fontFamily: 'Montserrat',
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF246BFD), // Daha modern, tok bir mavi (Royal Blue)
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFFF5F6F8), // Çok hafif gri, kartlar için
      secondary: Color(
        0xFF1F1D2B,
      ), // Siyah yerine koyu lacivert (Dark theme bg)
      onSecondary: Color(0xFF9CA4AB), // Gri metinler için
      tertiary: Color(0xFF07BD74), // Canlı yeşil
      error: Color(0xFFFF3B30), // Modern kırmızı
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF1F1D2B)),
      displayMedium: TextStyle(color: Color(0xFF1F1D2B)),
      displaySmall: TextStyle(color: Color(0xFF1F1D2B)),
      headlineLarge: TextStyle(color: Color(0xFF1F1D2B)),
      headlineMedium: TextStyle(color: Color(0xFF1F1D2B)),
      headlineSmall: TextStyle(color: Color(0xFF1F1D2B)),
      titleLarge: TextStyle(color: Color(0xFF1F1D2B)),
      titleMedium: TextStyle(color: Color(0xFF1F1D2B)),
      titleSmall: TextStyle(color: Color(0xFF1F1D2B)),
      bodyLarge: TextStyle(color: Color(0xFF1F1D2B)),
      bodyMedium: TextStyle(color: Color(0xFF1F1D2B)),
      bodySmall: TextStyle(color: Color(0xFF9CA4AB)),
      labelLarge: TextStyle(color: Color(0xFF1F1D2B)),
      labelMedium: TextStyle(color: Color(0xFF9CA4AB)),
      labelSmall: TextStyle(color: Color(0xFF9CA4AB)),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: Color(0xFF1F1D2B)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      unselectedIconTheme: IconThemeData(
        // Seçili olmayan ikon rengi
        color: Colors.grey[500], // Daha soluk gri
        size: 24,
      ),
      selectedLabelStyle: TextStyle(
        // Seçili yazı stili
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: false,
    fontFamily: 'Montserrat',
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF246BFD), // Light theme ile uyumlu modern mavi
      surface: Color(0xFF1F1D2B), // Dark theme ana arkaplan
      onSurface: Color(0xFF252836), // Kartlar ve ayrıştırıcı alanlar
      secondary: Color(0xFFFFFFFF), // Beyaz metinler
      onSecondary: Color(0xFF9CA4AB), // Gri metinler
      tertiary: Color(0xFF07BD74), // Canlı yeşil
      error: Color(0xFFFF3B30), // Modern kırmızı
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFFFFFFFF)),
      displayMedium: TextStyle(color: Color(0xFFFFFFFF)),
      displaySmall: TextStyle(color: Color(0xFFFFFFFF)),
      headlineLarge: TextStyle(color: Color(0xFFFFFFFF)),
      headlineMedium: TextStyle(color: Color(0xFFFFFFFF)),
      headlineSmall: TextStyle(color: Color(0xFFFFFFFF)),
      titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
      titleMedium: TextStyle(color: Color(0xFFFFFFFF)),
      titleSmall: TextStyle(color: Color(0xFFFFFFFF)),
      bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
      bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
      bodySmall: TextStyle(color: Color(0xFF9CA4AB)),
      labelLarge: TextStyle(color: Color(0xFFFFFFFF)),
      labelMedium: TextStyle(color: Color(0xFF9CA4AB)),
      labelSmall: TextStyle(color: Color(0xFF9CA4AB)),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: Color(0xFFFFFFFF)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFEEEEEE), // Tüm Icon widget'ları için renk
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[900],
      unselectedIconTheme: IconThemeData(
        // Seçili olmayan ikon rengi
        color: Colors.grey[500], // Daha soluk gri
        size: 24,
      ),
      selectedLabelStyle: TextStyle(
        // Seçili yazı stili
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ), // Dark theme için daha uygun koyu renk
    ),
    scaffoldBackgroundColor: Color(
      0xFF1F1D2B,
    ), // Dark theme için standart arkaplan
  );
}
