import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/history_entry.dart';

class HistoryRepository {
  static const _historyKey = 'solar_advice_history';

  Future<List<HistoryEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);

    if (raw == null) {
      return [];
    }

    final list = jsonDecode(raw) as List;

    return list
        .map((item) => HistoryEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveEntry(HistoryEntry entry) async {
    final entries = await getEntries();

    final updatedEntries = entries.where((existing) {
      final sameDate = existing.date == entry.date;
      final sameLocation =
          existing.latitude == entry.latitude &&
          existing.longitude == entry.longitude;

      return !(sameDate && sameLocation);
    }).toList();

    updatedEntries.insert(0, entry);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _historyKey,
      jsonEncode(updatedEntries.map((entry) => entry.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}