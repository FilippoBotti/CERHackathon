// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'CER Solar';

  @override
  String get homeTitle => 'La tua CER';

  @override
  String energyAdviceFor(Object city) {
    return 'Consigli energetici per $city';
  }

  @override
  String get noAdviceAvailable => 'Nessun consiglio disponibile.';

  @override
  String get reminderActivated => 'Promemoria attivato.';

  @override
  String get reminderCancelled => 'Promemoria annullato.';

  @override
  String get goalTitle => 'Obiettivo';

  @override
  String get goalText =>
      'Spostare i consumi domestici nelle ore in cui la produzione solare locale è più alta.';

  @override
  String get whyCerTitle => 'Perché è utile per una CER?';

  @override
  String get whyCerText =>
      'Aiuta la comunità a usare più energia rinnovabile prodotta localmente e ridurre gli sprechi.';

  @override
  String get bestMomentTodayAt => 'Momento migliore oggi alle ore:';

  @override
  String bestMomentTodaySemantic(Object peak, Object range, Object advice) {
    return 'Momento migliore oggi. Picco previsto alle ore $peak. Fascia consigliata $range. $advice';
  }

  @override
  String recommendedRange(Object range) {
    return 'Fascia consigliata: $range';
  }

  @override
  String estimatedSolarIntensity(Object value) {
    return 'Intensità solare stimata: $value W/m²';
  }

  @override
  String activeReminderToday(Object time) {
    return 'Promemoria attivo per oggi alle $time';
  }

  @override
  String get listenAdvice => 'Ascolta consiglio';

  @override
  String get listenAdviceSemantic =>
      'Ascolta il consiglio energetico. Legge ad alta voce il momento migliore e la fascia consigliata.';

  @override
  String get sendReminder => 'Inviami un promemoria';

  @override
  String get sendReminderSemantic =>
      'Inviami un promemoria quando è il momento consigliato per usare gli elettrodomestici.';

  @override
  String get cancelReminder => 'Annulla promemoria';

  @override
  String get cancelReminderSemantic => 'Annulla il promemoria attivo';

  @override
  String get testReminder => 'Prova promemoria';

  @override
  String get whatToUse => 'Cosa conviene usare';

  @override
  String get washingMachine => 'Lavatrice';

  @override
  String get washingMachineSubtitle => 'Ideale nelle ore di picco';

  @override
  String get dishwasher => 'Lavastoviglie';

  @override
  String get dishwasherSubtitle => 'Programma avvio ritardato';

  @override
  String get evCharging => 'Ricarica EV';

  @override
  String get evChargingSubtitle => 'Consumo alto, meglio col sole';

  @override
  String get searchCity => 'Cerca città';

  @override
  String get searchCityHint => 'Es. Parma, Bologna, Milano';

  @override
  String get welcomeTitle => 'Benvenuto in CER Solar';

  @override
  String get welcomeText =>
      'Ti aiutiamo a capire quando conviene usare gli elettrodomestici, in base alla produzione solare prevista nella tua zona.';

  @override
  String get chooseCity => 'Per iniziare, scegli la tua città.';

  @override
  String get forecastTitle => 'Previsioni solari';

  @override
  String forecastSubtitle(Object city) {
    return 'Andamento stimato per $city';
  }

  @override
  String get today => 'Oggi';

  @override
  String get tomorrow => 'Domani';

  @override
  String get noForecastAvailable => 'Nessuna previsione disponibile.';

  @override
  String get currentSituation => 'Situazione attuale';

  @override
  String get bestExpectedMoment => 'Miglior momento previsto';

  @override
  String forecastForHour(Object hour) {
    return 'Previsione delle ore $hour';
  }

  @override
  String get pullToRefresh => 'Trascina verso il basso per aggiornare';

  @override
  String hourlyForecastFor(Object day) {
    return 'Previsioni orarie per $day';
  }

  @override
  String get reminder => 'Promemoria';

  @override
  String reminderAlreadyActiveFor(Object day) {
    return 'Hai già un promemoria attivo per $day.';
  }

  @override
  String get reminderDescription =>
      'Ricevi una notifica la sera per ricordarti della fascia consigliata.';

  @override
  String activeAt(Object time) {
    return 'Attivo alle $time';
  }

  @override
  String get cancelTomorrowReminder => 'Annulla promemoria per domani';

  @override
  String activateReminderFor(Object day) {
    return 'Attiva promemoria per $day';
  }

  @override
  String get tomorrowReminderActivated => 'Promemoria per domani attivato.';

  @override
  String get tomorrowReminderCancelled => 'Promemoria per domani annullato.';

  @override
  String get productionHigh => 'Produzione alta';

  @override
  String get productionGood => 'Produzione buona';

  @override
  String get productionMedium => 'Produzione media';

  @override
  String get productionLow => 'Produzione bassa';

  @override
  String get scoreMessageHigh =>
      'In questo momento è conveniente usare elettrodomestici energivori.';

  @override
  String get scoreMessageGood =>
      'È un buon momento per spostare alcuni consumi domestici.';

  @override
  String get scoreMessageMedium =>
      'La produzione è moderata: meglio usare piccoli elettrodomestici.';

  @override
  String get scoreMessageLow =>
      'La produzione è bassa: se puoi, attendi una fascia migliore.';

  @override
  String get cloudCover => 'Nuvolosità';

  @override
  String get historyTitle => 'Storico';

  @override
  String get historySubtitle =>
      'Ultimi 7 giorni di consigli energetici generati dall’app.';

  @override
  String get lastWeek => 'Ultima settimana';

  @override
  String get exportData => 'Esporta dati';

  @override
  String get exportCsvDescription =>
      'Puoi esportare lo storico completo in formato CSV.';

  @override
  String get exportCsv => 'Esporta CSV';

  @override
  String get exporting => 'Esportazione...';

  @override
  String get clearHistory => 'Cancella storico';

  @override
  String get deleteHistoryTitle => 'Cancellare lo storico?';

  @override
  String get deleteHistoryMessage =>
      'Questa azione eliminerà tutti i dati salvati nello storico.';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Cancella';

  @override
  String get recommendedRangeLabel => 'Fascia consigliata';

  @override
  String get peakExpectedLabel => 'Picco previsto';

  @override
  String get estimatedIntensityLabel => 'Intensità stimata';

  @override
  String get emptyHistoryTitle => 'Nessun dato negli ultimi 7 giorni';

  @override
  String get emptyHistoryText =>
      'Quando l’app calcola un consiglio energetico, lo salva qui insieme a città e giorno.';

  @override
  String get notificationReminderTitle =>
      'È il momento giusto per usare energia';

  @override
  String notificationReminderBody(Object city, Object range, Object peak) {
    return 'A $city la fascia consigliata è $range. Picco previsto alle $peak.';
  }

  @override
  String get notificationTestTitle => 'Notifiche attive';

  @override
  String get notificationTestBody =>
      'Riceverai un promemoria quando conviene usare gli elettrodomestici.';

  @override
  String get retry => 'Riprova';

  @override
  String get notificationEndTitle => 'La fascia migliore sta terminando';

  @override
  String notificationEndBody(Object city, Object range) {
    return 'A $city la fascia consigliata $range sta finendo. Se puoi, riduci i consumi più energivori.';
  }

  @override
  String get savingsPotentialTitle => 'Risparmio potenziale';

  @override
  String get savingsLastSevenDays => 'Ultimi 7 giorni';

  @override
  String savingsEstimatedEuro(Object value) {
    return '€ $value';
  }

  @override
  String savingsEstimatedCo2(Object value) {
    return '$value kg CO₂ evitata stimata';
  }

  @override
  String savingsExplanation(Object kwh) {
    return 'Stima basata sullo spostamento di circa $kwh kWh nella fascia consigliata.';
  }

  @override
  String savingsBasedOnAdvices(Object count) {
    return 'Basato su $count consigli generati.';
  }

  @override
  String get solarAdviceHigh =>
      'Produzione solare alta: è un ottimo momento per usare lavatrice, lavastoviglie o ricarica elettrica.';

  @override
  String get solarAdviceGood =>
      'Produzione solare buona: conviene spostare alcuni consumi domestici in questa fascia.';

  @override
  String get solarAdviceMedium =>
      'Produzione solare media: meglio usare solo piccoli elettrodomestici.';

  @override
  String get solarAdviceLow =>
      'Produzione solare bassa: se puoi, rimanda i consumi più energivori.';

  @override
  String ttsAdviceText(Object city, Object peak, Object range, Object advice) {
    return 'Consiglio energetico per $city. Il momento migliore oggi è alle $peak. La fascia consigliata è $range. $advice';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navForecast => 'Previsioni';

  @override
  String get navHistory => 'Storico';

  @override
  String get notificationTomorrowReminderTitle =>
      'Domani conviene usare energia solare';

  @override
  String notificationTomorrowReminderBody(
    Object city,
    Object range,
    Object peak,
  ) {
    return 'A $city, domani la fascia consigliata è $range. Picco previsto alle $peak.';
  }
}
