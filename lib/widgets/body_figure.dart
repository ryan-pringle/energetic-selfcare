import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:energetic_selfcare/config/editable.dart';
import 'package:energetic_selfcare/models/chakra.dart';

/// Gender-neutral figure with aura, shield, and chakra points.
///
/// Coordinates live in a fixed design box so the silhouette keeps its
/// proportions on a narrow phone. Glows are drawn in real pixels so they
/// stay readable after the figure is scaled down.
class BodyFigure extends StatelessWidget {
  const BodyFigure({
    super.key,
    required this.visible,
    required this.lit,
    required this.pulsing,
    this.pulse = 0,
    this.aura = 0,
    this.shield = 0,
    this.sweep = 0,
    this.sweeping = false,
  });

  final Set<ChakraId> visible;
  final Set<ChakraId> lit;
  final Set<ChakraId> pulsing;
  final double pulse;
  final double aura;
  final double shield;
  final double sweep;
  final bool sweeping;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BodyFigurePainter(
        visible: visible,
        lit: lit,
        pulsing: pulsing,
        pulse: pulse,
        aura: aura,
        shield: shield,
        sweep: sweep,
        sweeping: sweeping,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class BodyFigurePainter extends CustomPainter {
  BodyFigurePainter({
    required this.visible,
    required this.lit,
    required this.pulsing,
    required this.pulse,
    required this.aura,
    required this.shield,
    required this.sweep,
    required this.sweeping,
  });

  static const double designW = 1000;
  static const double designH = 2280;

  final Set<ChakraId> visible;
  final Set<ChakraId> lit;
  final Set<ChakraId> pulsing;
  final double pulse;
  final double aura;
  final double shield;
  final double sweep;
  final bool sweeping;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / designW, size.height / designH);
    if (scale <= 0) {
      return;
    }
    final origin = Offset(
      (size.width - designW * scale) / 2,
      (size.height - designH * scale) / 2,
    );
    Offset p(double x, double y) => origin + Offset(x * scale, y * scale);
    double u(double design) => design * scale;

    final shieldRect = Rect.fromLTRB(
      p(70, 120).dx,
      p(70, 120).dy,
      p(930, 1920).dx,
      p(930, 1920).dy,
    );
    final auraRect = Rect.fromCenter(
      center: shieldRect.center,
      width: shieldRect.width * 0.86,
      height: shieldRect.height * 0.9,
    );

    _paintShield(canvas, shieldRect);
    _paintAura(canvas, auraRect);
    if (sweeping && sweep > 0) {
      _paintSweep(canvas, auraRect);
    }
    _paintBody(canvas, p, u);
    _paintChakras(canvas, p, u);
  }

  void _paintShield(Canvas canvas, Rect rect) {
    if (shield <= 0.01) {
      return;
    }
    final gold = Editable.shieldGold;
    canvas.drawOval(
      rect.inflate(8),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..color = gold.withValues(alpha: 0.2 * shield)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawOval(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = gold.withValues(alpha: 0.88 * shield),
    );
  }

  void _paintAura(Canvas canvas, Rect rect) {
    final level = aura.clamp(0.0, 1.0);
    final wash = 0.035 + (0.11 * level);
    canvas.drawOval(
      rect,
      Paint()
        ..color = Colors.white.withValues(alpha: wash)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
    canvas.drawOval(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = Colors.white.withValues(alpha: 0.06 + (0.16 * level))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  void _paintSweep(Canvas canvas, Rect rect) {
    final path = Path()..addOval(rect);
    canvas.save();
    canvas.clipPath(path);
    final y = rect.top + (rect.height * sweep.clamp(0.0, 1.0));
    final band = Rect.fromLTRB(rect.left, rect.top, rect.right, y);
    if (band.height > 1) {
      canvas.drawRect(
        band,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.02),
              Colors.white.withValues(alpha: 0.16),
              Colors.white.withValues(alpha: 0.28),
            ],
            stops: const [0, 0.72, 1],
          ).createShader(band),
      );
    }
    canvas.drawRect(
      Rect.fromLTRB(rect.left, y - 18, rect.right, y + 10),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.restore();
  }

  void _paintBody(
    Canvas canvas,
    Offset Function(double, double) p,
    double Function(double) u,
  ) {
    final bounds = Rect.fromPoints(p(120, 560), p(880, 1960));
    final fill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE8EAEF), Color(0xFFC3C8D1)],
      ).createShader(bounds);

    Paint limb(double width) {
      return Paint()
        ..shader = fill.shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(u(width), 8)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
    }

    final leftArm = Path()
      ..moveTo(p(360, 980).dx, p(360, 980).dy)
      ..quadraticBezierTo(
        p(230, 1140).dx,
        p(230, 1140).dy,
        p(155, 1360).dx,
        p(155, 1360).dy,
      );
    final rightArm = Path()
      ..moveTo(p(640, 980).dx, p(640, 980).dy)
      ..quadraticBezierTo(
        p(770, 1140).dx,
        p(770, 1140).dy,
        p(845, 1360).dx,
        p(845, 1360).dy,
      );
    canvas.drawPath(leftArm, limb(52));
    canvas.drawPath(rightArm, limb(52));

    final leftLeg = Path()
      ..moveTo(p(430, 1560).dx, p(430, 1560).dy)
      ..quadraticBezierTo(
        p(390, 1720).dx,
        p(390, 1720).dy,
        p(375, 1860).dx,
        p(375, 1860).dy,
      );
    final rightLeg = Path()
      ..moveTo(p(570, 1560).dx, p(570, 1560).dy)
      ..quadraticBezierTo(
        p(610, 1720).dx,
        p(610, 1720).dy,
        p(625, 1860).dx,
        p(625, 1860).dy,
      );
    canvas.drawPath(leftLeg, limb(64));
    canvas.drawPath(rightLeg, limb(64));

    final torso = Path()
      ..moveTo(p(345, 960).dx, p(345, 960).dy)
      ..quadraticBezierTo(
        p(500, 910).dx,
        p(500, 910).dy,
        p(655, 960).dx,
        p(655, 960).dy,
      )
      ..quadraticBezierTo(
        p(705, 1040).dx,
        p(705, 1040).dy,
        p(655, 1160).dx,
        p(655, 1160).dy,
      )
      ..quadraticBezierTo(
        p(610, 1320).dx,
        p(610, 1320).dy,
        p(600, 1460).dx,
        p(600, 1460).dy,
      )
      ..quadraticBezierTo(
        p(630, 1560).dx,
        p(630, 1560).dy,
        p(560, 1620).dx,
        p(560, 1620).dy,
      )
      ..quadraticBezierTo(
        p(500, 1660).dx,
        p(500, 1660).dy,
        p(440, 1620).dx,
        p(440, 1620).dy,
      )
      ..quadraticBezierTo(
        p(370, 1560).dx,
        p(370, 1560).dy,
        p(400, 1460).dx,
        p(400, 1460).dy,
      )
      ..quadraticBezierTo(
        p(390, 1320).dx,
        p(390, 1320).dy,
        p(345, 1160).dx,
        p(345, 1160).dy,
      )
      ..quadraticBezierTo(
        p(295, 1040).dx,
        p(295, 1040).dy,
        p(345, 960).dx,
        p(345, 960).dy,
      )
      ..close();
    canvas.drawPath(torso, fill);

    canvas.drawLine(p(500, 860), p(500, 960), limb(48));

    canvas.drawOval(
      Rect.fromCenter(
        center: p(500, 745),
        width: math.max(u(196), 36),
        height: math.max(u(214), 40),
      ),
      fill,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: p(150, 1395),
        width: math.max(u(46), 10),
        height: math.max(u(54), 12),
      ),
      fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: p(850, 1395),
        width: math.max(u(46), 10),
        height: math.max(u(54), 12),
      ),
      fill,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: p(348, 1895),
        width: math.max(u(86), 16),
        height: math.max(u(34), 8),
      ),
      fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: p(652, 1895),
        width: math.max(u(86), 16),
        height: math.max(u(34), 8),
      ),
      fill,
    );
  }

  void _paintChakras(
    Canvas canvas,
    Offset Function(double, double) p,
    double Function(double) u,
  ) {
    const anchors = <ChakraId, Offset>{
      ChakraId.divineGateway: Offset(500, 170),
      ChakraId.galactic: Offset(500, 270),
      ChakraId.universal: Offset(500, 370),
      ChakraId.soulStar: Offset(500, 470),
      ChakraId.causal: Offset(500, 560),
      ChakraId.crown: Offset(500, 648),
      ChakraId.thirdEye: Offset(500, 725),
      ChakraId.throat: Offset(500, 900),
      ChakraId.heart: Offset(500, 1085),
      ChakraId.solarPlexus: Offset(500, 1205),
      ChakraId.naval: Offset(500, 1305),
      ChakraId.sacral: Offset(500, 1405),
      ChakraId.root: Offset(500, 1515),
      ChakraId.leftHand: Offset(150, 1395),
      ChakraId.rightHand: Offset(850, 1395),
      ChakraId.leftFoot: Offset(348, 1898),
      ChakraId.rightFoot: Offset(652, 1898),
      ChakraId.earthStar: Offset(500, 1990),
      ChakraId.magnetic: Offset(500, 2085),
      ChakraId.gaiaGateway: Offset(500, 2170),
    };

    for (final entry in anchors.entries) {
      if (!visible.contains(entry.key)) {
        continue;
      }
      final center = p(entry.value.dx, entry.value.dy);
      final isLit = lit.contains(entry.key);
      final isPulsing = pulsing.contains(entry.key);
      final pulseScale = isPulsing ? 1 + (0.28 * pulse) : 1.0;
      _paintPoint(
        canvas,
        entry.key,
        center,
        u,
        isLit: isLit,
        pulseScale: pulseScale,
        pulseGlow: isPulsing ? pulse : 0,
      );
    }
  }

  void _paintPoint(
    Canvas canvas,
    ChakraId id,
    Offset center,
    double Function(double) u, {
    required bool isLit,
    required double pulseScale,
    required double pulseGlow,
  }) {
    final colour = Editable.colourOf(id);
    final ring = Editable.ringOf(id);
    final base = switch (id) {
      ChakraId.leftHand || ChakraId.rightHand => 30.0,
      ChakraId.leftFoot || ChakraId.rightFoot => 26.0,
      ChakraId.earthStar => 34.0,
      ChakraId.divineGateway || ChakraId.galactic || ChakraId.universal => 40.0,
      _ => 36.0,
    };
    final radius = math.max(u(base), 6.5) * pulseScale;
    final alpha = isLit ? 1.0 : 0.28;

    if (isLit) {
      canvas.drawCircle(
        center,
        radius * 2.4,
        Paint()
          ..color = colour.withValues(alpha: 0.28 + (0.35 * pulseGlow))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    if (id == ChakraId.earthStar) {
      final oval = Rect.fromCenter(
        center: center,
        width: radius * 3.4,
        height: radius * 1.35,
      );
      canvas.drawOval(
        oval,
        Paint()..color = colour.withValues(alpha: isLit ? 0.95 : 0.35),
      );
      canvas.drawOval(
        oval,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = (ring ?? Colors.white).withValues(
            alpha: isLit ? 0.9 : 0.45,
          ),
      );
      return;
    }

    final asRing = id == ChakraId.soulStar || id == ChakraId.causal;
    if (asRing) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(radius * 0.28, 2)
          ..color = (ring ?? colour).withValues(alpha: alpha),
      );
      if (isLit && id == ChakraId.soulStar) {
        canvas.drawCircle(
          center,
          radius * 0.35,
          Paint()..color = colour.withValues(alpha: 0.9),
        );
      }
      return;
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = colour.withValues(alpha: isLit ? 0.95 : 0.34),
    );
    if (isLit) {
      canvas.drawCircle(
        center,
        radius * 0.38,
        Paint()..color = Colors.white.withValues(alpha: 0.75),
      );
    }
    if (ring != null) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = ring.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant BodyFigurePainter oldDelegate) {
    return oldDelegate.visible != visible ||
        oldDelegate.lit != lit ||
        oldDelegate.pulsing != pulsing ||
        oldDelegate.pulse != pulse ||
        oldDelegate.aura != aura ||
        oldDelegate.shield != shield ||
        oldDelegate.sweep != sweep ||
        oldDelegate.sweeping != sweeping;
  }
}
