import '../services/utils/solar_advice_utils.dart';

class SolarAdvice {
  final String bestTimeRange;
  final String peakHour;
  final double maxRadiation;
  final SolarProductionLevel level;

  const SolarAdvice({
    required this.bestTimeRange,
    required this.peakHour,
    required this.maxRadiation,
    required this.level,
  });
}