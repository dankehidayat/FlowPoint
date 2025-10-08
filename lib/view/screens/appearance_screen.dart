// lib/views/screens/appearance_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appearance',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Material You Toggle
                _buildMaterialYouOption(
                  context,
                  'Material You',
                  Icons.palette_outlined,
                  themeProvider.useMaterialYou,
                  onChanged: (value) {
                    themeProvider.setUseMaterialYou(value);
                  },
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Text(
                        themeProvider.useMaterialYou
                            ? 'Using dynamic colors from your wallpaper (Android 12+)'
                            : 'Using Material 3 with beautiful fixed colors',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Theme Options
                Text(
                  'Theme Mode',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how the app handles light and dark themes',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildThemeOption(
                  context,
                  'Follow system theme',
                  Icons.phone_iphone,
                  themeProvider.themeMode == ThemeMode.system,
                  onChanged: (value) {
                    themeProvider.setThemeMode(
                      value ? ThemeMode.system : ThemeMode.light,
                    );
                  },
                ),
                const SizedBox(height: 12),
                              
                // Theme Preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Theme',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'See how your changes look in real-time',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildThemePreview(
                            context,
                            'Light',
                            Icons.light_mode_outlined,
                            ThemeMode.light,
                            themeProvider,
                          ),
                          const SizedBox(width: 16),
                          _buildThemePreview(
                            context,
                            'Dark',
                            Icons.dark_mode_outlined,
                            ThemeMode.dark,
                            themeProvider,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Color Scheme Preview
                      Text(
                        'Color Scheme',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildColorPalettePreview(context),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Current Settings Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Settings',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSettingItem(
                            'Material You',
                            themeProvider.useMaterialYou ? 'Enabled' : 'Disabled',
                            themeProvider.useMaterialYou ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          _buildSettingItem(
                            'Theme Mode',
                            _getThemeModeText(themeProvider.themeMode),
                            Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          _buildSettingItem(
                            'Color Source',
                            themeProvider.useMaterialYou ? 'Dynamic (Wallpaper)' : 'Fixed (Blue)',
                            Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMaterialYouOption(
    BuildContext context,
    String title,
    IconData icon,
    bool value, {
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Text(
                        themeProvider.useMaterialYou
                            ? 'Dynamic colors from your wallpaper'
                            : 'Beautiful fixed Material 3 colors',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.useMaterialYou,
                  onChanged: (newValue) {
                    // Use a small delay to ensure smooth transition
                    Future.delayed(const Duration(milliseconds: 50), () {
                      onChanged(newValue);
                    });
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    IconData icon,
    bool value, {
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreview(
    BuildContext context,
    String title,
    IconData icon,
    ThemeMode themeMode,
    ThemeProvider themeProvider,
  ) {
    final bool isSelected = themeProvider.themeMode == themeMode;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          themeProvider.setThemeMode(themeMode);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isSelected ? 'Active' : 'Tap to select',
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPalettePreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isMaterialYou = Provider.of<ThemeProvider>(context).useMaterialYou;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            isMaterialYou ? '🎨 Material You Colors' : '🎨 Material 3 Colors',
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isMaterialYou 
                ? 'Dynamic colors from your wallpaper'
                : 'Beautiful fixed color palette',
            style: GoogleFonts.lato(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Primary colors row
          _buildColorRow(
            'Primary Colors',
            [
              _buildColorSquare(colorScheme.primary, 'Primary'),
              _buildColorSquare(colorScheme.onPrimary, 'On Primary'),
              _buildColorSquare(colorScheme.primaryContainer, 'Container'),
            ],
          ),
          const SizedBox(height: 12),
          
          // Secondary colors row
          _buildColorRow(
            'Secondary Colors',
            [
              _buildColorSquare(colorScheme.secondary, 'Secondary'),
              _buildColorSquare(colorScheme.onSecondary, 'On Secondary'),
              _buildColorSquare(colorScheme.secondaryContainer, 'Container'),
            ],
          ),
          const SizedBox(height: 12),
          
          // Surface colors row
          _buildColorRow(
            'Surface Colors',
            [
              _buildColorSquare(colorScheme.surface, 'Surface'),
              _buildColorSquare(colorScheme.onSurface, 'On Surface'),
              _buildColorSquare(colorScheme.surfaceVariant, 'Variant'),
            ],
          ),
          const SizedBox(height: 12),
          
          // Background and error colors
          _buildColorRow(
            'Utility Colors',
            [
              _buildColorSquare(colorScheme.background, 'Background'),
              _buildColorSquare(colorScheme.error, 'Error'),
              _buildColorSquare(colorScheme.tertiary, 'Tertiary'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow(String title, List<Widget> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: colors,
        ),
      ],
    );
  }

  Widget _buildColorSquare(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingItem(String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}