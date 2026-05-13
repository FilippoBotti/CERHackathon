import 'solar_hour.dart';

class WeatherForecast {
  final String city;
  final List<SolarHour> hours;

  const WeatherForecast({
    required this.city,
    required this.hours,
  });
}