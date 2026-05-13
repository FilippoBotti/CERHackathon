import '../models/app_city.dart';
import '../models/solar_hour.dart';
import '../services/utils/solar_advice_utils.dart';

class HomeState {
  final bool loading;
  final String? error;

  final bool hasSelectedCity;
  final String city;

  final String? bestTimeRange;
  final String? peakHour;
  final SolarProductionLevel? adviceLevel;
  final double? maxRadiation;
  final List<SolarHour> hours;

  final bool searchingCity;
  final List<AppCity> cityResults;

  final DateTime? reminderDateTime;

  const HomeState({
    this.loading = false,
    this.error,
    this.hasSelectedCity = false,
    this.city = '',
    this.bestTimeRange,
    this.peakHour,
    this.adviceLevel,
    this.maxRadiation,
    this.hours = const [],
    this.searchingCity = false,
    this.cityResults = const [],
    this.reminderDateTime,
  });

  bool get reminderActive => reminderDateTime != null;

  bool get reminderActiveToday {
    if (reminderDateTime == null) return false;

    final now = DateTime.now();

    return reminderDateTime!.year == now.year &&
        reminderDateTime!.month == now.month &&
        reminderDateTime!.day == now.day;
  }

  bool get reminderActiveTomorrow {
    if (reminderDateTime == null) return false;

    final now = DateTime.now();

    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));

    final reminderDay = DateTime(
      reminderDateTime!.year,
      reminderDateTime!.month,
      reminderDateTime!.day,
    );

    return reminderDay == tomorrow;
  }

  String? get reminderTime {
    if (reminderDateTime == null) return null;

    final hour = reminderDateTime!.hour.toString().padLeft(2, '0');
    final minute = reminderDateTime!.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String? get reminderDateLabel {
    if (reminderDateTime == null) return null;

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final tomorrow = today.add(const Duration(days: 1));

    final reminderDay = DateTime(
      reminderDateTime!.year,
      reminderDateTime!.month,
      reminderDateTime!.day,
    );

    if (reminderDay == today) {
      return 'oggi';
    }

    if (reminderDay == tomorrow) {
      return 'domani';
    }

    final day = reminderDateTime!.day.toString().padLeft(2, '0');
    final month = reminderDateTime!.month.toString().padLeft(2, '0');

    return 'il $day/$month';
  }

  HomeState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    bool? hasSelectedCity,
    String? city,
    String? bestTimeRange,
    String? peakHour,
    SolarProductionLevel? adviceLevel,
    bool clearAdviceLevel = false,
    double? maxRadiation,
    List<SolarHour>? hours,
    bool? searchingCity,
    List<AppCity>? cityResults,
    DateTime? reminderDateTime,
    bool clearReminder = false,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      error: clearError ? null : error ?? this.error,
      hasSelectedCity: hasSelectedCity ?? this.hasSelectedCity,
      city: city ?? this.city,
      bestTimeRange: bestTimeRange ?? this.bestTimeRange,
      peakHour: peakHour ?? this.peakHour,
      adviceLevel: clearAdviceLevel ? null : adviceLevel ?? this.adviceLevel,
      maxRadiation: maxRadiation ?? this.maxRadiation,
      hours: hours ?? this.hours,
      searchingCity: searchingCity ?? this.searchingCity,
      cityResults: cityResults ?? this.cityResults,
      reminderDateTime: clearReminder
          ? null
          : reminderDateTime ?? this.reminderDateTime,
    );
  }
}