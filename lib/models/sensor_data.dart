class SensorData {
  final double voltage;          // V0
  final double current;          // V1
  final double power;            // V2
  final double powerFactor;      // V3
  final double apparentPower;    // V4
  final double energy;           // V5
  final double frequency;        // V6
  final double reactivePower;    // V7
  final double temperature;      // V8
  final double humidity;         // V9
  final DateTime timestamp;
  final bool isOnline;

  const SensorData({
    required this.voltage,
    required this.current,
    required this.power,
    required this.powerFactor,
    required this.apparentPower,
    required this.energy,
    required this.frequency,
    required this.reactivePower,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
    required this.isOnline,
  });

  // Factory constructor untuk data kosong/default
  factory SensorData.empty() {
    return SensorData(
      voltage: 0.0,
      current: 0.0,
      power: 0.0,
      powerFactor: 0.0,
      apparentPower: 0.0,
      energy: 0.0,
      frequency: 0.0,
      reactivePower: 0.0,
      temperature: 0.0,
      humidity: 0.0,
      timestamp: DateTime.now(),
      isOnline: false,
    );
  }

  // Factory constructor untuk parsing dari Blynk API (V0-V9 format)
  factory SensorData.fromBlynkJson(Map<String, dynamic> json, bool isOnline) {
    return SensorData(
      voltage: _parseDouble(json['V0'] ?? '0'),
      current: _parseDouble(json['V1'] ?? '0'),
      power: _parseDouble(json['V2'] ?? '0'),
      powerFactor: _parseDouble(json['V3'] ?? '0'),
      apparentPower: _parseDouble(json['V4'] ?? '0'),
      energy: _parseDouble(json['V5'] ?? '0'),
      frequency: _parseDouble(json['V6'] ?? '0'),
      reactivePower: _parseDouble(json['V7'] ?? '0'),
      temperature: _parseDouble(json['V8'] ?? '0'),
      humidity: _parseDouble(json['V9'] ?? '0'),
      timestamp: DateTime.now(),
      isOnline: isOnline,
    );
  }

  // Helper method untuk parsing double dengan safety
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // Method untuk convert ke JSON (untuk storage/local)
  Map<String, dynamic> toJson() {
    return {
      'voltage': voltage,
      'current': current,
      'power': power,
      'powerFactor': powerFactor,
      'apparentPower': apparentPower,
      'energy': energy,
      'frequency': frequency,
      'reactivePower': reactivePower,
      'temperature': temperature,
      'humidity': humidity,
      'timestamp': timestamp.toIso8601String(),
      'isOnline': isOnline,
    };
  }

  // Method untuk membuat copy dengan beberapa nilai yang di-update
  SensorData copyWith({
    double? voltage,
    double? current,
    double? power,
    double? powerFactor,
    double? apparentPower,
    double? energy,
    double? frequency,
    double? reactivePower,
    double? temperature,
    double? humidity,
    DateTime? timestamp,
    bool? isOnline,
  }) {
    return SensorData(
      voltage: voltage ?? this.voltage,
      current: current ?? this.current,
      power: power ?? this.power,
      powerFactor: powerFactor ?? this.powerFactor,
      apparentPower: apparentPower ?? this.apparentPower,
      energy: energy ?? this.energy,
      frequency: frequency ?? this.frequency,
      reactivePower: reactivePower ?? this.reactivePower,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      timestamp: timestamp ?? this.timestamp,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  // Method untuk cek apakah data valid (tidak semua nilai 0)
  bool get isValid {
    return voltage > 0 || 
           current > 0 || 
           power > 0 || 
           temperature > 0 || 
           humidity > 0;
  }

  // Method untuk mendapatkan summary data
  Map<String, dynamic> get summary {
    return {
      'power': power,
      'energy': energy,
      'temperature': temperature,
      'humidity': humidity,
      'isOnline': isOnline,
      'lastUpdate': timestamp,
    };
  }

  @override
  String toString() {
    return 'SensorData('
        'voltage: $voltage V (V0), '
        'current: $current A (V1), ' 
        'power: $power W (V2), '
        'temperature: $temperature°C (V8), '
        'humidity: $humidity% (V9), '
        'online: $isOnline'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SensorData &&
        other.voltage == voltage &&
        other.current == current &&
        other.power == power &&
        other.powerFactor == powerFactor &&
        other.apparentPower == apparentPower &&
        other.energy == energy &&
        other.frequency == frequency &&
        other.reactivePower == reactivePower &&
        other.temperature == temperature &&
        other.humidity == humidity &&
        other.timestamp == timestamp &&
        other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return Object.hash(
      voltage,
      current,
      power,
      powerFactor,
      apparentPower,
      energy,
      frequency,
      reactivePower,
      temperature,
      humidity,
      timestamp,
      isOnline,
    );
  }
}

class ChartData {
  final DateTime time;
  final double temperature;
  final double humidity;

  ChartData({
    required this.time,
    required this.temperature,
    required this.humidity,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
    };
  }

  // Create from JSON
  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      time: DateTime.parse(json['time']),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
    );
  }
}