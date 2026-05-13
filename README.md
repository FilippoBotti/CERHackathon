# CER Solar

CER Solar è un’app Flutter pensata per supportare i membri di una Comunità Energetica Rinnovabile (CER) nell’ottimizzazione dei consumi energetici domestici.

L’app utilizza previsioni meteo open source per stimare le fasce orarie di maggiore produzione solare locale e suggerire quando utilizzare elettrodomestici energivori, come lavatrice, lavastoviglie o ricarica di veicoli elettrici.

---

## Obiettivo dell’applicazione

L’obiettivo dell’app è aiutare gli utenti di una CER a spostare i propri consumi domestici nelle ore in cui la produzione solare prevista è più alta.

In questo modo l’app supporta:

- maggiore utilizzo dell’energia rinnovabile prodotta localmente;
- riduzione degli sprechi energetici;
- migliore pianificazione dei consumi domestici;
- maggiore consapevolezza energetica per i membri della CER.

---

## Tecnologia utilizzata

L’app è sviluppata con:

- Flutter;
- Dart;
- notifiche locali;
- storage locale;
- API meteo open source.

L’app funziona in modalità standalone: non usa backend proprietari o server esterni.

---

## Piattaforma target

La piattaforma principale supportata è:

- Android, tramite file APK.

Flutter permette inoltre la compilazione anche per piattaforme opzionali:

- iOS;
- Web;
- Windows;
- Linux;
- macOS.

---

## Lingue supportate

L’app supporta due lingue:

- Italiano;
- Inglese.

La lingua viene scelta automaticamente in base alla lingua del dispositivo.

Le stringhe localizzate sono gestite tramite file `.arb` nella cartella:

```text
lib/l10n/
```

File principali:

```text
app_it.arb
app_en.arb
```

Sono localizzati:

- testi della Home;
- testi delle previsioni;
- pagina storico;
- notifiche;
- messaggi di errore;
- testi del TTS;
- bottoni principali;
- navigazione inferiore.

---

## Funzionalità principali

### Dashboard principale

La schermata Home mostra:

- città selezionata;
- ora di picco solare prevista;
- fascia oraria consigliata;
- consiglio energetico;
- intensità solare stimata;
- promemoria per il giorno corrente.

Il promemoria di oggi programma:

- una notifica prima dell’inizio della fascia consigliata;
- una notifica alla fine della fascia consigliata.

---

### Previsioni solari

La pagina Previsioni mostra:

- previsioni solari di oggi;
- previsioni solari di domani;
- dettaglio orario;
- situazione attuale;
- miglior fascia prevista per il giorno successivo.

L’utente può scegliere tra:

```text
Oggi / Domani
```

Nella scheda Domani è possibile attivare un promemoria serale per pianificare in anticipo i consumi del giorno successivo.

---

### Notifiche locali

L’app usa notifiche locali, senza backend.

La logica è:

| Tipo promemoria | Quando arriva |
|---|---|
| Promemoria oggi | prima dell’inizio della fascia consigliata |
| Fine fascia oggi | alla fine della fascia consigliata |
| Promemoria domani | la sera prima, alle 20:00 |

Il testo della notifica di domani è riferito esplicitamente al giorno successivo.

Esempio:

```text
Domani conviene usare energia solare.
A Parma, domani la fascia consigliata è 11:00 - 14:00. Picco previsto alle 12:00.
```

Su Android le notifiche programmate usano:

```text
AndroidScheduleMode.inexactAllowWhileIdle
```

Questa scelta aumenta la compatibilità con le policy energetiche Android. L’orario può subire piccoli ritardi gestiti dal sistema operativo.

---

### Storico

L’app salva localmente lo storico dei consigli energetici generati.

Per ogni record vengono salvati:

- città;
- coordinate;
- data;
- fascia consigliata;
- ora di picco;
- intensità massima stimata;
- livello di produzione.

La pagina Storico mostra gli ultimi 7 giorni.

---

### Export CSV

Lo storico può essere esportato in formato CSV.

Il file esportato contiene i dati salvati localmente e può essere condiviso tramite le app installate sul dispositivo.

---

### Risparmio potenziale e CO₂ evitata

L’app mostra una stima del risparmio economico potenziale e della CO₂ evitata.

La stima non rappresenta consumi reali misurati, ma un valore indicativo basato sull’ipotesi che l’utente sposti un consumo domestico nella fascia consigliata.

---

### Accessibilità

L’app include funzionalità pensate anche per utenti ipovedenti:

- testi grandi;
- contrasto elevato;
- supporto tema chiaro/scuro;
- Semantics per screen reader;
- TTS per leggere il consiglio energetico.

---

### Tema chiaro/scuro

L’app supporta:

- tema chiaro;
- tema scuro;
- tema automatico di sistema.

Nel `MaterialApp` viene usato:

```dart
themeMode: ThemeMode.system
```

---

## Dati utilizzati

L’app usa dati meteo e solari open source tramite Open-Meteo.

I principali dati usati sono:

- `global_tilted_irradiance`;
- `cloud_cover`;
- `temperature_2m`;
- coordinate della città selezionata;
- previsioni orarie.

---

# Algoritmo di calcolo

## 1. Intervallo orario considerato

Per il consiglio principale vengono considerate le ore utili della giornata:

```text
08:00 - 18:00
```

La pagina Forecast può mostrare un intervallo più ampio, ad esempio:

```text
08:00 - 20:00
```

---

## 2. Score solare orario

Per ogni ora viene calcolato uno score tra 0 e 1.

Lo score tiene conto di:

- irraggiamento solare;
- nuvolosità;
- temperatura.

---

## 2.1 Irraggiamento

La componente principale è la radiazione solare su piano inclinato:

```text
irradianceScore = globalTiltedIrradiance / 900
```

Il valore viene limitato tra 0 e 1:

```text
irradianceScore = clamp(irradianceScore, 0, 1)
```

Il valore `900 W/m²` è usato come riferimento alto per una buona produzione fotovoltaica.

---

## 2.2 Penalità nuvolosità

La nuvolosità riduce lo score:

```text
cloudScore = 1 - (cloudCover / 100) * 0.25
```

Anche questo valore viene limitato:

```text
cloudScore = clamp(cloudScore, 0, 1)
```

La penalità massima della nuvolosità è quindi del 25%.

---

## 2.3 Penalità temperatura

Temperature molto elevate possono ridurre l’efficienza stimata dei pannelli fotovoltaici.

Se la temperatura è minore o uguale a 30°C:

```text
temperaturePenalty = 0
```

Se la temperatura supera i 30°C:

```text
temperaturePenalty = (temperature - 30) * 0.005
```

La penalità massima viene limitata a 0.15:

```text
temperaturePenalty = clamp(temperaturePenalty, 0, 0.15)
```

Quindi:

```text
temperatureScore = 1 - temperaturePenalty
```

---

## 2.4 Score finale

Lo score finale dell’ora è:

```text
solarScore = irradianceScore * cloudScore * temperatureScore
```

Anche il risultato finale viene limitato tra 0 e 1:

```text
solarScore = clamp(solarScore, 0, 1)
```

---

## 3. Finestra migliore

L’app non sceglie una singola ora isolata, ma una fascia di 3 ore.

Per ogni finestra di 3 ore viene calcolata la media degli score orari:

```text
windowScore = media(solarScore delle ore nella finestra)
```

La fascia consigliata è la finestra con `windowScore` più alto.

Esempio:

```text
11:00 -> score 0.70
12:00 -> score 0.85
13:00 -> score 0.80

windowScore = (0.70 + 0.85 + 0.80) / 3
windowScore = 0.78
```

La fascia consigliata sarà:

```text
11:00 - 14:00
```

---

## 4. Ora di picco

Dentro la finestra migliore, l’ora di picco è quella con il valore massimo di:

```text
globalTiltedIrradiance
```

Formula:

```text
peakHour = ora con max(globalTiltedIrradiance)
```

Esempio:

```text
11:00 -> 620 W/m²
12:00 -> 760 W/m²
13:00 -> 700 W/m²

peakHour = 12:00
```

---

## 5. Livelli di produzione

Lo score medio della finestra migliore viene classificato così:

| Score | Livello |
|---:|---|
| `score >= 0.75` | Produzione alta |
| `score >= 0.50` | Produzione buona |
| `score >= 0.25` | Produzione media |
| `score < 0.25` | Produzione bassa |

Questi livelli vengono poi tradotti in italiano o inglese tramite le stringhe localizzate.

---

# Formula risparmio potenziale

L’app stima un beneficio potenziale assumendo che l’utente sposti nella fascia consigliata un consumo domestico pari a:

```text
assumedShiftedKwh = 1.5 kWh
```

Prezzo energia ipotizzato:

```text
energyPriceEurPerKwh = 0.25 €/kWh
```

Fattore CO₂ ipotizzato:

```text
co2KgPerKwh = 0.25 kg CO₂/kWh
```

---

## Risparmio economico per singolo consiglio

```text
estimatedSavingEuro = assumedShiftedKwh * energyPriceEurPerKwh
```

Esempio:

```text
estimatedSavingEuro = 1.5 * 0.25
estimatedSavingEuro = 0.375 €
```

Arrotondato:

```text
0.38 €
```

---

## CO₂ evitata per singolo consiglio

```text
estimatedCo2Kg = assumedShiftedKwh * co2KgPerKwh
```

Esempio:

```text
estimatedCo2Kg = 1.5 * 0.25
estimatedCo2Kg = 0.375 kg CO₂
```

Arrotondato:

```text
0.38 kg CO₂
```

---

## Stima sugli ultimi 7 giorni

Per gli ultimi 7 giorni:

```text
totalKwh = numeroConsigli * assumedShiftedKwh
```

```text
totalSavingEuro = totalKwh * energyPriceEurPerKwh
```

```text
totalCo2Kg = totalKwh * co2KgPerKwh
```

Esempio con 7 consigli:

```text
totalKwh = 7 * 1.5 = 10.5 kWh
totalSavingEuro = 10.5 * 0.25 = 2.625 €
totalCo2Kg = 10.5 * 0.25 = 2.625 kg CO₂
```

Arrotondato:

```text
Risparmio stimato = 2.63 €
CO₂ evitata stimata = 2.63 kg
```

Questi valori sono indicativi e non sostituiscono una misura reale dei consumi.

---

# Aggiornamento previsioni

Le previsioni vengono aggiornate:

- all’avvio dell’app;
- manualmente tramite pull-to-refresh;
- automaticamente ogni 30 minuti mentre l’app è in uso.

---

# Gestione offline

L’app richiede connessione Internet per recuperare dati meteo e dati di geocoding.

In caso di errore di rete viene mostrato un messaggio all’utente e un pulsante per riprovare.

---

# Installazione e avvio

## Requisiti

- Flutter SDK;
- Dart SDK;
- Android Studio o Android SDK;
- dispositivo Android o emulatore.

---

## Installazione dipendenze

```bash
flutter pub get
```

---


## Build APK release

```bash
flutter build apk --release
```

L’APK viene generato in:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

# Permessi Android

Nel file:

```text
android/app/src/main/AndroidManifest.xml
```

sono richiesti:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

Il permesso `INTERNET` serve per recuperare i dati meteo.

Il permesso `POST_NOTIFICATIONS` serve per mostrare notifiche su Android 13+.

Il permesso `RECEIVE_BOOT_COMPLETED` permette di gestire correttamente notifiche programmate dopo il riavvio del dispositivo, dove supportato.

---

# Struttura progetto

```text
lib/
  forecast/
  history/
  home/
  l10n/
  main/
  models/
  services/
    api/
    repository/
    utils/
  theme/
```

## Cartelle principali

| Cartella | Descrizione |
|---|---|
| `home/` | Dashboard principale e logica Home |
| `forecast/` | Previsioni oggi/domani |
| `history/` | Storico, export CSV e risparmio stimato |
| `models/` | Modelli dati |
| `services/api/` | Chiamate API |
| `services/repository/` | Repository dati |
| `services/utils/` | Utility algoritmo solare, preferenze e calcoli |
| `theme/` | Tema chiaro/scuro |
| `l10n/` | File localizzazione `.arb` |

---

# SBOM

Le dipendenze principali sono dichiarate in `pubspec.yaml`.

| Package | Versione | Uso | Licenza |
|---|---:|---|---|
| flutter | SDK | Framework UI multipiattaforma | BSD-3-Clause |
| flutter_localizations | SDK | Localizzazione Flutter | BSD-3-Clause |
| intl | any | Internazionalizzazione | BSD-3-Clause |
| cupertino_icons | ^1.0.8 | Icone Cupertino | MIT |
| flutter_bloc | ^9.1.1 | Gestione stato con Cubit/BLoC | MIT |
| http | ^1.6.0 | Chiamate HTTP verso API meteo/geocoding | BSD-3-Clause |
| shared_preferences | ^2.5.5 | Salvataggio locale preferenze | BSD-3-Clause |
| flutter_local_notifications | ^21.0.0 | Notifiche locali immediate e programmate | BSD-3-Clause |
| timezone | ^0.11.0 | Gestione timezone notifiche | BSD-3-Clause |
| csv | ^6.0.0 | Generazione CSV | MIT |
| path_provider | ^2.1.5 | Accesso directory locali | BSD-3-Clause |
| share_plus | ^13.1.0 | Condivisione CSV | BSD-3-Clause |
| flutter_tts | ^4.2.5 | Sintesi vocale TTS | MIT |
| flutter_lints | ^6.0.0 | Regole lint | BSD-3-Clause |
| flutter_launcher_icons | ^0.14.4 | Generazione icone app | MIT |

---

# Materiali di consegna

Per la consegna sono previsti:

- codice sorgente completo del progetto Flutter;
- file APK Android;
- README.md;
- SBOM incluso nel README;
- video dimostrativo.

---

# Limitazioni note

- L’app non misura i consumi reali dell’utente.
- Il risparmio economico e la CO₂ evitata sono stime potenziali.
- Le notifiche locali dipendono dalle policy del sistema operativo.
- Su Android, usando notifiche inexact, il sistema può ritardare leggermente l’orario.
- L’app richiede connessione Internet per aggiornare meteo e geocoding.
- Non viene usato un backend esterno: tutta la logica applicativa è locale.

---

# Licenza

Progetto realizzato per finalità dimostrative/hackathon.

Le dipendenze di terze parti sono open source e dichiarate nella sezione SBOM.