import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/app_city.dart';

class GeocodingApi {
  Future<List<AppCity>> searchCities(String query) async {
    final uri = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      {
        'name': query,
        'count': '5',
        'language': 'it',
        'format': 'json',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Errore geocoding: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List?;

    if (results == null) {
      return [];
    }

    return results
        .map((item) => AppCity.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}