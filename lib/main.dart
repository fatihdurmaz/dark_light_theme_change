import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

const _themeTransitionDuration = Duration(milliseconds: 1000);

ThemeData _appTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final background = isDark ? const Color(0xFF08080A) : const Color(0xFFF0F1F4);
  final surface = isDark ? const Color(0xFF19191B) : Colors.white;
  final text = isDark ? const Color(0xFFF4F4F6) : const Color(0xFF242424);
  final muted = isDark ? const Color(0xFFA2A2AA) : const Color(0xFF686872);
  final accent = isDark ? const Color(0xFFAAA5FF) : const Color(0xFF2379B5);
  final colors = ColorScheme.fromSeed(seedColor: accent, brightness: brightness)
      .copyWith(
        primary: accent,
        onPrimary: isDark ? const Color(0xFF191337) : Colors.white,
        surface: surface,
        onSurface: text,
        onSurfaceVariant: muted,
        surfaceContainerLow: surface,
        outlineVariant: isDark
            ? const Color(0xFF2C2C32)
            : const Color(0xFFE2E3E8),
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 24,
      toolbarHeight: 84,
      titleTextStyle: TextStyle(
        color: text,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: -.8,
      ),
    ),
  );
}

void main() => runApp(const ThemeTransitionDemo());

class ThemeTransitionDemo extends StatefulWidget {
  const ThemeTransitionDemo({super.key});

  @override
  State<ThemeTransitionDemo> createState() => _ThemeTransitionDemoState();
}

class _ThemeTransitionDemoState extends State<ThemeTransitionDemo> {
  final ValueNotifier<ThemeMode> _mode = ValueNotifier(ThemeMode.light);

  @override
  void dispose() {
    _mode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _mode,
      builder: (context, mode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Animated Theme Picker',
        theme: _appTheme(Brightness.light),
        darkTheme: _appTheme(Brightness.dark),
        themeMode: mode,
        themeAnimationDuration: _themeTransitionDuration,
        themeAnimationCurve: Curves.easeInOutCubic,
        home: ThemeSettingsPage(mode: _mode),
      ),
    );
  }
}

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key, required this.mode});

  final ValueNotifier<ThemeMode> mode;

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: mode,
        builder: (context, selected, _) {
          final deviceDark =
              MediaQuery.platformBrightnessOf(context) == Brightness.dark;
          final actualDark =
              selected == ThemeMode.dark ||
              (selected == ThemeMode.system && deviceDark);
          return ThemePickerSheet(
            selected: selected,
            isDark: actualDark,
            onChanged: (next) => mode.value = next,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Text(
            'APPEARANCE',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: colors.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: mode,
              builder: (context, selected, _) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    switch (selected) {
                      ThemeMode.light => Icons.wb_sunny_rounded,
                      ThemeMode.dark => Icons.nightlight_round,
                      ThemeMode.system => Icons.brightness_auto_rounded,
                    },
                    size: 22,
                    color: colors.primary,
                  ),
                ),
                title: Text(
                  'Change Theme',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    switch (selected) {
                      ThemeMode.light => 'Light appearance',
                      ThemeMode.dark => 'Dark appearance',
                      ThemeMode.system => 'Follows your device',
                    },
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: colors.onSurfaceVariant,
                  size: 22,
                ),
                onTap: () => _showThemePicker(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemePickerSheet extends StatelessWidget {
  const ThemePickerSheet({
    super.key,
    required this.selected,
    required this.isDark,
    required this.onChanged,
  });

  final ThemeMode selected;
  final bool isDark;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final sheetColor = isDark
        ? const Color(0xFF19191B)
        : const Color(0xFFF6F6F7);
    final textColor = isDark ? Colors.white : const Color(0xFF242424);
    final mutedColor = isDark
        ? const Color(0xFF9A9A9E)
        : const Color(0xFF88888D);
    return SafeArea(
      top: false,
      child: AnimatedContainer(
        duration: _themeTransitionDuration,
        curve: Curves.easeInOutCubic,
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 5,
              decoration: BoxDecoration(
                color: mutedColor.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: AspectRatio(
                aspectRatio: 2.04,
                child: DayNightScene(isDark: isDark),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF29292C)
                    : const Color(0xFFE9E9EB),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  _option(
                    ThemeMode.light,
                    'Light',
                    Icons.wb_sunny_rounded,
                    textColor,
                  ),
                  _option(
                    ThemeMode.dark,
                    'Dark',
                    Icons.nightlight_round,
                    textColor,
                  ),
                  _option(
                    ThemeMode.system,
                    'System',
                    Icons.brightness_auto_rounded,
                    textColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 11),
            // Reserve the tallest description so switching to System cannot
            // shift the scene when the other descriptions wrap onto two lines.
            Stack(
              alignment: Alignment.center,
              children: [
                for (final option in ThemeMode.values)
                  Visibility(
                    visible: selected == option,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Text(
                      option == ThemeMode.system
                          ? 'Matches your phone settings, day and night.'
                          : '${option == ThemeMode.light ? 'Light' : 'Dark'} appearance stays on, day and night.',
                      style: TextStyle(fontSize: 12, color: mutedColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(
    ThemeMode value,
    String title,
    IconData icon,
    Color textColor,
  ) {
    final isSelected = selected == value;
    final accent = isDark ? const Color(0xFF7F7BFF) : const Color(0xFFF0BC24);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          height: 39,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF111113) : const Color(0xFFFCFCFD))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected ? accent : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 17, color: isSelected ? accent : textColor),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DayNightScene extends StatefulWidget {
  const DayNightScene({super.key, required this.isDark});

  final bool isDark;

  @override
  State<DayNightScene> createState() => _DayNightSceneState();
}

class _DayNightSceneState extends State<DayNightScene>
    with TickerProviderStateMixin {
  late final AnimationController _change;
  late final AnimationController _ambient;
  late final AnimationController _shootingStar;
  late double _fromDark;
  late double _toDark;

  @override
  void initState() {
    super.initState();
    _fromDark = _toDark = widget.isDark ? 1 : 0;
    _change = AnimationController(
      vsync: this,
      duration: _themeTransitionDuration,
      value: 1,
    );
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _shootingStar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    if (widget.isDark) _shootingStar.repeat();
  }

  @override
  void didUpdateWidget(covariant DayNightScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark != widget.isDark) {
      _fromDark = ui.lerpDouble(
        _fromDark,
        _toDark,
        Curves.easeInOutCubic.transform(_change.value),
      )!;
      _toDark = widget.isDark ? 1 : 0;
      _change.forward(from: 0);
      if (widget.isDark) {
        _shootingStar.reset();
        _shootingStar.repeat();
      } else {
        _shootingStar.stop();
      }
    }
  }

  @override
  void dispose() {
    _change.dispose();
    _ambient.dispose();
    _shootingStar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_change, _ambient, _shootingStar]),
        builder: (context, _) {
          final motion = Curves.easeInOutCubic.transform(_change.value);
          final darkness = ui.lerpDouble(_fromDark, _toDark, motion)!;
          return CustomPaint(
            painter: LandscapePainter(
              darkness: darkness,
              ambient: _ambient.value,
              shootingStar: _shootingStar.value,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class LandscapePainter extends CustomPainter {
  // Keep the crescent geometry independent of its animated screen position.
  static const _moonPathRadius = 100.0;
  static final Path _moonPath = Path.combine(
    PathOperation.difference,
    Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: _moonPathRadius)),
    Path()..addOval(
      Rect.fromCircle(
        center: const Offset(_moonPathRadius * .47, -_moonPathRadius * .42),
        radius: _moonPathRadius * .89,
      ),
    ),
  );

  const LandscapePainter({
    required this.darkness,
    required this.ambient,
    required this.shootingStar,
  });

  final double darkness;
  final double ambient;
  final double shootingStar;

  Color mix(Color day, Color night) => Color.lerp(day, night, darkness)!;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.save();
    canvas.clipRect(bounds);

    canvas.drawRect(
      bounds,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            mix(const Color(0xFF63B4F0), const Color(0xFF090E27)),
            mix(const Color(0xFFC7E7FF), const Color(0xFF464F85)),
          ],
        ).createShader(bounds),
    );

    _paintStars(canvas, size);
    _paintClouds(canvas, size);
    _paintCelestialBodies(canvas, size);
    _paintHills(canvas, size);
    _paintHouse(canvas, size);
    canvas.restore();
  }

  void _paintStars(Canvas canvas, Size size) {
    const coords = <Offset>[
      Offset(.04, .12),
      Offset(.18, .27),
      Offset(.29, .09),
      Offset(.41, .38),
      Offset(.53, .17),
      Offset(.66, .08),
      Offset(.78, .43),
      Offset(.91, .15),
      Offset(.97, .57),
      Offset(.11, .62),
      Offset(.32, .56),
      Offset(.58, .68),
      Offset(.72, .61),
      Offset(.88, .72),
      Offset(.49, .54),
      Offset(.24, .46),
      Offset(.83, .25),
      Offset(.60, .31),
    ];
    for (var i = 0; i < coords.length; i++) {
      final phase = ambient * 2 * math.pi + i * 1.67;
      final twinkle = .65 + .35 * math.sin(phase).abs();
      final a = (darkness * twinkle).clamp(0.0, 1.0).toDouble();
      canvas.drawCircle(
        Offset(coords[i].dx * size.width, coords[i].dy * size.height),
        (i % 5 == 0 ? 1.6 : .95) * size.height / 190,
        Paint()..color = Colors.white.withValues(alpha: a),
      );
    }

    // Start 1.45 seconds after entering dark mode, then repeat every 7 seconds.
    final streak = (shootingStar - 1.45 / 7) / .13;
    if (darkness > .65 && streak > 0 && streak < 1) {
      final x = size.width * (.80 - .30 * streak);
      final y = size.height * (.13 + .30 * streak);
      final tail = Offset(size.width * .11, -size.height * .11);
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y) + tail,
        Paint()
          ..strokeWidth = size.height * .006
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withValues(
            alpha: ((1 - (streak * 2 - 1).abs()) * darkness * .9)
                .clamp(0.0, 1.0)
                .toDouble(),
          ),
      );
    }
  }

  void _paintClouds(Canvas canvas, Size size) {
    final opacity = (1 - darkness * 1.24).clamp(0.0, 1.0).toDouble();
    if (opacity <= 0) return;
    final drift = math.sin(ambient * 2 * math.pi) * size.width * .014;
    _cloud(
      canvas,
      Offset(size.width * .14 + drift, size.height * .36),
      size.height * .46,
      opacity,
    );
    _cloud(
      canvas,
      Offset(size.width * .61 - drift, size.height * .50),
      size.height * .38,
      opacity,
    );
    _cloud(
      canvas,
      Offset(size.width * 1.05 + drift, size.height * .68),
      size.height * .32,
      opacity,
    );
  }

  void _cloud(Canvas canvas, Offset center, double scale, double opacity) {
    final paint = Paint()..color = Colors.white.withValues(alpha: opacity);
    final blur = darkness * scale * .16;
    if (blur > .01) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
    }

    final x = center.dx, y = center.dy;
    var cloud = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - scale * .53, y, scale * 1.06, scale * .31),
          Radius.circular(scale * .15),
        ),
      );
    for (final circle in [
      Rect.fromCircle(center: Offset(x - scale * .21, y), radius: scale * .23),
      Rect.fromCircle(
        center: Offset(x + scale * .09, y - scale * .09),
        radius: scale * .31,
      ),
      Rect.fromCircle(
        center: Offset(x + scale * .34, y + scale * .02),
        radius: scale * .21,
      ),
    ]) {
      cloud = Path.combine(PathOperation.union, cloud, Path()..addOval(circle));
    }
    canvas.drawPath(cloud, paint);
  }

  void _paintCelestialBodies(Canvas canvas, Size size) {
    // Use the current blend for both orbits so reversing mid-transition
    // continues from the visible positions without a jump.
    final sun = Offset(
      ui.lerpDouble(.82, 1.04, darkness)!,
      ui.lerpDouble(.29, .98, darkness * darkness)!,
    );
    final moon = Offset(
      ui.lerpDouble(-.12, .82, darkness)!,
      ui.lerpDouble(.98, .29, 1 - math.pow(1 - darkness, 2).toDouble())!,
    );
    final sunAlpha = (1 - darkness * darkness).clamp(0.0, 1.0).toDouble();
    final moonAlpha = (darkness * 1.5).clamp(0.0, 1.0).toDouble();

    _paintSun(
      canvas,
      Offset(sun.dx * size.width, sun.dy * size.height),
      size.height * .085,
      sunAlpha,
    );
    _paintMoon(
      canvas,
      Offset(moon.dx * size.width, moon.dy * size.height),
      size.height * .093,
      moonAlpha,
    );
  }

  void _paintSun(Canvas canvas, Offset center, double radius, double opacity) {
    if (opacity < .01) return;
    final glowRect = Rect.fromCircle(center: center, radius: radius * 2.6);
    canvas.drawCircle(
      center,
      radius * 2.6,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE357).withValues(alpha: .27 * opacity),
            Colors.transparent,
          ],
        ).createShader(glowRect),
    );
    final ray = Paint()
      ..color = const Color(0xFFFFC900).withValues(alpha: opacity)
      ..strokeWidth = radius * .12
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = (i * math.pi / 4) + (ambient * .12);
      canvas.drawLine(
        center + Offset(math.cos(a), math.sin(a)) * radius * 1.38,
        center + Offset(math.cos(a), math.sin(a)) * radius * 1.82,
        ray,
      );
    }
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = const Color(0xFFFFD400).withValues(alpha: opacity),
    );
  }

  void _paintMoon(Canvas canvas, Offset center, double radius, double opacity) {
    if (opacity < .01) return;
    canvas.drawCircle(
      center,
      radius * 2.8,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFFFE5).withValues(alpha: .27 * opacity),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 2.8)),
    );
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(radius / _moonPathRadius);
    canvas.drawPath(
      _moonPath,
      Paint()..color = const Color(0xFFFFFDE5).withValues(alpha: opacity),
    );
    canvas.restore();
  }

  void _paintHills(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    final back = Path()
      ..moveTo(0, h * .73)
      ..cubicTo(w * .20, h * .56, w * .43, h * .59, w * .64, h * .72)
      ..cubicTo(w * .83, h * .84, w * .92, h * .76, w, h * .76)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      back,
      Paint()..color = mix(const Color(0xFFB6E8A5), const Color(0xFF39457C)),
    );

    final middle = Path()
      ..moveTo(0, h * .83)
      ..cubicTo(w * .23, h * .68, w * .46, h * .72, w * .64, h * .81)
      ..cubicTo(w * .82, h * .90, w * .91, h * .86, w, h * .87)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      middle,
      Paint()..color = mix(const Color(0xFF7ECC85), const Color(0xFF283665)),
    );

    final front = Path()
      ..moveTo(0, h * .96)
      ..cubicTo(w * .30, h * .86, w * .52, h * .92, w * .68, h * .96)
      ..quadraticBezierTo(w * .89, h * 1.02, w, h * .98)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      front,
      Paint()..color = mix(const Color(0xFF4EB66F), const Color(0xFF172445)),
    );
  }

  void _paintHouse(Canvas canvas, Size size) {
    final houseWidth = size.width * .095;
    final x = size.width * .27;
    final y = size.height * .745;
    final paint = Paint()
      ..color = mix(const Color(0xFF3B493A), const Color(0xFF1D2436));
    final house = Path()
      ..moveTo(x - houseWidth * .40, y)
      ..lineTo(x, y - houseWidth * .35)
      ..lineTo(x + houseWidth * .40, y)
      ..lineTo(x + houseWidth * .40, y + houseWidth * .40)
      ..lineTo(x - houseWidth * .40, y + houseWidth * .40)
      ..close();
    canvas.drawPath(house, paint);

    final roof = Path()
      ..moveTo(x - houseWidth * .58, y + houseWidth * .02)
      ..lineTo(x - houseWidth * .08, y - houseWidth * .50)
      ..quadraticBezierTo(
        x,
        y - houseWidth * .57,
        x + houseWidth * .08,
        y - houseWidth * .50,
      )
      ..lineTo(x + houseWidth * .58, y + houseWidth * .02);
    canvas.drawPath(
      roof,
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = houseWidth * .12
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y + houseWidth * .15),
          width: houseWidth * .20,
          height: houseWidth * .22,
        ),
        Radius.circular(houseWidth * .025),
      ),
      Paint()
        ..color = Color.lerp(
          const Color(0xFFE5F4D8),
          const Color(0xFFFFD92F),
          darkness,
        )!,
    );
    if (darkness > .01) {
      canvas.drawCircle(
        Offset(x, y + houseWidth * .17),
        houseWidth * .25,
        Paint()
          ..color = const Color(0xFFFFD62F).withValues(alpha: .75 * darkness)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, houseWidth * .14),
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x - houseWidth * .70,
          y + houseWidth * .15,
          houseWidth * .24,
          houseWidth * .24,
        ),
        Radius.circular(houseWidth * .04),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x + houseWidth * .46,
          y + houseWidth * .15,
          houseWidth * .24,
          houseWidth * .24,
        ),
        Radius.circular(houseWidth * .04),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant LandscapePainter oldDelegate) =>
      oldDelegate.darkness != darkness ||
      oldDelegate.ambient != ambient ||
      oldDelegate.shootingStar != shootingStar;
}
