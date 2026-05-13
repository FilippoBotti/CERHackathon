import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cer_community_app/l10n/app_localizations.dart';

import 'theme/app_theme.dart';
import 'home/home_cubit.dart';
import 'services/utils/solar_advice_utils.dart';
import 'services/api/weather_api.dart';
import 'services/repository/weather_repository.dart';
import 'shell/main_shell.dart';
import 'services/api/geocoding_api.dart';
import 'services/utils/city_preferences_utils.dart';
import 'services/notification_service.dart';
import 'history/history_cubit.dart';
import 'services/repository/history_repository.dart';
import 'services/csv_export_service.dart';
import 'services/tts_service.dart';

void main() {
  runApp(const CerSolarApp());
}

class CerSolarApp extends StatelessWidget {
  const CerSolarApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final weatherApi = WeatherApi();
    final weatherRepository = WeatherRepository(weatherApi: weatherApi);
    final solarAdviceUtils = SolarAdviceUtils();
    final geocodingApi = GeocodingApi();
    final cityPreferencesUtils = CityPreferencesUtils();
    final notificationService = NotificationService();
    final historyRepository = HistoryRepository();
    final csvExportService = CsvExportService();
    final ttsService = TtsService();

    return MaterialApp(
      title: 'CER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it'),
        Locale('en'),
      ],
      home: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(
            weatherRepository: weatherRepository,
            solarAdviceUtils: solarAdviceUtils,
            cityPreferencesUtils: cityPreferencesUtils,
            geocodingApi: geocodingApi,
            notificationService: notificationService,
            historyRepository: historyRepository,
            ttsService: ttsService,
          )
          ..loadForecast()
          ..startAutoRefresh(),
        ),
        BlocProvider(
          create: (_) => HistoryCubit(
            historyRepository: historyRepository,
            csvExportService: csvExportService,
          ),
        ),
      ],
      child: const MainShell(),
    ),
    );
  }
}