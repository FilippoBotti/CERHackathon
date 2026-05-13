// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CER Solar';

  @override
  String get homeTitle => 'Your Energy Community';

  @override
  String energyAdviceFor(Object city) {
    return 'Energy advice for $city';
  }

  @override
  String get noAdviceAvailable => 'No advice available.';

  @override
  String get reminderActivated => 'Reminder activated.';

  @override
  String get reminderCancelled => 'Reminder cancelled.';

  @override
  String get goalTitle => 'Goal';

  @override
  String get goalText =>
      'Shift household consumption to the hours when local solar production is highest.';

  @override
  String get whyCerTitle => 'Why is it useful for an energy community?';

  @override
  String get whyCerText =>
      'It helps the community use more locally produced renewable energy and reduce waste.';

  @override
  String get bestMomentTodayAt => 'Best moment today at:';

  @override
  String bestMomentTodaySemantic(Object peak, Object range, Object advice) {
    return 'Best moment today. Expected peak at $peak. Recommended range $range. $advice';
  }

  @override
  String recommendedRange(Object range) {
    return 'Recommended range: $range';
  }

  @override
  String estimatedSolarIntensity(Object value) {
    return 'Estimated solar intensity: $value W/m²';
  }

  @override
  String activeReminderToday(Object time) {
    return 'Reminder active for today at $time';
  }

  @override
  String get listenAdvice => 'Listen to advice';

  @override
  String get listenAdviceSemantic =>
      'Listen to the energy advice. Reads aloud the best moment and the recommended time range.';

  @override
  String get sendReminder => 'Send me a reminder';

  @override
  String get sendReminderSemantic =>
      'Send me a reminder when it is the recommended time to use household appliances.';

  @override
  String get cancelReminder => 'Cancel reminder';

  @override
  String get cancelReminderSemantic => 'Cancel the active reminder';

  @override
  String get testReminder => 'Test reminder';

  @override
  String get whatToUse => 'What to use';

  @override
  String get washingMachine => 'Washing machine';

  @override
  String get washingMachineSubtitle => 'Best during peak hours';

  @override
  String get dishwasher => 'Dishwasher';

  @override
  String get dishwasherSubtitle => 'Use delayed start';

  @override
  String get evCharging => 'EV charging';

  @override
  String get evChargingSubtitle => 'High consumption, better with sun';

  @override
  String get searchCity => 'Search city';

  @override
  String get searchCityHint => 'E.g. Parma, Bologna, Milan';

  @override
  String get welcomeTitle => 'Welcome to CER Solar';

  @override
  String get welcomeText =>
      'We help you understand when it is best to use household appliances, based on the expected solar production in your area.';

  @override
  String get chooseCity => 'To start, choose your city.';

  @override
  String get forecastTitle => 'Solar forecast';

  @override
  String forecastSubtitle(Object city) {
    return 'Estimated trend for $city';
  }

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get noForecastAvailable => 'No forecast available.';

  @override
  String get currentSituation => 'Current situation';

  @override
  String get bestExpectedMoment => 'Best expected moment';

  @override
  String forecastForHour(Object hour) {
    return 'Forecast for $hour';
  }

  @override
  String get pullToRefresh => 'Pull down to refresh';

  @override
  String hourlyForecastFor(Object day) {
    return 'Hourly forecast for $day';
  }

  @override
  String get reminder => 'Reminder';

  @override
  String reminderAlreadyActiveFor(Object day) {
    return 'You already have an active reminder for $day.';
  }

  @override
  String get reminderDescription =>
      'Receive a notification 10 minutes before the recommended time range.';

  @override
  String activeAt(Object time) {
    return 'Active at $time';
  }

  @override
  String get cancelTomorrowReminder => 'Cancel tomorrow reminder';

  @override
  String activateReminderFor(Object day) {
    return 'Activate reminder for $day';
  }

  @override
  String get tomorrowReminderActivated => 'Tomorrow reminder activated.';

  @override
  String get tomorrowReminderCancelled => 'Tomorrow reminder cancelled.';

  @override
  String get productionHigh => 'High production';

  @override
  String get productionGood => 'Good production';

  @override
  String get productionMedium => 'Medium production';

  @override
  String get productionLow => 'Low production';

  @override
  String get scoreMessageHigh =>
      'This is a good time to use energy-intensive appliances.';

  @override
  String get scoreMessageGood =>
      'It is a good time to shift some household consumption.';

  @override
  String get scoreMessageMedium =>
      'Production is moderate: better to use small appliances.';

  @override
  String get scoreMessageLow =>
      'Production is low: if possible, wait for a better time range.';

  @override
  String get cloudCover => 'Cloud cover';

  @override
  String get historyTitle => 'History';

  @override
  String get historySubtitle =>
      'Energy advice generated by the app in the last 7 days.';

  @override
  String get lastWeek => 'Last week';

  @override
  String get exportData => 'Export data';

  @override
  String get exportCsvDescription =>
      'You can export the complete history in CSV format.';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exporting => 'Exporting...';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get deleteHistoryTitle => 'Clear history?';

  @override
  String get deleteHistoryMessage =>
      'This action will delete all saved history data.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get recommendedRangeLabel => 'Recommended range';

  @override
  String get peakExpectedLabel => 'Expected peak';

  @override
  String get estimatedIntensityLabel => 'Estimated intensity';

  @override
  String get emptyHistoryTitle => 'No data in the last 7 days';

  @override
  String get emptyHistoryText =>
      'When the app calculates an energy advice, it is saved here together with city and day.';

  @override
  String get notificationReminderTitle => 'It is the right time to use energy';

  @override
  String notificationReminderBody(Object city, Object range, Object peak) {
    return 'In $city, the recommended time range is $range. Expected peak at $peak.';
  }

  @override
  String get notificationTestTitle => 'Notifications enabled';

  @override
  String get notificationTestBody =>
      'You will receive a reminder when it is convenient to use household appliances.';

  @override
  String get retry => 'Retry';

  @override
  String get notificationEndTitle => 'The best time range is ending';

  @override
  String notificationEndBody(Object city, Object range) {
    return 'In $city, the recommended range $range is ending. If possible, reduce energy-intensive consumption.';
  }

  @override
  String get savingsPotentialTitle => 'Potential savings';

  @override
  String get savingsLastSevenDays => 'Last 7 days';

  @override
  String savingsEstimatedEuro(Object value) {
    return '€ $value';
  }

  @override
  String savingsEstimatedCo2(Object value) {
    return '$value kg estimated CO₂ avoided';
  }

  @override
  String savingsExplanation(Object kwh) {
    return 'Estimate based on shifting about $kwh kWh to the recommended time range.';
  }

  @override
  String savingsBasedOnAdvices(Object count) {
    return 'Based on $count generated advice entries.';
  }

  @override
  String get solarAdviceHigh =>
      'High solar production: this is an excellent time to use the washing machine, dishwasher or electric vehicle charging.';

  @override
  String get solarAdviceGood =>
      'Good solar production: it is convenient to shift some household consumption to this time range.';

  @override
  String get solarAdviceMedium =>
      'Medium solar production: it is better to use only small appliances.';

  @override
  String get solarAdviceLow =>
      'Low solar production: if possible, postpone energy-intensive consumption.';

  @override
  String ttsAdviceText(Object city, Object peak, Object range, Object advice) {
    return 'Energy advice for $city. The best moment today is at $peak. The recommended time range is $range. $advice';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navForecast => 'Forecast';

  @override
  String get navHistory => 'History';

  @override
  String get notificationTomorrowReminderTitle =>
      'Tomorrow is a good day to use solar energy';

  @override
  String notificationTomorrowReminderBody(
    Object city,
    Object range,
    Object peak,
  ) {
    return 'In $city, tomorrow the recommended time range is $range. Expected peak at $peak.';
  }
}
