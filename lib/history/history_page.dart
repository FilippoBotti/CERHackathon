import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/app_localizations.dart';
import '../models/history_entry.dart';
import 'history_cubit.dart';
import 'history_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HistoryCubit>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state.error == null) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        },
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final visibleEntries = _lastSevenDaysEntries(state.entries);

          return RefreshIndicator(
            onRefresh: () => context.read<HistoryCubit>().loadHistory(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  l10n.historyTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.historySubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                _SavingsSummaryCard(entriesCount: visibleEntries.length),
                  const SizedBox(height: 16),
                if (visibleEntries.isEmpty)
                  const _EmptyHistoryView()
                else ...[
                  _ExportCard(
                    exporting: state.exporting,
                    onExport: () {
                      context.read<HistoryCubit>().exportCsv();
                    },
                    onClear: () {
                      _showClearConfirmDialog(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.lastWeek,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 16),
                  ...visibleEntries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _HistoryEntryCard(entry: entry),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  List<HistoryEntry> _lastSevenDaysEntries(List<HistoryEntry> entries) {
    final today = DateTime.now();

    final todayDateOnly = DateTime(today.year, today.month, today.day);

    final sevenDaysAgo = todayDateOnly.subtract(const Duration(days: 6));

    return entries.where((entry) {
      final entryDate = DateTime.tryParse(entry.date);

      if (entryDate == null) {
        return false;
      }

      final entryDateOnly = DateTime(
        entryDate.year,
        entryDate.month,
        entryDate.day,
      );

      return !entryDateOnly.isBefore(sevenDaysAgo) &&
          !entryDateOnly.isAfter(todayDateOnly);
    }).toList();
  }

  Future<void> _showClearConfirmDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteHistoryTitle),
          content: Text(l10n.deleteHistoryMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<HistoryCubit>().clearHistory();
    }
  }
}

class _ExportCard extends StatelessWidget {
  final bool exporting;
  final VoidCallback onExport;
  final VoidCallback onClear;

  const _ExportCard({
    required this.exporting,
    required this.onExport,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.exportData,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.exportCsvDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: exporting ? null : onExport,
                icon: exporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.file_download_outlined),
                label: Text(exporting ? l10n.exporting : l10n.exportCsv),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.clearHistory),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryEntryCard extends StatelessWidget {
  final HistoryEntry entry;

  const _HistoryEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  child: Icon(
                    Icons.location_on_outlined,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.city,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _formatDate(entry.date),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _HistoryInfoRow(
              icon: Icons.schedule_outlined,
              label: l10n.recommendedRangeLabel,
              value: entry.bestTimeRange,
            ),
            const SizedBox(height: 8),
            _HistoryInfoRow(
              icon: Icons.flash_on_outlined,
              label: l10n.peakExpectedLabel,
              value: entry.peakHour,
            ),
            const SizedBox(height: 8),
            _HistoryInfoRow(
              icon: Icons.wb_sunny_outlined,
              label: l10n.estimatedIntensityLabel,
              value: '${entry.maxRadiation.round()} W/m²',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month';
  }
}

class _HistoryInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HistoryInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: textTheme.bodyMedium)),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _EmptyHistoryView extends StatelessWidget {
  const _EmptyHistoryView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(
              Icons.history_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              l10n.emptyHistoryTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyHistoryText,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SavingsSummaryCard extends StatelessWidget {
  final int entriesCount;

  const _SavingsSummaryCard({
    required this.entriesCount,
  });

  static const double assumedShiftedKwh = 1.5;
  static const double energyPriceEurPerKwh = 0.25;
  static const double co2KgPerKwh = 0.25;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final totalKwh = entriesCount * assumedShiftedKwh;
    final totalSaving = totalKwh * energyPriceEurPerKwh;
    final totalCo2 = totalKwh * co2KgPerKwh;

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colors.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 38,
              color: colors.onPrimaryContainer,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.savingsPotentialTitle,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.savingsLastSevenDays,
              style: textTheme.bodyLarge?.copyWith(
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.savingsEstimatedEuro(
                totalSaving.toStringAsFixed(2),
              ),
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.savingsEstimatedCo2(
                totalCo2.toStringAsFixed(2),
              ),
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.savingsExplanation(
                totalKwh.toStringAsFixed(1),
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.savingsBasedOnAdvices(entriesCount),
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
