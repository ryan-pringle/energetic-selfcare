import 'package:flutter/material.dart';

/// Scales paddings and type for phones of different sizes.
///
/// The design is written for a mid-size phone (~390 logical points wide).
/// Narrower phones shrink a little; larger phones and tablets grow a little,
/// then the app shell still caps content width.
class PhoneScale {
  PhoneScale(BuildContext context)
    : size = MediaQuery.sizeOf(context),
      padding = MediaQuery.paddingOf(context),
      textScaler = MediaQuery.textScalerOf(context);

  final Size size;
  final EdgeInsets padding;
  final TextScaler textScaler;

  double get shortest => size.shortestSide;

  /// 0.88 on a small phone, 1.0 around 390, up to 1.12 on large phones.
  double get factor {
    final raw = shortest / 390;
    return raw.clamp(0.88, 1.12);
  }

  double gap(double value) => value * factor;

  EdgeInsets pageInsets({
    double horizontal = 20,
    double top = 16,
    double bottom = 28,
  }) {
    return EdgeInsets.fromLTRB(
      horizontal * factor,
      top * factor,
      horizontal * factor,
      bottom * factor + padding.bottom * 0.15,
    );
  }

  /// Room for the prompt above the figure. Shorter phones get less height
  /// so the body stays large enough to read.
  double promptMaxHeight() {
    final ratio = size.height < 700 ? 0.24 : 0.30;
    return size.height * ratio;
  }

  double cornerTileWidth() {
    final base = size.width * 0.34;
    return base.clamp(112.0, 150.0);
  }
}
