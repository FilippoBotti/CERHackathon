class SolarHour {
  final DateTime time;
  final double temperature;
  final double cloudCover;

  /// Radiazione solare orizzontale.
  final double radiation;

  /// Radiazione stimata sul piano inclinato.
  /// È più vicina alla radiazione utile per pannelli fotovoltaici.
  final double globalTiltedIrradiance;

  const SolarHour({
    required this.time,
    required this.temperature,
    required this.cloudCover,
    required this.radiation,
    required this.globalTiltedIrradiance,
  });

  String get hourLabel {
    return '${time.hour.toString().padLeft(2, '0')}:00';
  }
}