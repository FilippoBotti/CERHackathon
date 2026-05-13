import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherApi {
  Future<Map<String, dynamic>> getSolarForecast({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'hourly': [
          'temperature_2m',
          'cloud_cover',
          'shortwave_radiation',
          'global_tilted_irradiance',
        ].join(','),
        'forecast_days': '2',
        'timezone': 'Europe/Rome',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Errore Open-Meteo: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}