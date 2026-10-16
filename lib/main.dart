import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:energetic_selfcare/screens/home_screen.dart';
import 'package:energetic_selfcare/services/practice_reminders.dart';
import 'package:energetic_selfcare/state/app_state.dart';
import 'package:energetic_selfcare/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  final state = AppState();
  await state.load();
  await PracticeReminders.instance.init();
  if (state.reminders.anyEnabled) {
    await PracticeReminders.instance.apply(state.reminders);
  }
  runApp(EnergeticSelfcareApp(appState: state));
}

class EnergeticSelfcareApp extends StatefulWidget {
  const EnergeticSelfcareApp({super.key, this.appState});

  final AppState? appState;

  @override
  State<EnergeticSelfcareApp> createState() => _EnergeticSelfcareAppState();
}

class _EnergeticSelfcareAppState extends State<EnergeticSelfcareApp> {
  AppState? _state;

  @override
  void initState() {
    super.initState();
    _state = widget.appState;
    if (_state == null) {
      _load();
    }
  }

  Future<void> _load() async {
    final state = AppState();
    await state.load();
    if (mounted) {
      setState(() => _state = state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    return MaterialApp(
      title: 'Energetic Selfcare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        final framed = _PhoneFrame(child: child ?? const SizedBox.shrink());
        if (state == null) {
          return framed;
        }
        return AppScope(state: state, child: framed);
      },
      home: state == null ? const _BootScreen() : const HomeScreen(),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scaler = media.textScaler.clamp(
      minScaleFactor: 0.9,
      maxScaleFactor: 1.25,
    );
    return MediaQuery(
      data: media.copyWith(textScaler: scaler),
      child: ColoredBox(
        color: Colors.black,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SizedBox(
              height: media.size.height,
              width: double.infinity,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Energetic Selfcare',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
