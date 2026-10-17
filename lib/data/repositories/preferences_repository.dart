import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories.dart';

class PreferencesRepository implements SettingsRepository {
  PreferencesRepository(this._preferences);
  final SharedPreferencesAsync _preferences;
  @override
  Future<bool> getAutoPlay() async =>
      await _preferences.getBool('auto_play') ?? false;
  @override
  Future<void> setAutoPlay(bool value) =>
      _preferences.setBool('auto_play', value);
}
