import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_city.dart';


class CityPreferencesUtils {
  static const _cityNameKey = 'selected_city_name';
  static const _cityLatKey = 'selected_city_lat';
  static const _cityLonKey = 'selected_city_lon';
  static const _cityCountryKey = 'selected_city_country';

  Future<AppCity?> getSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString(_cityNameKey);
    final lat = prefs.getDouble(_cityLatKey);
    final lon = prefs.getDouble(_cityLonKey);
    final country = prefs.getString(_cityCountryKey);

    if (name == null || lat == null || lon == null) {
      return null;
    }

    return AppCity(
      name: name,
      latitude: lat,
      longitude: lon,
      country: country,
    );
  }

  Future<void> saveSelectedCity(AppCity city) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_cityNameKey, city.name);
    await prefs.setDouble(_cityLatKey, city.latitude);
    await prefs.setDouble(_cityLonKey, city.longitude);

    if (city.country != null) {
      await prefs.setString(_cityCountryKey, city.country!);
    }
  }
}