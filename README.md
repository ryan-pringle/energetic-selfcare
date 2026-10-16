# Energetic Selfcare

A portrait phone app for a twice-daily energetic practice. Three guided sequences — Protection, Selfcare, and Transition — light chakra points, a white energy field, and a gold shield on a gender-neutral figure while the words of the practice stay on screen. A short guide explains the field and each point. A spiritual guidance team and morning/evening reminders are saved on the device.

The look is Material 3 on a black ground. Android, iOS, and web all build from this project.

## Run on an Android emulator (recommended)

See **[ANDROID_STUDIO.md](ANDROID_STUDIO.md)** for exact Android Studio steps.

Short version from the project root:

```bash
flutter pub get
flutter devices
flutter run
```

Checks:

```bash
flutter analyze
flutter test
```

## Edit colours, lists, and links

| What | Where |
| --- | --- |
| Chakra colours and website/course URLs | [`lib/config/editable.dart`](lib/config/editable.dart) |
| Spirit animals | [`assets/data/spirit_animals.json`](assets/data/spirit_animals.json) |
| Archangels | [`assets/data/archangel.json`](assets/data/archangel.json) |
| Ascended masters | [`assets/data/ascended_master.json`](assets/data/ascended_master.json) |
| Level notes | [`assets/data/level_*.json`](assets/data/) |
| Brand and corner icons | [`assets/brand/`](assets/brand/), [`assets/icons/`](assets/icons/) |

The guide name is typed in the app. Energise mantras follow the level JSON packs (`I Link`, `I Am`, `My Team`, and so on).

## Reminders

Morning and evening times are stored with `shared_preferences`. On a phone, `flutter_local_notifications` schedules them and asks for notification permission when a reminder is turned on. In the browser the same times are saved, and the screen says that notifications fire on the phone install.

## Practices

Each sequence advances on a timer. Tap the figure to continue, or pause. Points that have already lit stay lit. The current point pulses. The white field brightens during the aura cleanse. The gold shield appears when protection is asked and stays. The closing line remains, with Replay and Home.
