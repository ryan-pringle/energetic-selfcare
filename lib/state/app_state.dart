import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:energetic_selfcare/models/settings.dart';
import 'package:energetic_selfcare/services/practice_reminders.dart';

class AppState extends ChangeNotifier {
  GuidanceSelection guidance = GuidanceSelection.empty;
  ReminderSettings reminders = ReminderSettings.defaults;
  bool ready = false;

  SharedPreferences? _prefs;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    guidance = GuidanceSelection(
      animal: _read(prefs, _animalKey),
      archangel: _read(prefs, _archangelKey),
      master: _read(prefs, _masterKey),
      guide: _read(prefs, _guideKey),
    );
    reminders = ReminderSettings(
      morningEnabled: prefs.getBool(_morningOnKey) ?? false,
      eveningEnabled: prefs.getBool(_eveningOnKey) ?? false,
      morningMinutes: prefs.getInt(_morningMinKey) ?? 7 * 60,
      eveningMinutes: prefs.getInt(_eveningMinKey) ?? 21 * 60,
    );
    ready = true;
    notifyListeners();
  }

  Future<void> setAnimal(String? name) =>
      _setGuidance(guidance.copyWith(animal: name, clearAnimal: _blank(name)));

  Future<void> setArchangel(String? name) => _setGuidance(
    guidance.copyWith(archangel: name, clearArchangel: _blank(name)),
  );

  Future<void> setMaster(String? name) =>
      _setGuidance(guidance.copyWith(master: name, clearMaster: _blank(name)));

  Future<void> setGuide(String? name) =>
      _setGuidance(guidance.copyWith(guide: name, clearGuide: _blank(name)));

  Future<void> setReminders(ReminderSettings next) async {
    reminders = next;
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    await prefs.setBool(_morningOnKey, next.morningEnabled);
    await prefs.setBool(_eveningOnKey, next.eveningEnabled);
    await prefs.setInt(_morningMinKey, next.morningMinutes);
    await prefs.setInt(_eveningMinKey, next.eveningMinutes);
    await PracticeReminders.instance.apply(next);
    notifyListeners();
  }

  Future<void> _setGuidance(GuidanceSelection next) async {
    guidance = next;
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    await _write(prefs, _animalKey, next.animal);
    await _write(prefs, _archangelKey, next.archangel);
    await _write(prefs, _masterKey, next.master);
    await _write(prefs, _guideKey, next.guide);
    notifyListeners();
  }

  static String? _read(SharedPreferences prefs, String key) {
    final value = prefs.getString(key);
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value;
  }

  static Future<void> _write(
    SharedPreferences prefs,
    String key,
    String? value,
  ) async {
    if (value == null || value.trim().isEmpty) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value.trim());
    }
  }

  static bool _blank(String? value) => value == null || value.trim().isEmpty;

  static const _animalKey = 'guidance_animal';
  static const _archangelKey = 'guidance_archangel';
  static const _masterKey = 'guidance_master';
  static const _guideKey = 'guidance_guide';
  static const _morningOnKey = 'reminder_morning_on';
  static const _eveningOnKey = 'reminder_evening_on';
  static const _morningMinKey = 'reminder_morning_min';
  static const _eveningMinKey = 'reminder_evening_min';
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({required AppState state, required super.child, super.key})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this widget.');
    return scope!.notifier!;
  }
}
