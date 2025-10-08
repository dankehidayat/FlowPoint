// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/sensor_provider.dart';
import 'view/screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Key to force rebuild when theme changes without losing state
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => SensorProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final bool useMaterialYou = themeProvider.useMaterialYou;

          // For devices that support dynamic color (Android 12+)
          if (useMaterialYou) {
            return DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
                ColorScheme lightColorScheme;
                ColorScheme darkColorScheme;

                if (lightDynamic != null && darkDynamic != null) {
                  // Use the dynamic color scheme from the system
                  lightColorScheme = lightDynamic;
                  darkColorScheme = darkDynamic;
                } else {
                  // Fallback to seeded color scheme if dynamic colors aren't available
                  lightColorScheme = ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.light,
                  );
                  darkColorScheme = ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.dark,
                  );
                }

                return _buildMaterialApp(
                  themeProvider,
                  lightColorScheme,
                  darkColorScheme,
                  useMaterialYou,
                );
              },
            );
          } else {
            // Use Material 3 with fixed colors when Material You is disabled
            final lightColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            );
            
            final darkColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            );

            return _buildMaterialApp(
              themeProvider,
              lightColorScheme,
              darkColorScheme,
              useMaterialYou,
            );
          }
        },
      ),
    );
  }

  Widget _buildMaterialApp(
    ThemeProvider themeProvider,
    ColorScheme lightColorScheme,
    ColorScheme darkColorScheme,
    bool useMaterialYou,
  ) {
    return MaterialApp(
      key: _navigatorKey, // Use key to maintain state during theme changes
      title: 'FlowPoint',
      theme: _buildThemeData(lightColorScheme, useMaterialYou, Brightness.light),
      darkTheme: _buildThemeData(darkColorScheme, useMaterialYou, Brightness.dark),
      themeMode: themeProvider.themeMode,
      home: const DashboardScreen(),
    );
  }

  ThemeData _buildThemeData(ColorScheme colorScheme, bool useMaterial3, Brightness brightness) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true, // Always use Material 3, even when Material You is disabled
      fontFamily: GoogleFonts.lato().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              );
            }
            return GoogleFonts.lato(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurfaceVariant,
            );
          },
        ),
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(
                color: colorScheme.primary,
                size: 24,
              );
            }
            return IconThemeData(
              color: colorScheme.onSurfaceVariant,
              size: 24,
            );
          },
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary;
            }
            return null;
          },
        ),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary.withOpacity(0.5);
            }
            return null;
          },
        ),
      ),
      // Add more Material 3 components
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: colorScheme.surface,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),
      // Add input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      // Add chip theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.primary.withOpacity(0.2),
        labelStyle: GoogleFonts.lato(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: GoogleFonts.lato(
          color: colorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}