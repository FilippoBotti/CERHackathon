import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'CER Solar'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In it, this message translates to:
  /// **'La tua CER'**
  String get homeTitle;

  /// No description provided for @energyAdviceFor.
  ///
  /// In it, this message translates to:
  /// **'Consigli energetici per {city}'**
  String energyAdviceFor(Object city);

  /// No description provided for @noAdviceAvailable.
  ///
  /// In it, this message translates to:
  /// **'Nessun consiglio disponibile.'**
  String get noAdviceAvailable;

  /// No description provided for @reminderActivated.
  ///
  /// In it, this message translates to:
  /// **'Promemoria attivato.'**
  String get reminderActivated;

  /// No description provided for @reminderCancelled.
  ///
  /// In it, this message translates to:
  /// **'Promemoria annullato.'**
  String get reminderCancelled;

  /// No description provided for @goalTitle.
  ///
  /// In it, this message translates to:
  /// **'Obiettivo'**
  String get goalTitle;

  /// No description provided for @goalText.
  ///
  /// In it, this message translates to:
  /// **'Spostare i consumi domestici nelle ore in cui la produzione solare locale è più alta.'**
  String get goalText;

  /// No description provided for @whyCerTitle.
  ///
  /// In it, this message translates to:
  /// **'Perché è utile per una CER?'**
  String get whyCerTitle;

  /// No description provided for @whyCerText.
  ///
  /// In it, this message translates to:
  /// **'Aiuta la comunità a usare più energia rinnovabile prodotta localmente e ridurre gli sprechi.'**
  String get whyCerText;

  /// No description provided for @bestMomentTodayAt.
  ///
  /// In it, this message translates to:
  /// **'Momento migliore oggi alle ore:'**
  String get bestMomentTodayAt;

  /// No description provided for @bestMomentTodaySemantic.
  ///
  /// In it, this message translates to:
  /// **'Momento migliore oggi. Picco previsto alle ore {peak}. Fascia consigliata {range}. {advice}'**
  String bestMomentTodaySemantic(Object peak, Object range, Object advice);

  /// No description provided for @recommendedRange.
  ///
  /// In it, this message translates to:
  /// **'Fascia consigliata: {range}'**
  String recommendedRange(Object range);

  /// No description provided for @estimatedSolarIntensity.
  ///
  /// In it, this message translates to:
  /// **'Intensità solare stimata: {value} W/m²'**
  String estimatedSolarIntensity(Object value);

  /// No description provided for @activeReminderToday.
  ///
  /// In it, this message translates to:
  /// **'Promemoria attivo per oggi alle {time}'**
  String activeReminderToday(Object time);

  /// No description provided for @listenAdvice.
  ///
  /// In it, this message translates to:
  /// **'Ascolta consiglio'**
  String get listenAdvice;

  /// No description provided for @listenAdviceSemantic.
  ///
  /// In it, this message translates to:
  /// **'Ascolta il consiglio energetico. Legge ad alta voce il momento migliore e la fascia consigliata.'**
  String get listenAdviceSemantic;

  /// No description provided for @sendReminder.
  ///
  /// In it, this message translates to:
  /// **'Inviami un promemoria'**
  String get sendReminder;

  /// No description provided for @sendReminderSemantic.
  ///
  /// In it, this message translates to:
  /// **'Inviami un promemoria quando è il momento consigliato per usare gli elettrodomestici.'**
  String get sendReminderSemantic;

  /// No description provided for @cancelReminder.
  ///
  /// In it, this message translates to:
  /// **'Annulla promemoria'**
  String get cancelReminder;

  /// No description provided for @cancelReminderSemantic.
  ///
  /// In it, this message translates to:
  /// **'Annulla il promemoria attivo'**
  String get cancelReminderSemantic;

  /// No description provided for @testReminder.
  ///
  /// In it, this message translates to:
  /// **'Prova promemoria'**
  String get testReminder;

  /// No description provided for @whatToUse.
  ///
  /// In it, this message translates to:
  /// **'Cosa conviene usare'**
  String get whatToUse;

  /// No description provided for @washingMachine.
  ///
  /// In it, this message translates to:
  /// **'Lavatrice'**
  String get washingMachine;

  /// No description provided for @washingMachineSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Ideale nelle ore di picco'**
  String get washingMachineSubtitle;

  /// No description provided for @dishwasher.
  ///
  /// In it, this message translates to:
  /// **'Lavastoviglie'**
  String get dishwasher;

  /// No description provided for @dishwasherSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Programma avvio ritardato'**
  String get dishwasherSubtitle;

  /// No description provided for @evCharging.
  ///
  /// In it, this message translates to:
  /// **'Ricarica EV'**
  String get evCharging;

  /// No description provided for @evChargingSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Consumo alto, meglio col sole'**
  String get evChargingSubtitle;

  /// No description provided for @searchCity.
  ///
  /// In it, this message translates to:
  /// **'Cerca città'**
  String get searchCity;

  /// No description provided for @searchCityHint.
  ///
  /// In it, this message translates to:
  /// **'Es. Parma, Bologna, Milano'**
  String get searchCityHint;

  /// No description provided for @welcomeTitle.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto in CER Solar'**
  String get welcomeTitle;

  /// No description provided for @welcomeText.
  ///
  /// In it, this message translates to:
  /// **'Ti aiutiamo a capire quando conviene usare gli elettrodomestici, in base alla produzione solare prevista nella tua zona.'**
  String get welcomeText;

  /// No description provided for @chooseCity.
  ///
  /// In it, this message translates to:
  /// **'Per iniziare, scegli la tua città.'**
  String get chooseCity;

  /// No description provided for @forecastTitle.
  ///
  /// In it, this message translates to:
  /// **'Previsioni solari'**
  String get forecastTitle;

  /// No description provided for @forecastSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Andamento stimato per {city}'**
  String forecastSubtitle(Object city);

  /// No description provided for @today.
  ///
  /// In it, this message translates to:
  /// **'Oggi'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In it, this message translates to:
  /// **'Domani'**
  String get tomorrow;

  /// No description provided for @noForecastAvailable.
  ///
  /// In it, this message translates to:
  /// **'Nessuna previsione disponibile.'**
  String get noForecastAvailable;

  /// No description provided for @currentSituation.
  ///
  /// In it, this message translates to:
  /// **'Situazione attuale'**
  String get currentSituation;

  /// No description provided for @bestExpectedMoment.
  ///
  /// In it, this message translates to:
  /// **'Miglior momento previsto'**
  String get bestExpectedMoment;

  /// No description provided for @forecastForHour.
  ///
  /// In it, this message translates to:
  /// **'Previsione delle ore {hour}'**
  String forecastForHour(Object hour);

  /// No description provided for @pullToRefresh.
  ///
  /// In it, this message translates to:
  /// **'Trascina verso il basso per aggiornare'**
  String get pullToRefresh;

  /// No description provided for @hourlyForecastFor.
  ///
  /// In it, this message translates to:
  /// **'Previsioni orarie per {day}'**
  String hourlyForecastFor(Object day);

  /// No description provided for @reminder.
  ///
  /// In it, this message translates to:
  /// **'Promemoria'**
  String get reminder;

  /// No description provided for @reminderAlreadyActiveFor.
  ///
  /// In it, this message translates to:
  /// **'Hai già un promemoria attivo per {day}.'**
  String reminderAlreadyActiveFor(Object day);

  /// No description provided for @reminderDescription.
  ///
  /// In it, this message translates to:
  /// **'Ricevi una notifica la sera per ricordarti della fascia consigliata.'**
  String get reminderDescription;

  /// No description provided for @activeAt.
  ///
  /// In it, this message translates to:
  /// **'Attivo alle {time}'**
  String activeAt(Object time);

  /// No description provided for @cancelTomorrowReminder.
  ///
  /// In it, this message translates to:
  /// **'Annulla promemoria per domani'**
  String get cancelTomorrowReminder;

  /// No description provided for @activateReminderFor.
  ///
  /// In it, this message translates to:
  /// **'Attiva promemoria per {day}'**
  String activateReminderFor(Object day);

  /// No description provided for @tomorrowReminderActivated.
  ///
  /// In it, this message translates to:
  /// **'Promemoria per domani attivato.'**
  String get tomorrowReminderActivated;

  /// No description provided for @tomorrowReminderCancelled.
  ///
  /// In it, this message translates to:
  /// **'Promemoria per domani annullato.'**
  String get tomorrowReminderCancelled;

  /// No description provided for @productionHigh.
  ///
  /// In it, this message translates to:
  /// **'Produzione alta'**
  String get productionHigh;

  /// No description provided for @productionGood.
  ///
  /// In it, this message translates to:
  /// **'Produzione buona'**
  String get productionGood;

  /// No description provided for @productionMedium.
  ///
  /// In it, this message translates to:
  /// **'Produzione media'**
  String get productionMedium;

  /// No description provided for @productionLow.
  ///
  /// In it, this message translates to:
  /// **'Produzione bassa'**
  String get productionLow;

  /// No description provided for @scoreMessageHigh.
  ///
  /// In it, this message translates to:
  /// **'In questo momento è conveniente usare elettrodomestici energivori.'**
  String get scoreMessageHigh;

  /// No description provided for @scoreMessageGood.
  ///
  /// In it, this message translates to:
  /// **'È un buon momento per spostare alcuni consumi domestici.'**
  String get scoreMessageGood;

  /// No description provided for @scoreMessageMedium.
  ///
  /// In it, this message translates to:
  /// **'La produzione è moderata: meglio usare piccoli elettrodomestici.'**
  String get scoreMessageMedium;

  /// No description provided for @scoreMessageLow.
  ///
  /// In it, this message translates to:
  /// **'La produzione è bassa: se puoi, attendi una fascia migliore.'**
  String get scoreMessageLow;

  /// No description provided for @cloudCover.
  ///
  /// In it, this message translates to:
  /// **'Nuvolosità'**
  String get cloudCover;

  /// No description provided for @historyTitle.
  ///
  /// In it, this message translates to:
  /// **'Storico'**
  String get historyTitle;

  /// No description provided for @historySubtitle.
  ///
  /// In it, this message translates to:
  /// **'Ultimi 7 giorni di consigli energetici generati dall’app.'**
  String get historySubtitle;

  /// No description provided for @lastWeek.
  ///
  /// In it, this message translates to:
  /// **'Ultima settimana'**
  String get lastWeek;

  /// No description provided for @exportData.
  ///
  /// In it, this message translates to:
  /// **'Esporta dati'**
  String get exportData;

  /// No description provided for @exportCsvDescription.
  ///
  /// In it, this message translates to:
  /// **'Puoi esportare lo storico completo in formato CSV.'**
  String get exportCsvDescription;

  /// No description provided for @exportCsv.
  ///
  /// In it, this message translates to:
  /// **'Esporta CSV'**
  String get exportCsv;

  /// No description provided for @exporting.
  ///
  /// In it, this message translates to:
  /// **'Esportazione...'**
  String get exporting;

  /// No description provided for @clearHistory.
  ///
  /// In it, this message translates to:
  /// **'Cancella storico'**
  String get clearHistory;

  /// No description provided for @deleteHistoryTitle.
  ///
  /// In it, this message translates to:
  /// **'Cancellare lo storico?'**
  String get deleteHistoryTitle;

  /// No description provided for @deleteHistoryMessage.
  ///
  /// In it, this message translates to:
  /// **'Questa azione eliminerà tutti i dati salvati nello storico.'**
  String get deleteHistoryMessage;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In it, this message translates to:
  /// **'Cancella'**
  String get delete;

  /// No description provided for @recommendedRangeLabel.
  ///
  /// In it, this message translates to:
  /// **'Fascia consigliata'**
  String get recommendedRangeLabel;

  /// No description provided for @peakExpectedLabel.
  ///
  /// In it, this message translates to:
  /// **'Picco previsto'**
  String get peakExpectedLabel;

  /// No description provided for @estimatedIntensityLabel.
  ///
  /// In it, this message translates to:
  /// **'Intensità stimata'**
  String get estimatedIntensityLabel;

  /// No description provided for @emptyHistoryTitle.
  ///
  /// In it, this message translates to:
  /// **'Nessun dato negli ultimi 7 giorni'**
  String get emptyHistoryTitle;

  /// No description provided for @emptyHistoryText.
  ///
  /// In it, this message translates to:
  /// **'Quando l’app calcola un consiglio energetico, lo salva qui insieme a città e giorno.'**
  String get emptyHistoryText;

  /// No description provided for @notificationReminderTitle.
  ///
  /// In it, this message translates to:
  /// **'È il momento giusto per usare energia'**
  String get notificationReminderTitle;

  /// No description provided for @notificationReminderBody.
  ///
  /// In it, this message translates to:
  /// **'A {city} la fascia consigliata è {range}. Picco previsto alle {peak}.'**
  String notificationReminderBody(Object city, Object range, Object peak);

  /// No description provided for @notificationTestTitle.
  ///
  /// In it, this message translates to:
  /// **'Notifiche attive'**
  String get notificationTestTitle;

  /// No description provided for @notificationTestBody.
  ///
  /// In it, this message translates to:
  /// **'Riceverai un promemoria quando conviene usare gli elettrodomestici.'**
  String get notificationTestBody;

  /// No description provided for @retry.
  ///
  /// In it, this message translates to:
  /// **'Riprova'**
  String get retry;

  /// No description provided for @notificationEndTitle.
  ///
  /// In it, this message translates to:
  /// **'La fascia migliore sta terminando'**
  String get notificationEndTitle;

  /// No description provided for @notificationEndBody.
  ///
  /// In it, this message translates to:
  /// **'A {city} la fascia consigliata {range} sta finendo. Se puoi, riduci i consumi più energivori.'**
  String notificationEndBody(Object city, Object range);

  /// No description provided for @savingsPotentialTitle.
  ///
  /// In it, this message translates to:
  /// **'Risparmio potenziale'**
  String get savingsPotentialTitle;

  /// No description provided for @savingsLastSevenDays.
  ///
  /// In it, this message translates to:
  /// **'Ultimi 7 giorni'**
  String get savingsLastSevenDays;

  /// No description provided for @savingsEstimatedEuro.
  ///
  /// In it, this message translates to:
  /// **'€ {value}'**
  String savingsEstimatedEuro(Object value);

  /// No description provided for @savingsEstimatedCo2.
  ///
  /// In it, this message translates to:
  /// **'{value} kg CO₂ evitata stimata'**
  String savingsEstimatedCo2(Object value);

  /// No description provided for @savingsExplanation.
  ///
  /// In it, this message translates to:
  /// **'Stima basata sullo spostamento di circa {kwh} kWh nella fascia consigliata.'**
  String savingsExplanation(Object kwh);

  /// No description provided for @savingsBasedOnAdvices.
  ///
  /// In it, this message translates to:
  /// **'Basato su {count} consigli generati.'**
  String savingsBasedOnAdvices(Object count);

  /// No description provided for @solarAdviceHigh.
  ///
  /// In it, this message translates to:
  /// **'Produzione solare alta: è un ottimo momento per usare lavatrice, lavastoviglie o ricarica elettrica.'**
  String get solarAdviceHigh;

  /// No description provided for @solarAdviceGood.
  ///
  /// In it, this message translates to:
  /// **'Produzione solare buona: conviene spostare alcuni consumi domestici in questa fascia.'**
  String get solarAdviceGood;

  /// No description provided for @solarAdviceMedium.
  ///
  /// In it, this message translates to:
  /// **'Produzione solare media: meglio usare solo piccoli elettrodomestici.'**
  String get solarAdviceMedium;

  /// No description provided for @solarAdviceLow.
  ///
  /// In it, this message translates to:
  /// **'Produzione solare bassa: se puoi, rimanda i consumi più energivori.'**
  String get solarAdviceLow;

  /// No description provided for @ttsAdviceText.
  ///
  /// In it, this message translates to:
  /// **'Consiglio energetico per {city}. Il momento migliore oggi è alle {peak}. La fascia consigliata è {range}. {advice}'**
  String ttsAdviceText(Object city, Object peak, Object range, Object advice);

  /// No description provided for @navHome.
  ///
  /// In it, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navForecast.
  ///
  /// In it, this message translates to:
  /// **'Previsioni'**
  String get navForecast;

  /// No description provided for @navHistory.
  ///
  /// In it, this message translates to:
  /// **'Storico'**
  String get navHistory;

  /// No description provided for @notificationTomorrowReminderTitle.
  ///
  /// In it, this message translates to:
  /// **'Domani conviene usare energia solare'**
  String get notificationTomorrowReminderTitle;

  /// No description provided for @notificationTomorrowReminderBody.
  ///
  /// In it, this message translates to:
  /// **'A {city}, domani la fascia consigliata è {range}. Picco previsto alle {peak}.'**
  String notificationTomorrowReminderBody(
    Object city,
    Object range,
    Object peak,
  );
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
