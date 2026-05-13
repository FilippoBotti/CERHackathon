import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/history_entry.dart';

class CsvExportService {
  Future<void> exportHistory(List<HistoryEntry> entries) async {
    final rows = [
      [
        'Città',
        'Latitudine',
        'Longitudine',
        'Data',
        'Fascia consigliata',
        'Picco',
        'Intensità stimata W/m²',
        'Consiglio',
      ],
      ...entries.map(
        (entry) => [
          entry.city,
          entry.latitude,
          entry.longitude,
          entry.date,
          entry.bestTimeRange,
          entry.peakHour,
          entry.maxRadiation.round(),
          entry.advice,
        ],
      ),
    ];

    final csv = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/storico_cer_solar.csv');

    await file.writeAsString(csv);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Storico CER Solar',
    );
  }
}