import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:energetic_selfcare/config/editable.dart';
import 'package:energetic_selfcare/layout/phone_scale.dart';
import 'package:energetic_selfcare/models/settings.dart';
import 'package:energetic_selfcare/services/practice_reminders.dart';
import 'package:energetic_selfcare/state/app_state.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  String? _note;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final reminders = state.reminders;
    final scale = PhoneScale(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: ListView(
        padding: scale.pageInsets(),
        children: [
          Text(
            'Twice a day is the rhythm: once in the morning, once in the evening.',
            style: text.bodyLarge,
          ),
          SizedBox(height: scale.gap(12)),
          Text(
            reminders.anyEnabled
                ? 'Your chosen times are saved on this device.'
                : 'Reminders are off. Turn on morning or evening when you want a gentle call back to the field.',
            style: text.bodyMedium,
          ),
          SizedBox(height: scale.gap(18)),
          _ReminderTile(
            title: 'Morning',
            enabled: reminders.morningEnabled,
            minutes: reminders.morningMinutes,
            onToggle: (value) =>
                _update(state, reminders.copyWith(morningEnabled: value)),
            onTime: (minutes) => _update(
              state,
              reminders.copyWith(morningMinutes: minutes, morningEnabled: true),
            ),
          ),
          SizedBox(height: scale.gap(12)),
          _ReminderTile(
            title: 'Evening',
            enabled: reminders.eveningEnabled,
            minutes: reminders.eveningMinutes,
            onToggle: (value) =>
                _update(state, reminders.copyWith(eveningEnabled: value)),
            onTime: (minutes) => _update(
              state,
              reminders.copyWith(eveningMinutes: minutes, eveningEnabled: true),
            ),
          ),
          SizedBox(height: scale.gap(18)),
          Text(
            kIsWeb
                ? 'These times are saved here. Notifications fire on the phone install, not in the browser.'
                : 'Alerts arrive on this phone even when the app is closed.',
            style: text.bodyMedium,
          ),
          if (_note != null) ...[
            SizedBox(height: scale.gap(12)),
            Text(
              _note!,
              style: text.bodyMedium?.copyWith(color: Editable.accentYellow),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _update(AppState state, ReminderSettings next) async {
    await state.setReminders(next);
    if (kIsWeb) {
      setState(() {
        _note = 'Times are saved here. Open the phone app for the actual reminders.';
      });
      return;
    }
    if (next.anyEnabled) {
      final allowed = await PracticeReminders.instance.ensurePermission();
      if (!allowed && mounted) {
        setState(() {
          _note = 'Notifications are turned off for this app in the phone settings.';
        });
        return;
      }
    }
    if (mounted) {
      setState(() => _note = null);
    }
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.title,
    required this.enabled,
    required this.minutes,
    required this.onToggle,
    required this.onTime,
  });

  final String title;
  final bool enabled;
  final int minutes;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onTime;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF101010),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () => _pick(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: Editable.accentYellow,
                    ),
                    child: Text(_format(minutes)),
                  ),
                ],
              ),
            ),
            Switch(value: enabled, onChanged: onToggle),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked != null) {
      onTime(picked.hour * 60 + picked.minute);
    }
  }

  String _format(int value) {
    final hour24 = value ~/ 60;
    final minute = value % 60;
    final period = hour24 >= 12 ? 'pm' : 'am';
    final hour = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour:${minute.toString().padLeft(2, '0')} $period';
  }
}
