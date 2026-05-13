class SavingsEstimator {
  static const double assumedShiftedKwh = 1.5;
  static const double energyPriceEurPerKwh = 0.25;
  static const double co2KgPerKwh = 0.25;

  double estimatedSavingEuro() {
    return assumedShiftedKwh * energyPriceEurPerKwh;
  }

  double estimatedCo2Kg() {
    return assumedShiftedKwh * co2KgPerKwh;
  }

  String explanation() {
    return 'Stima basata sullo spostamento di circa '
        '${assumedShiftedKwh.toStringAsFixed(1)} kWh nella fascia consigliata.';
  }
}