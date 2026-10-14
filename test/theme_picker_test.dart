import 'package:dark_light_theme_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('System selection keeps the night scene in place', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final selected = ValueNotifier(ThemeMode.dark);
    addTearDown(selected.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 700),
            textScaler: TextScaler.linear(1.25),
          ),
          child: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: selected,
                builder: (context, mode, _) => ThemePickerSheet(
                  selected: mode,
                  isDark: true,
                  onChanged: (mode) => selected.value = mode,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final scene = find.byType(DayNightScene);
    final bounds = tester.getRect(scene);
    final state = tester.state(scene);

    await tester.tap(find.text('System'));
    await tester.pump();
    expect(selected.value, ThemeMode.system);
    expect(tester.getRect(scene), bounds);
    expect(tester.state(scene), same(state));

    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.getRect(scene), bounds);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
