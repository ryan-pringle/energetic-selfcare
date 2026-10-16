# Run Energetic Selfcare in Android Studio

You need Flutter installed on your machine, and Android Studio with an emulator (or a USB phone).

## 1. Install Flutter (once)

- Install Flutter: https://docs.flutter.dev/get-started/install
- Add Flutter to your PATH, then check:
  ```bash
  flutter doctor
  ```
- Accept Android licenses if asked:
  ```bash
  flutter doctor --android-licenses
  ```

## 2. Open this project in Android Studio

1. Open **Android Studio**.
2. **File → Open…** and choose the project root folder (the one that contains `pubspec.yaml`, `lib/`, and `android/`).
   - Do **not** open only the inner `android/` folder.
3. If Android Studio asks to install the **Flutter** and **Dart** plugins, install them and restart the IDE.
4. Wait for indexing / Gradle sync to finish.

## 3. Get packages

In Android Studio’s terminal (or any terminal in the project root):

```bash
flutter pub get
```

Optional check:

```bash
flutter analyze
```

## 4. Start an emulator

1. Open **Device Manager** (phone icon in the toolbar, or **Tools → Device Manager**).
2. Create a virtual device if you do not have one (Pixel phone, recent API is fine).
3. Press ▶ to start the emulator and wait until the home screen appears.

Or plug in a phone with USB debugging enabled.

## 5. Run the app

Either:

- Select the emulator in the device dropdown at the top of Android Studio, then press the green **Run** ▶ button,

or in the terminal:

```bash
flutter devices
flutter run
```

Pick the Android emulator when Flutter lists it.

## If something fails

- `flutter doctor` should show a ✓ for Android toolchain and connected devices.
- If Gradle complains, let Android Studio finish its first sync, then run again.
- Reminder notifications only fire on a real phone/emulator install, not in a browser.
