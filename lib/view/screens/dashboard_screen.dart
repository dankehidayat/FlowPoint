import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/sensor_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/dashboard/summary_card.dart';
import '../widgets/dashboard/power_metrics_section.dart';
import '../widgets/dashboard/power_quality_section.dart';
import '../widgets/dashboard/environment_section.dart';
import '../widgets/dashboard/status_card.dart';
import '../widgets/dashboard/last_updated_widget.dart';
import 'chart_screen.dart';
import '../../models/sensor_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentBottomNavIndex = 0;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
      _startPeriodicUpdates();
    });

    // Listen to scroll for app bar animation
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchData() {
    context.read<SensorProvider>().fetchDataFromBlynk();
  }

  void _startPeriodicUpdates() {
    // Update data every 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _fetchData();
        _startPeriodicUpdates();
      }
    });
  }

  String get _appBarTitle {
    return _currentBottomNavIndex == 0 ? 'Dashboard' : 'Charts';
  }

  double get _appBarTitleSize {
    // Scale from 22 to 34 based on scroll
    const double minSize = 22.0;
    const double maxSize = 34.0;
    const double scrollThreshold = 100.0;
    
    double progress = (_scrollOffset / scrollThreshold).clamp(0.0, 1.0);
    return maxSize - (progress * (maxSize - minSize));
  }

  Alignment get _appBarTitleAlignment {
    // Move from center to left based on scroll
    const double scrollThreshold = 100.0;
    double progress = (_scrollOffset / scrollThreshold).clamp(0.0, 1.0);
    return Alignment(-1.0 + (2.0 * (1.0 - progress)), 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                alignment: _appBarTitleAlignment,
                child: Text(
                  _appBarTitle,
                  style: GoogleFonts.lato(
                    fontSize: _appBarTitleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              centerTitle: true,
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              elevation: 0,
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) {
                    if (value == 'settings') {
                      _showSettings(context);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Settings',
                            style: GoogleFonts.lato(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
        body: _currentBottomNavIndex == 0
            ? _buildMainContent(context)
            : const ChartScreen(),
      ),
      bottomNavigationBar: _buildMaterialYouBottomNav(),
    );
  }

  Widget _buildMaterialYouBottomNav() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                fontWeight: FontWeight.bold,
              );
            }
            return const TextStyle(
              fontWeight: FontWeight.normal,
            );
          },
        ),
      ),
      child: NavigationBar(
        selectedIndex: _currentBottomNavIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_rounded),
            selectedIcon: Icon(Icons.space_dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Charts',
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Appearance Section
                _buildAppearanceSection(context),
                const SizedBox(height: 24),
                
                // Other Settings (for future expansion)
                _buildSettingsOption(
                  context,
                  'Notifications',
                  Icons.notifications_outlined,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications feature coming soon')),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsOption(
                  context,
                  'Data Management',
                  Icons.storage_outlined,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data management feature coming soon')),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSettingsOption(
                  context,
                  'About',
                  Icons.info_outlined,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('About feature coming soon')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Appearance',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Theme Options
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
            const SizedBox(height: 16),
            _buildThemeOption(
              context,
              'Dark mode',
              Icons.dark_mode_outlined,
              themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(
                'Enable dark theme',
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Light/Dark Mode Preview (Non-clickable)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildThemePreview(
                        context,
                        'Light',
                        Icons.light_mode_outlined,
                        ThemeMode.light,
                        themeProvider,
                      ),
                      const SizedBox(width: 12),
                      _buildThemePreview(
                        context,
                        'Dark',
                        Icons.dark_mode_outlined,
                        ThemeMode.dark,
                        themeProvider,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsOption(
    BuildContext context,
    String title,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lato(
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
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
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (context, sensorProvider, child) {
        final data = sensorProvider.currentData;
        
        if (data == null && sensorProvider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Connecting to ESP32...'),
              ],
            ),
          );
        }

        if (data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No Data Available',
                  style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  sensorProvider.error.isNotEmpty 
                      ? sensorProvider.error 
                      : 'Connect to the same network as ESP32',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _fetchData,
                  child: const Text('Retry Connection'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<SensorProvider>().fetchDataFromBlynk();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card - only show when offline
                if (sensorProvider.error.isNotEmpty)
                  StatusCard(
                    error: sensorProvider.error,
                    onRetry: _fetchData,
                  ),

                if (sensorProvider.error.isNotEmpty) const SizedBox(height: 16),

                // Sensor Data Content
                _buildCategorizedContent(data, context),

                // Last Updated
                const SizedBox(height: 24),
                LastUpdatedWidget(
                  data: data,
                  sensorProvider: sensorProvider,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategorizedContent(SensorData data, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Card
        SummaryCard(data: data),
        const SizedBox(height: 16),

        // Power Metrics Section
        PowerMetricsSection(data: data),
        const SizedBox(height: 16),

        // Power Quality Section
        PowerQualitySection(data: data),
        const SizedBox(height: 16),

        // Environment Section
        EnvironmentSection(data: data),
      ],
    );
  }
}