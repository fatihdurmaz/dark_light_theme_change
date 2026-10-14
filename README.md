# Day & Night ☀️🌙

**An animated Flutter theme picker with a little world of its own.**

Switch between Light, Dark, and System appearance and watch a landscape change with your theme. The sun sets, the moon rises, clouds dissolve, and a small house lights up beneath a sky full of stars.

The scene is drawn entirely with Flutter's Canvas API—no image assets or animation packages required.

## Features

- **Three appearance modes** — Light, Dark, and System, with System following the device's appearance.
- **Coordinated transitions** — the app theme, bottom sheet, and landscape transition together over one second.
- **Animated sun and moon** — curved paths carry the sun toward the horizon and bring the crescent moon into view.
- **Soft cloud transitions** — clouds blur and fade as daylight gives way to night.
- **Ambient motion** — drifting clouds, twinkling stars, and a recurring shooting star.
- **Small details** — layered hills, celestial glows, and a house window that lights up at night.
- **Continuous reversals** — changing appearance during a transition continues from the current scene state.
- **Stable layout** — the description area reserves space so switching modes does not shift the landscape.

## Try it

1. Open the app and tap **Change Theme**.
2. Choose **Light** or **Dark** to animate the landscape.
3. Choose **System** to follow your device's appearance.
4. Stay in Dark mode to catch the shooting star: it starts approximately **1.45 seconds** after entering the night scene and repeats every **7 seconds**.

Choosing System while the device already matches the current appearance keeps the landscape in its current state.

## Getting started

### Requirements

- A Flutter SDK that includes Dart **3.13.5 or a compatible newer 3.x version**, as required by `pubspec.yaml`.
- An Android emulator, iOS simulator, or connected device.
- The platform toolchain for your target device; iOS development requires macOS and Xcode.

### Run locally

From the project directory:

```bash
flutter pub get
flutter run
```

If multiple devices are available:

```bash
flutter devices
flutter run -d <device-id>
```

Android and iOS project scaffolding is included.

## How it works

`ValueNotifier<ThemeMode>` shares the selected appearance between the settings screen and the picker. System mode resolves the scene's appearance through `MediaQuery.platformBrightnessOf(context)`.

`DayNightScene` uses animation controllers for the appearance transition, ambient motion, and shooting-star timing. `LandscapePainter` blends the day and night colors and draws the sky, clouds, celestial bodies, hills, and house with `CustomPainter`.

The crescent moon uses a cached path that is translated and scaled during movement. When a transition reverses, the next animation starts from the current color blend, keeping the sun and moon positions continuous.

## Project structure

```text
lib/
  main.dart                  App, settings screen, theme picker, and scene painter
test/
  theme_picker_test.dart     Layout regression test for Dark → System selection
android/                    Android project
ios/                        iOS project
```

## Checks

```bash
flutter analyze
flutter test
```

The widget test checks that switching from Dark to System with the same resolved night appearance preserves the scene's position and state on a narrow screen with enlarged text.

## Make it your own

- Adjust `_appTheme` to change the settings screen's palette.
- Change `_themeTransitionDuration` to tune the shared transition speed.
- Update `LandscapePainter` to customize the landscape, celestial paths, and night-sky effects.

---

A small Flutter animation experiment exploring how an everyday setting can feel a little more playful.
