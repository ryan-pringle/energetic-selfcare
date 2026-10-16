import 'package:flutter/material.dart';

/// The four companions chosen on the Spiritual Guidance Team screen.
class GuidanceSelection {
  const GuidanceSelection({
    this.animal,
    this.archangel,
    this.master,
    this.guide,
  });

  final String? animal;
  final String? archangel;
  final String? master;
  final String? guide;

  static const empty = GuidanceSelection();

  bool get isComplete =>
      _filled(animal) &&
      _filled(archangel) &&
      _filled(master) &&
      _filled(guide);

  int get chosenCount =>
      [animal, archangel, master, guide].where(_filled).length;

  static bool _filled(String? value) =>
      value != null && value.trim().isNotEmpty;

  GuidanceSelection copyWith({
    String? animal,
    String? archangel,
    String? master,
    String? guide,
    bool clearAnimal = false,
    bool clearArchangel = false,
    bool clearMaster = false,
    bool clearGuide = false,
  }) {
    return GuidanceSelection(
      animal: clearAnimal ? null : (animal ?? this.animal),
      archangel: clearArchangel ? null : (archangel ?? this.archangel),
      master: clearMaster ? null : (master ?? this.master),
      guide: clearGuide ? null : (guide ?? this.guide),
    );
  }
}

/// Morning and evening reminder preferences. Times are minutes from midnight.
class ReminderSettings {
  const ReminderSettings({
    required this.morningEnabled,
    required this.eveningEnabled,
    required this.morningMinutes,
    required this.eveningMinutes,
  });

  static const defaults = ReminderSettings(
    morningEnabled: false,
    eveningEnabled: false,
    morningMinutes: 7 * 60,
    eveningMinutes: 21 * 60,
  );

  final bool morningEnabled;
  final bool eveningEnabled;
  final int morningMinutes;
  final int eveningMinutes;

  bool get anyEnabled => morningEnabled || eveningEnabled;

  TimeOfDay get morningTime =>
      TimeOfDay(hour: morningMinutes ~/ 60, minute: morningMinutes % 60);

  TimeOfDay get eveningTime =>
      TimeOfDay(hour: eveningMinutes ~/ 60, minute: eveningMinutes % 60);

  ReminderSettings copyWith({
    bool? morningEnabled,
    bool? eveningEnabled,
    int? morningMinutes,
    int? eveningMinutes,
  }) {
    return ReminderSettings(
      morningEnabled: morningEnabled ?? this.morningEnabled,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      morningMinutes: morningMinutes ?? this.morningMinutes,
      eveningMinutes: eveningMinutes ?? this.eveningMinutes,
    );
  }
}
