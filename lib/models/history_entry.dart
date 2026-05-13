class HistoryEntry {
  final String city;
  final double latitude;
  final double longitude;
  final String date;
  final String bestTimeRange;
  final String peakHour;
  final double maxRadiation;
  final String advice;

  const HistoryEntry({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.bestTimeRange,
    required this.peakHour,
    required this.maxRadiation,
    required this.advice,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'bestTimeRange': bestTimeRange,
      'peakHour': peakHour,
      'maxRadiation': maxRadiation,
      'advice': advice,
    };
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      date: json['date'] as String,
      bestTimeRange: json['bestTimeRange'] as String,
      peakHour: json['peakHour'] as String,
      maxRadiation: (json['maxRadiation'] as num).toDouble(),
      advice: json['advice'] as String,
    );
  }
}