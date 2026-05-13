import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/csv_export_service.dart';
import '../services/repository/history_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository historyRepository;
  final CsvExportService csvExportService;

  HistoryCubit({
    required this.historyRepository,
    required this.csvExportService,
  }) : super(const HistoryState());

  Future<void> loadHistory() async {
    emit(
      state.copyWith(
        loading: true,
        clearError: true,
      ),
    );

    try {
      final entries = await historyRepository.getEntries();

      emit(
        state.copyWith(
          loading: false,
          entries: entries,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          loading: false,
          error: 'Impossibile caricare lo storico.',
        ),
      );
    }
  }

  Future<void> exportCsv() async {
  if (state.entries.isEmpty) {
    emit(
      state.copyWith(
        error: 'Non ci sono dati da esportare.',
      ),
    );
    return;
  }

  emit(
    state.copyWith(
      exporting: true,
      clearError: true,
    ),
  );

  try {
    await csvExportService.exportHistory(state.entries);

    emit(
      state.copyWith(
        exporting: false,
        clearError: true,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        exporting: false,
        error: 'Errore export CSV: $e',
      ),
    );
  }
}

  Future<void> clearHistory() async {
    emit(
      state.copyWith(
        loading: true,
        clearError: true,
      ),
    );

    try {
      await historyRepository.clear();

      emit(
        state.copyWith(
          loading: false,
          entries: [],
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          loading: false,
          error: 'Impossibile cancellare lo storico.',
        ),
      );
    }
  }
}