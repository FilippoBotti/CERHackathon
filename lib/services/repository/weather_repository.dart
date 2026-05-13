import '../../models/app_city.dart';
import '../../models/solar_hour.dart';
import '../../models/weather_forecast.dart';
import '../api/weather_api.dart';

class WeatherRepository {
  final WeatherApi weatherApi;

  const WeatherRepository({
    required this.weatherApi,
  });

  Future<WeatherForecast> getForecastForCity(AppCity city) async {
    final json = await weatherApi.getSolarForecast(
      latitude: city.latitude,
      longitude: city.longitude,
    );

    final hourly = json['hourly'] as Map<String, dynamic>;

    final times = hourly['time'] as List;
    final temperatures = hourly['temperature_2m'] as List;
    final cloudCovers = hourly['cloud_cover'] as List;
    final radiations = hourly['shortwave_radiation'] as List;
    final globalTiltedIrradiances = hourly['global_tilted_irradiance'] as List;

    final hours = <SolarHour>[];

    for (var i = 0; i < times.length; i++) {
      hours.add(
        SolarHour(
          time: DateTime.parse(times[i] as String),
          temperature: (temperatures[i] as num).toDouble(),
          cloudCover: (cloudCovers[i] as num).toDouble(),
          radiation: (radiations[i] as num).toDouble(),
          globalTiltedIrradiance: (globalTiltedIrradiances[i] as num).toDouble(),
        ),
      );
    }

    return WeatherForecast(
      city: city.name,
      hours: hours,
    );
  }
}