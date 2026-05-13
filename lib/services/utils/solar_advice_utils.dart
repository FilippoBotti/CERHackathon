import '../../models/solar_advice.dart';
import '../../models/solar_hour.dart';
import '../../models/weather_forecast.dart';

enum SolarProductionLevel {
  high,
  good,
  medium,
  low,
  unavailable,
}

class SolarAdviceUtils {
  static const int _windowSize = 3;

  SolarAdvice calculate(
    WeatherForecast forecast, {
    DateTime? targetDate,
  }) {
    final day = targetDate ?? DateTime.now();

    final dayHours = forecast.hours.where((hour) {
      final sameDay = hour.time.year == day.year &&
          hour.time.month == day.month &&
          hour.time.day == day.day;

      final usefulHour = hour.time.hour >= 8 && hour.time.hour <= 18;

      return sameDay && usefulHour;
    }).toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    if (dayHours.isEmpty) {
      return const SolarAdvice(
        bestTimeRange: '-',
        peakHour: '-',
        maxRadiation: 0,
        level: SolarProductionLevel.unavailable,
      );
    }

    final bestWindow = _findBestWindow(dayHours);
    final averageScore = _averageScore(bestWindow);
    final maxRadiation = _maxRadiation(bestWindow);
    final peakHour = _findPeakHour(bestWindow);
    final level = productionLevel(averageScore);

    final start = bestWindow.first.time;
    final end = bestWindow.last.time.add(const Duration(hours: 1));

    final range =
        '${_formatHour(start.hour)}:00 - ${_formatHour(end.hour)}:00';

    return SolarAdvice(
      bestTimeRange: range,
      peakHour: '${_formatHour(peakHour.time.hour)}:00',
      maxRadiation: maxRadiation,
      level: level,
    );
  }

  List<SolarHour> _findBestWindow(List<SolarHour> hours) {
    if (hours.length <= _windowSize) {
      return hours;
    }

    var bestWindow = hours.take(_windowSize).toList();
    var bestScore = _averageScore(bestWindow);

    for (var i = 0; i <= hours.length - _windowSize; i++) {
      final window = hours.sublist(i, i + _windowSize);
      final score = _averageScore(window);

      if (score > bestScore) {
        bestScore = score;
        bestWindow = window;
      }
    }

    return bestWindow;
  }

  SolarHour _findPeakHour(List<SolarHour> hours) {
    return hours.reduce((best, current) {
      if (current.globalTiltedIrradiance > best.globalTiltedIrradiance) {
        return current;
      }

      return best;
    });
  }

  double _averageScore(List<SolarHour> hours) {
    final total = hours.fold<double>(
      0,
      (sum, hour) => sum + calculateSolarScore(hour),
    );

    return total / hours.length;
  }

  double calculateSolarScore(SolarHour hour) {
    final irradianceScore =
        (hour.globalTiltedIrradiance / 900).clamp(0.0, 1.0);

    final cloudScore = (1 - (hour.cloudCover / 100) * 0.25).clamp(0.0, 1.0);

    final temperaturePenalty = hour.temperature > 30
        ? ((hour.temperature - 30) * 0.005).clamp(0.0, 0.15)
        : 0.0;

    final temperatureScore = 1 - temperaturePenalty;

    return (irradianceScore * cloudScore * temperatureScore).clamp(0.0, 1.0);
  }

  SolarProductionLevel productionLevel(double score) {
    if (score >= 0.75) {
      return SolarProductionLevel.high;
    }

    if (score >= 0.50) {
      return SolarProductionLevel.good;
    }

    if (score >= 0.25) {
      return SolarProductionLevel.medium;
    }

    return SolarProductionLevel.low;
  }

  double _maxRadiation(List<SolarHour> hours) {
    return hours
        .map((hour) => hour.globalTiltedIrradiance)
        .reduce((a, b) => a > b ? a : b);
  }

  String _formatHour(int hour) {
    return hour.toString().padLeft(2, '0');
  }
}