import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
export 'package:flutter_animate/flutter_animate.dart';

class AppMotion {
  AppMotion._();

  /// Entrance of a single block of content (headers, cards, standalone text).
  static const Duration base = Duration(milliseconds: 380);

  /// Quicker entrance for small / secondary elements.
  static const Duration fast = Duration(milliseconds: 260);

  /// Hero moments - splash logo, primary call-to-action.
  static const Duration slow = Duration(milliseconds: 540);

  /// Gap between consecutive items in a staggered list / column.
  static const Duration stagger = Duration(milliseconds: 55);

  /// Professional, non-bouncy easing used for every entrance.
  static const Curve curve = Curves.easeOutCubic;

  /// Cap on how far a stagger is allowed to fan out so long lists don't
  /// leave the user waiting.
  static const int maxStaggerSteps = 12;
}

extension AppEntranceX on Widget {
  /// Fade in with a small upward drift. The default for almost everything.
  Widget appEntrance({Duration? delay, double shift = 0.14}) => animate(delay: delay)
      .fadeIn(duration: AppMotion.base, curve: AppMotion.curve)
      .slideY(begin: shift, end: 0, duration: AppMotion.base, curve: AppMotion.curve);

  /// Staggered entrance for the item at [index] in a list, grid or column.
  Widget appListEntrance(int index, {double shift = 0.14, Axis axis = Axis.vertical}) {
    final steps =
        index > AppMotion.maxStaggerSteps ? AppMotion.maxStaggerSteps : index;
    final delay = AppMotion.stagger * steps;
    if (axis == Axis.horizontal) {
      return animate(delay: delay)
          .fadeIn(duration: AppMotion.base, curve: AppMotion.curve)
          .slideX(begin: shift, end: 0, duration: AppMotion.base, curve: AppMotion.curve);
    }
    return appEntrance(delay: delay, shift: shift);
  }

  /// Gentle scale + fade. For splash logos, dialogs and primary buttons.
  Widget appPopIn({Duration? delay, Duration? duration}) => animate(delay: delay)
      .fadeIn(duration: duration ?? AppMotion.base, curve: AppMotion.curve)
      .scaleXY(
        begin: 0.94,
        end: 1,
        duration: duration ?? AppMotion.base,
        curve: AppMotion.curve,
      );

  /// A slow, looping shimmer sweep - for "live"/loading accents only.
  Widget appShimmerLoop() => animate(onPlay: (c) => c.repeat())
      .shimmer(duration: 1400.ms, delay: 600.ms, curve: Curves.easeInOut);
}

extension AppEntranceListX on List<Widget> {
  List<Widget> appStaggered({double shift = 0.14, Axis axis = Axis.vertical}) {
    final list = animate(interval: AppMotion.stagger)
        .fadeIn(duration: AppMotion.base, curve: AppMotion.curve);
    if (axis == Axis.horizontal) {
      return list.slideX(
          begin: shift, end: 0, duration: AppMotion.base, curve: AppMotion.curve);
    }
    return list.slideY(
        begin: shift, end: 0, duration: AppMotion.base, curve: AppMotion.curve);
  }
}