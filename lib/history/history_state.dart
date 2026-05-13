import '../models/history_entry.dart';
import '../services/utils/solar_advice_utils.dart';

class HistoryState {
  final bool loading;
  final bool exporting;
  final String? error;
  final List<HistoryEntry> entries;
  final SolarProductionLevel? adviceLevel;

  const HistoryState({
    this.loading = false,
    this.exporting = false,
    this.error,
    this.entries = const [],
    this.adviceLevel,
  });

  bool get isEmpty => entries.isEmpty;

  HistoryState copyWith({
    bool? loading,
    bool? exporting,
    String? error,
    bool clearError = false,
    List<HistoryEntry>? entries,
    SolarProductionLevel? adviceLevel,
  }) {
    return HistoryState(
      loading: loading ?? this.loading,
      exporting: exporting ?? this.exporting,
      error: clearError ? null : error ?? this.error,
      entries: entries ?? this.entries,
      adviceLevel: adviceLevel ?? this.adviceLevel,
    );
  }
}