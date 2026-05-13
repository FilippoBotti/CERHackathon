import 'package:shared_preferences/shared_preferences.dart';

class ReminderPreferencesUtils {
  static const String _reminderDateTimeKey = 'reminder_date_time';

  Future<void> saveReminderDateTime(DateTime dateTime) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _reminderDateTimeKey,
      dateTime.toIso8601String(),
    );
  }

  Future<DateTime?> getReminderDateTime() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(_reminderDateTimeKey);

    if (value == null) return null;

    return DateTime.tryParse(value);
  }

  Future<void> clearReminderDateTime() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_reminderDateTimeKey);
  }
}