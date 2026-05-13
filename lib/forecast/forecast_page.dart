import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_cubit.dart';
import '../home/home_state.dart';
import '../l10n/app_localizations.dart';
import '../models/solar_hour.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  int selectedDayIndex = 0;

  DateTime get selectedDate {
    return DateTime.now().add(Duration(days: selectedDayIndex));
  }

  String selectedDayLabel(AppLocalizations l10n) {
    return selectedDayIndex == 0
        ? l10n.today.toLowerCase()
        : l10n.tomorrow.toLowerCase();
  }

  SolarHour _findReferenceHour(List<SolarHour> hours) {
    if (selectedDayIndex == 1) {
      return _findBestHour(hours);
    }

    final now = DateTime.now();

    return hours.reduce((closest, current) {
      final closestDifference = closest.time.difference(now).abs();
      final currentDifference = current.time.difference(now).abs();

      if (currentDifference < closestDifference) {
        return current;
      }

      return closest;
    });
  }

  SolarHour _findBestHour(List<SolarHour> hours) {
    return hours.reduce((best, current) {
      final bestScore = SolarForecastUiUtils.solarScore(best);
      final currentScore = SolarForecastUiUtils.solarScore(current);

      if (currentScore > bestScore) {
        return current;
      }

      return best;
    });
  }

  List<SolarHour> _findBestWindow(List<SolarHour> hours) {
    const windowSize = 3;

    final usefulHours = hours.where((hour) {
      return hour.time.hour >= 8 && hour.time.hour <= 18;
    }).toList()..sort((a, b) => a.time.compareTo(b.time));

    if (usefulHours.length <= windowSize) {
      return usefulHours;
    }

    var bestWindow = usefulHours.take(windowSize).toList();
    var bestScore = _averageScore(bestWindow);

    for (var i = 0; i <= usefulHours.length - windowSize; i++) {
      final window = usefulHours.sublist(i, i + windowSize);
      final score = _averageScore(window);

      if (score > bestScore) {
        bestScore = score;
        bestWindow = window;
      }
    }

    return bestWindow;
  }

  double _averageScore(List<SolarHour> hours) {
    final total = hours.fold<double>(
      0,
      (sum, hour) => sum + SolarForecastUiUtils.solarScore(hour),
    );

    return total / hours.length;
  }

  String _formatBestRange(List<SolarHour> bestWindow) {
    if (bestWindow.isEmpty) return '-';

    final start = bestWindow.first.time;
    final end = bestWindow.last.time.add(const Duration(hours: 1));

    return '${_formatHour(start.hour)}:00 - ${_formatHour(end.hour)}:00';
  }

  String _formatHour(int hour) {
    return hour.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return _ForecastErrorView(message: state.error!);
          }

          final day = selectedDate;
          final dayLabel = selectedDayLabel(l10n);

          final usefulHours = state.hours.where((hour) {
            final sameDay =
                hour.time.year == day.year &&
                hour.time.month == day.month &&
                hour.time.day == day.day;

            return sameDay && hour.time.hour >= 8 && hour.time.hour <= 20;
          }).toList()..sort((a, b) => a.time.compareTo(b.time));

          if (usefulHours.isEmpty) {
            return Center(child: Text(l10n.noForecastAvailable));
          }

          final referenceHour = _findReferenceHour(usefulHours);
          final bestWindow = _findBestWindow(usefulHours);
          final bestTimeRange = _formatBestRange(bestWindow);

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadForecast(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  l10n.forecastTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.forecastSubtitle(state.city),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),

                SegmentedButton<int>(
                  segments: [
                    ButtonSegment<int>(
                      value: 0,
                      label: Text(l10n.today),
                      icon: const Icon(Icons.today_outlined),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      label: Text(l10n.tomorrow),
                      icon: const Icon(Icons.event_outlined),
                    ),
                  ],
                  selected: {selectedDayIndex},
                  onSelectionChanged: (value) {
                    setState(() {
                      selectedDayIndex = value.first;
                    });
                  },
                ),

                const SizedBox(height: 24),

                _CurrentSolarCard(
                  currentHour: referenceHour,
                  selectedDayIndex: selectedDayIndex,
                  bestTimeRange: bestTimeRange,
                ),

                if (selectedDayIndex == 1) ...[
                  const SizedBox(height: 24),
                  _ForecastReminderCard(
                    selectedDayLabel: dayLabel,
                    reminderDateTime: state.reminderDateTime,
                    selectedDate: selectedDate,
                    onCancel: () async {
                      await context.read<HomeCubit>().cancelTomorrowReminder();

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.tomorrowReminderCancelled)),
                      );
                    },
                    onSchedule: () async {
                      try {
                        await context
                            .read<HomeCubit>()
                            .scheduleReminderForTomorrow(
                              notificationTitle:
                                  l10n.notificationTomorrowReminderTitle,
                              notificationBodyBuilder:
                                  l10n.notificationTomorrowReminderBody,
                            );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.tomorrowReminderActivated),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString().replaceFirst('Exception: ', ''),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],

                const SizedBox(height: 16),

                Text(
                  l10n.hourlyForecastFor(dayLabel),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ...usefulHours.map(
                  (hour) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SolarHourTile(hour: hour),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CurrentSolarCard extends StatelessWidget {
  final SolarHour currentHour;
  final int selectedDayIndex;
  final String bestTimeRange;

  const _CurrentSolarCard({
    required this.currentHour,
    required this.selectedDayIndex,
    required this.bestTimeRange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final score = SolarForecastUiUtils.solarScore(currentHour);
    final level = SolarForecastUiUtils.levelLabel(context, score);
    final message = SolarForecastUiUtils.messageForScore(context, score);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isTomorrow = selectedDayIndex == 1;
    final title = isTomorrow ? l10n.bestExpectedMoment : l10n.currentSituation;

    final semanticsLabel = isTomorrow
        ? '$title. ${l10n.recommendedRange(bestTimeRange)}. '
            '$level. $message. ${l10n.forecastForHour(currentHour.hourLabel)}.'
        : '$title. $level. $message. '
            '${l10n.forecastForHour(currentHour.hourLabel)}. ${l10n.pullToRefresh}.';

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: Card(
        elevation: 0,
        color: colors.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Icon(
                  SolarForecastUiUtils.iconForScore(score),
                  size: 42,
                  color: colors.onSecondaryContainer,
                ),
              ),

              // const SizedBox(height: 16),

              // Text(
              //   title,
              //   style: textTheme.titleMedium?.copyWith(
              //     fontWeight: FontWeight.w600,
              //     color: colors.onSecondaryContainer,
              //   ),
              // ),

              if (isTomorrow) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.recommendedRange(bestTimeRange),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              Text(
                level,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSecondaryContainer,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                message,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSecondaryContainer,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                '${currentHour.globalTiltedIrradiance.round()} W/m² · '
                '${l10n.cloudCover} ${currentHour.cloudCover.round()}% · '
                '${currentHour.temperature.round()}°C',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSecondaryContainer,
                ),
              ),

              const SizedBox(height: 16),

              Divider(
                color: colors.onSecondaryContainer.withValues(alpha: 0.25),
              ),

              const SizedBox(height: 8),

              Text(
                l10n.forecastForHour(currentHour.hourLabel),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSecondaryContainer,
                ),
              ),

              if (!isTomorrow) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.pullToRefresh,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ForecastReminderCard extends StatelessWidget {
  final String selectedDayLabel;
  final DateTime? reminderDateTime;
  final DateTime selectedDate;
  final VoidCallback onSchedule;
  final VoidCallback onCancel;

  const _ForecastReminderCard({
    required this.selectedDayLabel,
    required this.reminderDateTime,
    required this.selectedDate,
    required this.onSchedule,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isActiveForSelectedDay = _isSameDay(reminderDateTime, selectedDate);
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reminder,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isActiveForSelectedDay
                  ? l10n.reminderAlreadyActiveFor(selectedDayLabel)
                  : l10n.reminderDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            if (isActiveForSelectedDay) ...[
              Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.activeAt(_formatTime(reminderDateTime!)),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.notifications_off_outlined),
                  label: Text(l10n.cancelTomorrowReminder),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onSchedule,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: Text(l10n.activateReminderFor(selectedDayLabel)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime? a, DateTime b) {
    if (a == null) return false;

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

class _SolarHourTile extends StatelessWidget {
  final SolarHour hour;

  const _SolarHourTile({required this.hour});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final score = SolarForecastUiUtils.solarScore(hour);
    final level = SolarForecastUiUtils.levelLabel(context, score);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                hour.hourLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(child: Icon(SolarForecastUiUtils.iconForScore(score))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${hour.globalTiltedIrradiance.round()} W/m² · ${l10n.cloudCover} ${hour.cloudCover.round()}% · ${hour.temperature.round()}°C',
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: score,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SolarForecastUiUtils {
  static double solarScore(SolarHour hour) {
    final irradianceScore = (hour.globalTiltedIrradiance / 900).clamp(0.0, 1.0);

    final cloudScore = (1 - (hour.cloudCover / 100) * 0.25).clamp(0.0, 1.0);

    final temperaturePenalty = hour.temperature > 30
        ? ((hour.temperature - 30) * 0.005).clamp(0.0, 0.15)
        : 0.0;

    final temperatureScore = 1 - temperaturePenalty;

    return (irradianceScore * cloudScore * temperatureScore).clamp(0.0, 1.0);
  }

  static String levelLabel(BuildContext context, double score) {
    final l10n = AppLocalizations.of(context)!;

    if (score >= 0.75) {
      return l10n.productionHigh;
    }

    if (score >= 0.50) {
      return l10n.productionGood;
    }

    if (score >= 0.25) {
      return l10n.productionMedium;
    }

    return l10n.productionLow;
  }

  static String messageForScore(BuildContext context, double score) {
    final l10n = AppLocalizations.of(context)!;

    if (score >= 0.75) {
      return l10n.scoreMessageHigh;
    }

    if (score >= 0.50) {
      return l10n.scoreMessageGood;
    }

    if (score >= 0.25) {
      return l10n.scoreMessageMedium;
    }

    return l10n.scoreMessageLow;
  }

  static IconData iconForScore(double score) {
    if (score >= 0.75) {
      return Icons.wb_sunny;
    }

    if (score >= 0.50) {
      return Icons.wb_cloudy;
    }

    if (score >= 0.25) {
      return Icons.cloud_outlined;
    }

    return Icons.nights_stay_outlined;
  }
}

class _ForecastErrorView extends StatelessWidget {
  final String message;

  const _ForecastErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 52),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeCubit>().loadForecast();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
