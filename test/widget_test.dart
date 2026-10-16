import 'package:energetic_selfcare/main.dart';
import 'package:energetic_selfcare/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home opens the protection practice', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();

    await tester.pumpWidget(EnergeticSelfcareApp(appState: state));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Energetic Selfcare'), findsWidgets);
    expect(find.text('Energetic Protection'), findsOneWidget);

    await tester.tap(find.text('Energetic Protection'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('I ask for grounding'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('guidance starts unnamed and reminders start off', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();
    await tester.pumpWidget(EnergeticSelfcareApp(appState: state));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.scrollUntilVisible(find.text('Spiritual Guidance Team'), 200);
    await tester.tap(find.text('Spiritual Guidance Team'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('No one is named yet'), findsOneWidget);

    await tester.tap(find.text('Animal totem'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    // spirit_animals.json starts with Ant.
    await tester.tap(find.text('Ant').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Ant'), findsOneWidget);
    expect(find.text('You are supported and guided'), findsNothing);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.scrollUntilVisible(find.text('Reminders'), 200);
    await tester.tap(find.text('Reminders'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('Reminders are off'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
