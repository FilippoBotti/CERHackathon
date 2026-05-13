class AppCity {
  final String name;
  final double latitude;
  final double longitude;
  final String? country;

  const AppCity({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
  });

  String get displayName {
    if (country == null || country!.isEmpty) {
      return name;
    }

    return '$name, $country';
  }

  factory AppCity.fromJson(Map<String, dynamic> json) {
    return AppCity(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
    );
  }
}