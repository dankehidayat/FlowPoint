# FlowPoint - Energy & Temp Monitoring App

<div align="center">

<img width="240" height="533" alt="image" src="https://github.com/user-attachments/assets/a07422f5-492e-4b49-a583-a359aa3c13cc" />

**Real-time IoT Energy Monitoring & Power Quality Analysis**

[![Flutter](https://img.shields.io/badge/Flutter-3.19-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*A comprehensive Flutter application for monitoring energy consumption, power quality, and environmental conditions in real-time*

</div>

## 📱 Overview

FlowPoint is a sophisticated Flutter-based mobile application designed for real-time energy & room temperature monitoring and power quality analysis. The app connects to IoT sensors via Blynk server to provide detailed insights into electrical parameters, energy consumption patterns, and environmental conditions.

## ✨ Features

### 🎯 **Real-time Dashboard**
- **Live Data Monitoring** - Real-time updates every 3 seconds
- **Comprehensive Summary** - Total energy, temperature, and humidity at a glance
- **Connection Status** - Online/offline status with timestamp tracking
- **Responsive Design** - Optimized for mobile and tablet devices

### ⚡ **Power Metrics Monitoring**
- **Voltage & Current** - Real-time electrical parameters (V0, V1)
- **Active Power** - Actual power consumption in Watts (V2)
- **Apparent Power** - Total power in Volt-Amps (V4)
- **Power Factor** - Energy efficiency measurement (V3)
- **Frequency** - Grid frequency monitoring in Hz (V6)

### 🔬 **Power Quality Analysis**
- **Reactive Power** - VAR consumption tracking (V7)
- **Energy Consumption** - Cumulative energy in Watt-hours (V5)
- **Comprehensive Analytics** - Detailed power quality metrics

### 🌡️ **Environmental Monitoring**
- **Temperature** - Real-time temperature tracking (V8)
- **Humidity** - Environmental humidity levels (V9)
- **Sensor Status** - Online/offline sensor connectivity

### 📊 **Advanced Data Visualization**
- **Interactive Charts** - Multi-sensor data visualization using FL Chart
- **Multiple Chart Types**:
  - Temperature & Humidity trends
  - Power consumption analysis
  - Voltage & Current monitoring
- **Time-range Selection** - 1H, 3H, 24H viewing options
- **Touch-enabled Tooltips** - Detailed point inspection with timestamp

### 🎨 **User Experience**
- **Material You Design** - Modern, adaptive UI following Material Design 3
- **Dark/Light Theme** - System-aware theme switching
- **Smooth Animations** - Nested scroll views with animated app bars
- **Responsive Layout** - Adaptive grid systems for all screen sizes

## 🛠️ Technical Stack

- **Framework**: Flutter 3.19
- **Language**: Dart 3.3
- **State Management**: Provider
- **Charts**: FL Chart for data visualization
- **HTTP Client**: http package for API communication
- **Styling**: Google Fonts (Lato)
- **Icons**: Material Icons

## 📋 System Architecture

### Data Flow
```
IoT Sensors → Blynk Server → FlowPoint App → Real-time Display
    ↓              ↓              ↓              ↓
ESP32/NodeMCU   iot.serangkota.go.id   Flutter App   Charts & Dashboard
```

### Sensor Data Structure
```dart
class SensorData {
  double voltage;          // V0 - Voltage in volts
  double current;          // V1 - Current in amperes
  double power;            // V2 - Active power in watts
  double powerFactor;      // V3 - Power factor (0.0-1.0)
  double apparentPower;    // V4 - Apparent power in VA
  double energy;           // V5 - Energy in watt-hours
  double frequency;        // V6 - Frequency in Hz
  double reactivePower;    // V7 - Reactive power in VAR
  double temperature;      // V8 - Temperature in °C
  double humidity;         // V9 - Humidity in %
  DateTime timestamp;      // Data collection timestamp
  bool isOnline;           // Connection status
}
```

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK 3.19.0 or higher
- Dart 3.3 or higher
- Android SDK 21+ or iOS 13+
- Internet connection for real-time data

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/flowpoint.git
cd flowpoint
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Blynk Server
Update the server configuration in `sensor_provider.dart`:

```dart
final String _blynkServer = 'iot.serangkota.go.id';
final int _blynkPort = 8080;
final String _authToken = 'your_auth_token_here'; // Add your Blynk auth token
```

### 4. Run the Application
```bash
flutter run
```

## 🏗️ Project Structure

```
lib/
├── main.dart                          # Application entry point
├── models/
│   └── sensor_data.dart              # Sensor data models
├── providers/
│   ├── sensor_provider.dart          # Sensor data management & API calls
│   ├── settings_provider.dart        # Settings configuration management
│   └── theme_provider.dart           # Theme management
├── utils/                            # Utility classes & helpers
├── view/
│   ├── screens/
│   │   ├── about_screen.dart         # About app information
│   │   ├── appearance_screen.dart    # Appearance customization
│   │   ├── chart_screen.dart         # Data visualization charts
│   │   ├── dashboard_customization_screen.dart # Dashboard layout customization
│   │   ├── dashboard_screen.dart     # Main dashboard
│   │   └── settings_screen.dart      # App settings
│   └── widgets/
│       ├── chart/                    # Chart-related widgets
│       │   ├── chart_container.dart
│       │   ├── chart_data_helper.dart
│       │   ├── chart_legend.dart
│       │   ├── chart_type_selector.dart
│       │   ├── stats_summary.dart
│       │   └── time_range_selector.dart
│       └── dashboard/                # Dashboard-specific widgets
│           ├── environment_card.dart
│           ├── environment_section.dart
│           ├── gauge_environment_card.dart
│           ├── last_updated_widget.dart
│           ├── power_metrics_section.dart
│           ├── power_quality_section.dart
│           ├── sensor_card.dart
│           ├── status_card.dart
│           └── summary_card.dart
└── main.dart
```

## 🔧 Configuration

### API Endpoints
- **Base URL**: `http://iot.serangkota.go.id:8080`
- **Data Fetch Interval**: 3 seconds
- **Virtual Pins**: V0 to V9 for sensor data

### Android Permissions
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### Network Security
For Android 9+ compatibility, the app includes network security configuration allowing cleartext traffic to the Blynk server.

## 📊 Data Visualization Features

### Chart Screen Capabilities
- **Multi-line Charts** - Display multiple sensor data simultaneously
- **Interactive Tooltips** - Touch to see detailed values with timestamps
- **Statistical Summary** - Average, min, max values for each dataset
- **Time Range Filtering** - 1 hour, 3 hours, or 24 hours of data
- **Chart Type Selection**:
  - Temperature & Humidity
  - Power Consumption (Active, Apparent, Reactive)
  - Voltage & Current

### Responsive Grid System
- **Mobile**: 2-column grid for metrics
- **Tablet**: 3-4 column adaptive grid
- **Desktop**: Optimized layouts for larger screens

## 🎨 UI/UX Features

### Dashboard Design
- **Category-based Organization**:
  - Power Metrics (Voltage, Current, Active/Apparent Power)
  - Power Quality (Reactive Power, Power Factor, Frequency, Energy)
  - Environment (Temperature, Humidity)
- **Color-coded Metrics** - Consistent color scheme for easy recognition
- **Status Indicators** - Visual connection status with last update time

### Navigation
- **Bottom Navigation** - Dashboard and Charts screens
- **Nested Scroll Views** - Smooth scrolling with collapsing app bars
- **Settings Panel** - Theme customization and app settings

## 🔌 Integration with Blynk IoT

### Virtual Pin Mapping
| Virtual Pin | Parameter | Unit | Description |
|-------------|-----------|------|-------------|
| V0 | Voltage | V | Electrical voltage |
| V1 | Current | A | Electrical current |
| V2 | Active Power | W | Real power consumption |
| V3 | Power Factor | - | Energy efficiency (0-1) |
| V4 | Apparent Power | VA | Total power |
| V5 | Energy | Wh | Cumulative energy |
| V6 | Frequency | Hz | Grid frequency |
| V7 | Reactive Power | VAR | Reactive power |
| V8 | Temperature | °C | Environmental temperature |
| V9 | Humidity | % | Environmental humidity |

### Data Fetching Strategy
```dart
// Concurrent API calls for all virtual pins
Future<void> fetchDataFromBlynk() async {
  final List<Future<http.Response>> requests = [];
  for (int i = 0; i <= 9; i++) {
    final url = Uri.http('$_blynkServer:$_blynkPort', '/$_authToken/get/V$i');
    requests.add(http.get(url));
  }
  final responses = await Future.wait(requests);
  // Process and update UI
}
```

## 🚀 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### Build Configuration
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest Android
- **ProGuard**: Enabled for release builds

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Blynk IoT Platform** - For providing the IoT infrastructure
- **Flutter Team** - For the amazing cross-platform framework
- **FL Chart** - For beautiful and interactive chart visualizations
- **Material Design** - For comprehensive design guidelines

## 🔮 Roadmap

- [ ] Data export functionality
- [ ] Advanced analytics and predictions
- [ ] Multi-device support
- [ ] Custom alert system
- [ ] Historical data analysis
- [ ] Energy cost calculations

---

<div align="center">

**Made with ⚡ by Danke Hidayat**

*Empowering energy efficiency through real-time monitoring*

</div>
