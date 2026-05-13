import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/app_city.dart';
import '../models/history_entry.dart';
import '../services/api/geocoding_api.dart';
import '../services/notification_service.dart';
import '../services/repository/history_repository.dart';
import '../services/repository/weather_repository.dart';
import '../services/tts_service.dart';
import '../services/utils/city_preferences_utils.dart';
import '../services/utils/reminder_preferences_utils.dart';
import '../services/utils/solar_advice_utils.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final WeatherRepository weatherRepository;
  final SolarAdviceUtils solarAdviceUtils;
  final CityPreferencesUtils cityPreferencesUtils;
  final GeocodingApi geocodingApi;
  final NotificationService notificationService;
  final HistoryRepository historyRepository;
  final TtsService ttsService;
  final ReminderPreferencesUtils reminderPreferencesUtils;

  Timer? _refreshTimer;

  HomeCubit({
    required this.weatherRepository,
    required this.solarAdviceUtils,
    required this.cityPreferencesUtils,
    required this.geocodingApi,
    required this.notificationService,
    required this.historyRepository,
    required this.ttsService,
    required this.reminderPreferencesUtils,
  }) : super(const HomeState());

  Future<void> loadForecast({bool silent = false}) async {
    if (!silent) {
      emit(state.copyWith(loading: true, clearError: true));
    }

    try {
      final selectedCity = await cityPreferencesUtils.getSelectedCity();

      if (selectedCity == null) {
        emit(
          state.copyWith(
            loading: false,
            clearError: true,
            hasSelectedCity: false,
            city: '',
            bestTimeRange: null,
            peakHour: null,
            clearAdviceLevel: true,
            maxRadiation: null,
            hours: [],
            cityResults: [],
            clearReminder: true,
          ),
        );
        return;
      }

      final savedReminderDateTime = await _getValidSavedReminderDateTime();

      await _loadForecastForCity(
        selectedCity,
        reminderDateTime: savedReminderDateTime,
      );
    } catch (_) {
      emit(
        state.copyWith(
          loading: false,
          error: 'Impossibile caricare le previsioni meteo.',
        ),
      );
    }
  }

  void startAutoRefresh() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 30),
      (_) {
        loadForecast(silent: true);
      },
    );
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  Future<void> close() {
    stopAutoRefresh();
    return super.close();
  }

  Future<void> searchCity(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 2) {
      emit(
        state.copyWith(
          cityResults: [],
          searchingCity: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        searchingCity: true,
        clearError: true,
      ),
    );

    try {
      final results = await geocodingApi.searchCities(trimmedQuery);

      emit(
        state.copyWith(
          searchingCity: false,
          cityResults: results,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          searchingCity: false,
          error: 'Impossibile cercare la città.',
        ),
      );
    }
  }

  Future<void> changeCity(AppCity city) async {
    emit(
      state.copyWith(
        loading: true,
        cityResults: [],
        clearError: true,
      ),
    );

    try {
      await cityPreferencesUtils.saveSelectedCity(city);

      final savedReminderDateTime = await _getValidSavedReminderDateTime();

      await _loadForecastForCity(
        city,
        reminderDateTime: savedReminderDateTime,
      );
    } catch (_) {
      emit(
        state.copyWith(
          loading: false,
          error: 'Impossibile cambiare città.',
        ),
      );
    }
  }

  Future<void> scheduleReminder({
    required String notificationTitle,
    required String Function(
      String city,
      String bestTimeRange,
      String peakHour,
    ) notificationBodyBuilder,
    required String notificationEndTitle,
    required String Function(
      String city,
      String bestTimeRange,
    ) notificationEndBodyBuilder,
  }) async {
    await _scheduleReminderForDate(
      targetDate: DateTime.now(),
      notificationTitle: notificationTitle,
      notificationBodyBuilder: notificationBodyBuilder,
      notificationEndTitle: notificationEndTitle,
      notificationEndBodyBuilder: notificationEndBodyBuilder,
      reminderTiming: _ReminderTiming.beforeRange,
    );
  }

  Future<void> scheduleReminderForTomorrow({
    required String notificationTitle,
    required String Function(
      String city,
      String bestTimeRange,
      String peakHour,
    ) notificationBodyBuilder,
  }) async {
    await _scheduleReminderForDate(
      targetDate: DateTime.now().add(const Duration(days: 1)),
      notificationTitle: notificationTitle,
      notificationBodyBuilder: notificationBodyBuilder,
      notificationEndTitle: '',
      notificationEndBodyBuilder: (_, __) => '',
      reminderTiming: _ReminderTiming.eveningBefore,
    );
  }

  Future<void> scheduleReminderForDate(
    DateTime targetDate, {
    required String notificationTitle,
    required String Function(
      String city,
      String bestTimeRange,
      String peakHour,
    ) notificationBodyBuilder,
  }) async {
    final isTomorrow = _isSameDay(
      targetDate,
      DateTime.now().add(const Duration(days: 1)),
    );

    await _scheduleReminderForDate(
      targetDate: targetDate,
      notificationTitle: notificationTitle,
      notificationBodyBuilder: notificationBodyBuilder,
      notificationEndTitle: '',
      notificationEndBodyBuilder: (_, __) => '',
      reminderTiming: isTomorrow
          ? _ReminderTiming.eveningBefore
          : _ReminderTiming.beforeRange,
    );
  }

  Future<void> cancelTomorrowReminder() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    await notificationService.cancelApplianceReminderForDate(tomorrow);
    await reminderPreferencesUtils.clearReminderDateTime();

    emit(
      state.copyWith(
        clearReminder: true,
      ),
    );
  }

  Future<void> cancelTodayReminder() async {
    await notificationService.cancelApplianceReminderForDate(DateTime.now());
    await reminderPreferencesUtils.clearReminderDateTime();

    emit(
      state.copyWith(
        clearReminder: true,
      ),
    );
  }

  Future<void> cancelReminder() async {
    final reminderDateTime = state.reminderDateTime;

    if (reminderDateTime == null) return;

    await notificationService.cancelApplianceReminderForDate(reminderDateTime);
    await reminderPreferencesUtils.clearReminderDateTime();

    emit(
      state.copyWith(
        clearReminder: true,
      ),
    );
  }

  Future<void> showTestNotification({
    required String title,
    required String body,
  }) async {
    await notificationService.showTestNotification(
      title: title,
      body: body,
    );
  }

  Future<void> speakAdvice({
    required String text,
    required String languageCode,
  }) async {
    await ttsService.speak(
      text: text,
      languageCode: languageCode,
    );
  }

  Future<void> _scheduleReminderForDate({
    required DateTime targetDate,
    required String notificationTitle,
    required String Function(
      String city,
      String bestTimeRange,
      String peakHour,
    ) notificationBodyBuilder,
    required String notificationEndTitle,
    required String Function(
      String city,
      String bestTimeRange,
    ) notificationEndBodyBuilder,
    required _ReminderTiming reminderTiming,
  }) async {
    final selectedCity = await cityPreferencesUtils.getSelectedCity();

    if (selectedCity == null) {
      throw Exception('Seleziona prima una città.');
    }

    final forecast = await weatherRepository.getForecastForCity(selectedCity);

    final advice = solarAdviceUtils.calculate(
      forecast,
      targetDate: targetDate,
    );

    final scheduledTime = reminderTiming == _ReminderTiming.eveningBefore
        ? _getEveningBeforeReminderTime(targetDate)
        : _getReminderDateTimeFromRange(
            bestTimeRange: advice.bestTimeRange,
            targetDate: targetDate,
          );

    await notificationService.scheduleApplianceReminder(
      scheduledTime: scheduledTime,
      reminderDate: targetDate,
      title: notificationTitle,
      body: notificationBodyBuilder(
        selectedCity.name,
        advice.bestTimeRange,
        advice.peakHour,
      ),
    );

    if (reminderTiming == _ReminderTiming.beforeRange) {
      final endTime = _getRangeEndTime(
        bestTimeRange: advice.bestTimeRange,
        targetDate: targetDate,
      );

      await notificationService.scheduleRangeEndNotification(
        endTime: endTime,
        reminderDate: targetDate,
        title: notificationEndTitle,
        body: notificationEndBodyBuilder(
          selectedCity.name,
          advice.bestTimeRange,
        ),
      );
    }

    final reminderStateDateTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    await reminderPreferencesUtils.saveReminderDateTime(
      reminderStateDateTime,
    );

    emit(
      state.copyWith(
        reminderDateTime: reminderStateDateTime,
      ),
    );
  }

  Future<void> _loadForecastForCity(
    AppCity city, {
    DateTime? reminderDateTime,
  }) async {
    final forecast = await weatherRepository.getForecastForCity(city);
    final advice = solarAdviceUtils.calculate(forecast);

    await historyRepository.saveEntry(
      HistoryEntry(
        city: city.name,
        latitude: city.latitude,
        longitude: city.longitude,
        date: _dateKey(DateTime.now()),
        bestTimeRange: advice.bestTimeRange,
        peakHour: advice.peakHour,
        maxRadiation: advice.maxRadiation,
        advice: advice.level.name,
      ),
    );

    emit(
      state.copyWith(
        loading: false,
        clearError: true,
        hasSelectedCity: true,
        city: forecast.city,
        hours: forecast.hours,
        bestTimeRange: advice.bestTimeRange,
        maxRadiation: advice.maxRadiation,
        peakHour: advice.peakHour,
        adviceLevel: advice.level,
        cityResults: [],
        reminderDateTime: reminderDateTime,
      ),
    );
  }

  Future<DateTime?> _getValidSavedReminderDateTime() async {
    final savedReminderDateTime =
        await reminderPreferencesUtils.getReminderDateTime();

    if (savedReminderDateTime == null) {
      return null;
    }

    if (savedReminderDateTime.isBefore(DateTime.now())) {
      await reminderPreferencesUtils.clearReminderDateTime();
      return null;
    }

    return savedReminderDateTime;
  }

  DateTime _getReminderDateTimeFromRange({
    required String bestTimeRange,
    required DateTime targetDate,
  }) {
    if (bestTimeRange == '-') {
      throw Exception('Nessuna fascia consigliata disponibile.');
    }

    final startText = bestTimeRange.split('-').first.trim();
    final startHour = int.parse(startText.split(':').first);

    final startTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      startHour,
    );

    var scheduledTime = startTime.subtract(
      const Duration(minutes: 10),
    );

    final now = DateTime.now();

    if (scheduledTime.isBefore(now) && startTime.isAfter(now)) {
      scheduledTime = startTime;
    }

    if (scheduledTime.isBefore(now)) {
      throw Exception(
        'La fascia consigliata è già passata. Aggiorna le previsioni o scegli un altro giorno.',
      );
    }

    return scheduledTime;
  }

  DateTime _getEveningBeforeReminderTime(DateTime targetDate) {
    final dayBefore = targetDate.subtract(const Duration(days: 1));

    final scheduledTime = DateTime(
      dayBefore.year,
      dayBefore.month,
      dayBefore.day,
      20,
      0,
    );

    if (scheduledTime.isBefore(DateTime.now())) {
      return DateTime.now().add(const Duration(minutes: 1));
    }

    return scheduledTime;
  }

  DateTime _getRangeEndTime({
    required String bestTimeRange,
    required DateTime targetDate,
  }) {
    if (bestTimeRange == '-') {
      throw Exception('Nessuna fascia consigliata disponibile.');
    }

    final endText = bestTimeRange.split('-').last.trim();
    final endHour = int.parse(endText.split(':').first);

    return DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      endHour,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _dateKey(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}

enum _ReminderTiming {
  beforeRange,
  eveningBefore,
}