import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cer_community_app/l10n/app_localizations.dart';
import '../services/utils/solar_advice_utils.dart';

import 'home_cubit.dart';
import 'home_state.dart';
import '../models/app_city.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String _adviceTextForLevel(
      AppLocalizations l10n,
      SolarProductionLevel? level,
    ) {
      switch (level) {
        case SolarProductionLevel.high:
          return l10n.solarAdviceHigh;
        case SolarProductionLevel.good:
          return l10n.solarAdviceGood;
        case SolarProductionLevel.medium:
          return l10n.solarAdviceMedium;
        case SolarProductionLevel.low:
          return l10n.solarAdviceLow;
        case SolarProductionLevel.unavailable:
        case null:
          return l10n.noAdviceAvailable;
      }
    }

    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return _ErrorView(message: state.error!);
          }

          if (!state.hasSelectedCity) {
            return _FirstCitySelectionView(
              searching: state.searchingCity,
              results: state.cityResults,
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadForecast(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  l10n.homeTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.energyAdviceFor(state.city),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                _CitySearchBox(
                  searching: state.searchingCity,
                  results: state.cityResults,
                ),
                const SizedBox(height: 12),

                _MainAdviceCard(
                  bestTimeRange: state.bestTimeRange ?? '-',
                  advice: _adviceTextForLevel(l10n, state.adviceLevel),
                  maxRadiation: state.maxRadiation,
                  peakHour: state.peakHour ?? '-',
                  reminderActive: state.reminderActiveToday,
                  reminderTime: state.reminderActiveToday
                      ? state.reminderTime
                      : null,
                  onSpeakPressed: () {
                    final adviceText = _adviceTextForLevel(
                      l10n,
                      state.adviceLevel,
                    );

                    final languageCode =
                        Localizations.localeOf(context).languageCode == 'en'
                        ? 'en-US'
                        : 'it-IT';

                    context.read<HomeCubit>().speakAdvice(
                      languageCode: languageCode,
                      text: l10n.ttsAdviceText(
                        state.city,
                        state.peakHour ?? '-',
                        state.bestTimeRange ?? '-',
                        adviceText,
                      ),
                    );
                  },
                  onReminderPressed: () async {
                    try {
                      await context.read<HomeCubit>().scheduleReminder(
                        notificationTitle: l10n.notificationReminderTitle,
                        notificationBodyBuilder: l10n.notificationReminderBody,
                        notificationEndTitle: l10n.notificationEndTitle,
                        notificationEndBodyBuilder: l10n.notificationEndBody,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.reminderActivated)),
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
                  onCancelReminderPressed: () async {
                    await context.read<HomeCubit>().cancelTodayReminder();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.reminderCancelled)),
                    );
                  },
                ),

                const SizedBox(height: 16),

                const _QuickActionsCard(),

                const SizedBox(height: 16),

                _InfoCard(
                  title: l10n.goalTitle,
                  text: l10n.goalText,
                  icon: Icons.energy_savings_leaf_outlined,
                ),

                const SizedBox(height: 16),

                _InfoCard(
                  title: l10n.whyCerTitle,
                  text: l10n.whyCerText,
                  icon: Icons.groups_outlined,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MainAdviceCard extends StatelessWidget {
  final String bestTimeRange;
  final String advice;
  final double? maxRadiation;
  final String? peakHour;
  final bool reminderActive;
  final String? reminderTime;
  final VoidCallback onReminderPressed;
  final VoidCallback onCancelReminderPressed;
  final VoidCallback onSpeakPressed;

  const _MainAdviceCard({
    required this.bestTimeRange,
    required this.advice,
    required this.maxRadiation,
    required this.peakHour,
    required this.reminderActive,
    required this.reminderTime,
    required this.onReminderPressed,
    required this.onCancelReminderPressed,
    required this.onSpeakPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final peak = peakHour ?? '-';

    return Semantics(
      container: true,
      label: l10n.bestMomentTodaySemantic(
        peak,
        bestTimeRange,
        advice,
      ),
      child: Card(
        elevation: 0,
        color: colors.primaryContainer,
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
                  Icons.wb_sunny_rounded,
                  size: 42,
                  color: colors.onPrimaryContainer,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                l10n.bestMomentTodayAt,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onPrimaryContainer,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                peak,
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.onPrimaryContainer,
                ),
              ),
        const SizedBox(height: 8),

              Text(
                l10n.recommendedRange(bestTimeRange),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                advice,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onPrimaryContainer,
                ),
              ),

              if (reminderActive && reminderTime != null) ...[
                const SizedBox(height: 20),
                Semantics(
                  label: l10n.activeReminderToday(reminderTime!),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.activeReminderToday(reminderTime!),
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              if (!reminderActive) ...[
                Semantics(
                  button: true,
                  label: l10n.sendReminderSemantic,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onReminderPressed,
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: Text(l10n.sendReminder),
                    ),
                  ),
                ),
              ] else ...[
                Semantics(
                  button: true,
                  label: l10n.cancelReminderSemantic,
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onCancelReminderPressed,
                      icon: const Icon(Icons.notifications_off_outlined),
                      label: Text(l10n.cancelReminder),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 18),

              Divider(
                color: colors.onPrimaryContainer.withValues(alpha: 0.25),
              ),

              

              if (maxRadiation != null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.estimatedSolarIntensity(maxRadiation!.round()),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ],

              const SizedBox(height: 6),

              Text(
                l10n.pullToRefresh,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final actions = [
      _EnergyAction(
        icon: Icons.local_laundry_service_outlined,
        title: l10n.washingMachine,
        subtitle: l10n.washingMachineSubtitle,
      ),
      _EnergyAction(
        icon: Icons.dining_outlined,
        title: l10n.dishwasher,
        subtitle: l10n.dishwasherSubtitle,
      ),
      _EnergyAction(
        icon: Icons.electric_car_outlined,
        title: l10n.evCharging,
        subtitle: l10n.evChargingSubtitle,
      ),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.whatToUse,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...actions.map(
              (action) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(child: Icon(action.icon)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(action.subtitle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(text),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

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

class _EnergyAction {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EnergyAction({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _CitySearchBox extends StatefulWidget {
  final bool searching;
  final List<AppCity> results;

  const _CitySearchBox({required this.searching, required this.results});

  @override
  State<_CitySearchBox> createState() => _CitySearchBoxState();
}

class _CitySearchBoxState extends State<_CitySearchBox> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _search() {
    context.read<HomeCubit>().searchCity(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: l10n.searchCity,
            hintText: l10n.searchCityHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.searching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    onPressed: _search,
                    icon: const Icon(Icons.arrow_forward),
                  ),
          ),
          onSubmitted: (_) => _search(),
        ),
        if (widget.results.isNotEmpty) ...[
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            child: Column(
              children: widget.results.map((city) {
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(city.name),
                  subtitle: Text(city.country ?? ''),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    controller.clear();
                    context.read<HomeCubit>().changeCity(city);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _FirstCitySelectionView extends StatelessWidget {
  final bool searching;
  final List<AppCity> results;

  const _FirstCitySelectionView({
    required this.searching,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 48),
        Icon(
          Icons.energy_savings_leaf_outlined,
          size: 72,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.welcomeTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.welcomeText,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.chooseCity,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _CitySearchBox(searching: searching, results: results),
      ],
    );
  }
}
