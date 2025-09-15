import 'package:floating_timer/models/pomodoro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroStorage {
  static const String _key = 'pomodoro_config';

  static Future<void> savePomodoro(Pomodoro pomodoro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, pomodoro.toJsonString());
  }

  static Future<Pomodoro?> loadPomodoro() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    return Pomodoro.fromJsonString(jsonString);
  }

  static Future<void> clearPomodoro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}