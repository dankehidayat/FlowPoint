import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sensor_provider.dart';
import 'theme_provider.dart';
import 'chart_screen.dart';

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
                // Fixed: Allow toggling off by setting to light mode
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
      child: Container( // Changed from GestureDetector to Container to make it non-clickable
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
                  _buildStatusCard(sensorProvider.error, context),

                if (sensorProvider.error.isNotEmpty) const SizedBox(height: 16),

                // Sensor Data Content
                _buildCategorizedContent(data, context),

                // Last Updated
                const SizedBox(height: 24),
                _buildLastUpdated(data, context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategorizedContent(SensorData data, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTabletLandscape = isTablet && screenWidth > MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Card (replaced Energy Summary)
        _buildSummaryCard(data, context),
        const SizedBox(height: 16),

        // Power Metrics Section
        _buildSectionHeader('Power Metrics', Icons.bolt_outlined),
        const SizedBox(height: 12),
        _buildCategoryGrid(
          context: context,
          isTablet: isTablet,
          isDesktop: isDesktop,
          items: [
            _buildSensorCard(
              'Voltage',
              '${data.voltage.toStringAsFixed(1)} V',
              Icons.offline_bolt_outlined,
              Colors.orange,
              context,
            ),
            _buildSensorCard(
              'Current',
              '${data.current.toStringAsFixed(2)} A',
              Icons.electric_bolt_outlined,
              Colors.blue,
              context,
            ),
            _buildSensorCard(
              'Active Power',
              '${data.power.toStringAsFixed(1)} W',
              Icons.power_outlined,
              Colors.red,
              context,
            ),
            _buildSensorCard(
              'Apparent Power',
              '${data.apparentPower.toStringAsFixed(1)} VA',
              Icons.offline_bolt_outlined,
              Colors.purple,
              context,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Power Quality Section
        _buildSectionHeader('Power Quality', Icons.analytics_outlined),
        const SizedBox(height: 12),
        _buildCategoryGrid(
          context: context,
          isTablet: isTablet,
          isDesktop: isDesktop,
          items: [
            _buildSensorCard(
              'Reactive Power',
              '${data.reactivePower.toStringAsFixed(1)} VAR',
              Icons.auto_graph_outlined,
              Colors.amber,
              context,
            ),
            _buildSensorCard(
              'Power Factor',
              data.powerFactor.toStringAsFixed(2),
              Icons.speed_outlined,
              Colors.teal,
              context,
            ),
            _buildSensorCard(
              'Frequency',
              '${data.frequency.toStringAsFixed(1)} Hz',
              Icons.waves_outlined,
              Colors.indigo,
              context,
            ),
            _buildSensorCard(
              'Energy',
              '${data.energy.toStringAsFixed(1)} Wh',
              Icons.energy_savings_leaf_outlined,
              Colors.green,
              context,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Environment Section
        _buildSectionHeader('Environment', Icons.thermostat_outlined),
        const SizedBox(height: 12),
        _buildEnvironmentGrid(
          context: context,
          isTablet: isTablet,
          isDesktop: isDesktop,
          isTabletLandscape: isTabletLandscape,
          items: [
            _buildEnvironmentCard(
              'Temperature',
              '${data.temperature.toStringAsFixed(1)}°C',
              Icons.thermostat_outlined,
              Colors.red,
              context,
              isTabletLandscape: isTabletLandscape,
            ),
            _buildEnvironmentCard(
              'Humidity',
              '${data.humidity.toStringAsFixed(1)}%',
              Icons.water_drop_outlined,
              Colors.blue,
              context,
              isTabletLandscape: isTabletLandscape,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid({
    required BuildContext context,
    required bool isTablet,
    required bool isDesktop,
    required List<Widget> items,
  }) {
    int crossAxisCount;
    double childAspectRatio;

    if (isDesktop) {
      crossAxisCount = 4;
      childAspectRatio = 2.5;
    } else if (isTablet) {
      crossAxisCount = 2;
      childAspectRatio = 2.5;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 2.2;
    }

    if (items.length < crossAxisCount) {
      crossAxisCount = items.length;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: items,
    );
  }

  Widget _buildEnvironmentGrid({
    required BuildContext context,
    required bool isTablet,
    required bool isDesktop,
    required bool isTabletLandscape,
    required List<Widget> items,
  }) {
    int crossAxisCount;
    double childAspectRatio;

    if (isDesktop) {
      crossAxisCount = 2;
      childAspectRatio = 2.5;
    } else if (isTablet) {
      if (isTabletLandscape) {
        crossAxisCount = 2;
        childAspectRatio = 1.8;
      } else {
        crossAxisCount = 2;
        childAspectRatio = 2.5;
      }
    } else {
      crossAxisCount = 2;
      childAspectRatio = 2.2;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: items,
    );
  }

  Widget _buildSensorCard(
    String title, 
    String value, 
    IconData icon, 
    Color color, 
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark 
        ? _getDarkModeColor(color).withOpacity(0.15)
        : color.withOpacity(0.1);
    
    final Color iconBackgroundColor = isDark
        ? _getDarkModeColor(color).withOpacity(0.25)
        : color.withOpacity(0.15);
    
    final Color borderColor = isDark
        ? Colors.transparent
        : color.withOpacity(0.2);
    
    final Color displayColor = isDark 
        ? _getDarkModeColor(color)
        : color;

    // Font sizes for tablet
    double labelFontSize = isTablet ? 16 : 12;
    double valueFontSize = isTablet ? 20 : 14;
    double iconSize = isTablet ? 28 : 20;

    return Container(
      constraints: BoxConstraints(
        minWidth: 120,
        maxWidth: 300,
        minHeight: isTablet ? 80 : 60,
        maxHeight: isTablet ? 100 : 80,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16, vertical: isTablet ? 16 : 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 8 : 6),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: displayColor),
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold, // Changed: Always bold for both mobile and tablet
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.lato(
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentCard(
    String title, 
    String value, 
    IconData icon, 
    Color color, 
    BuildContext context, {
    required bool isTabletLandscape,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark 
        ? _getDarkModeColor(color).withOpacity(0.15)
        : color.withOpacity(0.1);
    
    final Color iconBackgroundColor = isDark
        ? _getDarkModeColor(color).withOpacity(0.25)
        : color.withOpacity(0.15);
    
    final Color borderColor = isDark
        ? Colors.transparent
        : color.withOpacity(0.2);
    
    final Color displayColor = isDark 
        ? _getDarkModeColor(color)
        : color;

    // Special font sizes for temperature and humidity cards
    double labelFontSize;
    double valueFontSize;
    double iconSize;

    if (isTablet) {
      // Tablet: Very large fonts for temperature and humidity
      labelFontSize = isTabletLandscape ? 18 : 20;
      valueFontSize = 42; // Very big font size for tablet temperature/humidity values
      iconSize = isTabletLandscape ? 32 : 36;
    } else {
      // Mobile: Normal sizes but bold labels
      labelFontSize = isTabletLandscape ? 12 : 14;
      valueFontSize = isTabletLandscape ? 14 : 16;
      iconSize = isTabletLandscape ? 20 : 24;
    }

    return Container(
      constraints: isTabletLandscape 
          ? BoxConstraints(
              minWidth: 100,
              maxWidth: 180,
              minHeight: isTablet ? 120 : 50,
              maxHeight: isTablet ? 140 : 65,
            )
          : BoxConstraints(
              minWidth: 120,
              maxWidth: 300,
              minHeight: isTablet ? 140 : 60,
              maxHeight: isTablet ? 160 : 80,
            ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: isTabletLandscape 
            ? EdgeInsets.symmetric(horizontal: 16, vertical: isTablet ? 20 : 8)
            : EdgeInsets.symmetric(horizontal: 20, vertical: isTablet ? 24 : 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : (isTabletLandscape ? 6 : 8)),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                size: iconSize,
                color: displayColor
              ),
            ),
            SizedBox(width: isTablet ? 16 : (isTabletLandscape ? 10 : 12)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold, // Changed: Always bold for both mobile and tablet
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: GoogleFonts.lato(
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDarkModeColor(Color lightColor) {
    if (lightColor == Colors.orange) return Colors.orange.shade300;
    if (lightColor == Colors.blue) return Colors.blue.shade300;
    if (lightColor == Colors.red) return Colors.red.shade300;
    if (lightColor == Colors.purple) return Colors.purple.shade300;
    if (lightColor == Colors.green) return Colors.green.shade300;
    if (lightColor == Colors.teal) return Colors.teal.shade300;
    if (lightColor == Colors.indigo) return Colors.indigo.shade300;
    if (lightColor == Colors.amber) return Colors.amber.shade300;
    return lightColor;
  }

  Widget _buildStatusCard(String error, BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connection Issue',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    error,
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              onPressed: _fetchData,
              tooltip: 'Retry Connection',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(SensorData data, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard, // Changed icon
                     color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Summary', // Changed title
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Energy', '${data.energy.toStringAsFixed(1)} Wh', Icons.energy_savings_leaf_outlined, context),
                _buildSummaryItem('Temp', '${data.temperature.toStringAsFixed(1)}°C', Icons.thermostat_outlined, context),
                _buildSummaryItem('Humid', '${data.humidity.toStringAsFixed(1)}%', Icons.water_drop_outlined, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    double labelFontSize = isTablet ? 14 : 12;
    double valueFontSize = isTablet ? 18 : 14;
    double iconSize = isTablet ? 24 : 18;

    return Column(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold, // Fixed: Always bold for both mobile and tablet
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: valueFontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated(SensorData data, BuildContext context) {
    final isRecent = DateTime.now().difference(data.timestamp).inSeconds < 10;
    final sensorProvider = context.read<SensorProvider>();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: data.isOnline 
                  ? (isRecent ? Colors.green : Colors.orange)
                  : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                data.isOnline 
                  ? (isRecent ? 'Online | Good' : 'Online | Delayed')
                  : 'Offline',
                style: GoogleFonts.lato(
                  color: data.isOnline 
                    ? (isRecent ? Colors.green : Colors.orange)
                    : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: ${_formatTime(data.timestamp)}',
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            'Data points: ${sensorProvider.sensorHistory.length}',
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}