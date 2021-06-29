import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lit_starfield/controller/starfield_controller.dart';
import 'package:lit_starfield/model/star.dart';

class StarfieldPainter extends CustomPainter {
  final StarfieldController? starfieldController;

  /// Creates a [StarfieldPainter] [CustomPainter].
  ///
  /// [CustomPainter] to draw a visual representation of a starfield.
  StarfieldPainter({
    required this.starfieldController,
    required this.animated,
    required this.moved,
    required this.setMovedCallback,
  });

  /// State whether or not the [Star] objects will be animated.
  final bool animated;

  /// The callback [Function] executed once the starfield has been
  /// initially animated.
  final void Function(bool) setMovedCallback;

  final bool moved;

  /// The [Paint] used to draw the stars.
  late Paint starPaint;

  /// The [Paint] used to draw the nebula foreground.
  late Paint nebulaForeground;

  /// The [Paint] used to draw the nebula background.
  late Paint nebulaBackground;

  /// Draw a larger [Star] using a consistent size.
  /// Its size will depend on the current [animation] state. If it is not
  /// animated, the [Star] will be rendered smaller.
  void drawLargeSizedStar(Canvas canvas, Star star, Paint paint) {
    canvas.drawCircle(star.translatedOffset, (star.radius * 1.5), paint);
  }

  /// Draw a smaller [Star] using a variable size, which will be determined
  /// using a random number to achieve a more realistic starfield.
  /// Its size will depend on the current [animation] state. If it is not
  /// animated, the [Star] will be using a fixed size.
  void drawSmallSizedStar(Canvas canvas, Star star, Paint paint) {
    canvas.drawCircle(star.translatedOffset, (star.radius), paint);
  }

  /// Transforms the [Star] objects by expanding and translating the
  /// [Star].
  ///
  /// The transform will create an animation.
  void transformStars(Size size) {
    if (animated) {
      setMovedCallback(true);
      for (Star star in starfieldController!.stars) {
        starfieldController!.transformStar(star);
      }
    }
  }

  /// Initializes the star [Paint].
  void initStarPaint() {
    starPaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill;
  }

  /// Initalizes the nebula foreground [Paint].
  void initNebulaForegroud(Size size) {
    nebulaForeground = Paint()
      ..shader = RadialGradient(colors: [
        Colors.purple.withOpacity(0.10),
        Colors.blue.withOpacity(0.18),
        Colors.green.withOpacity(0.115),
      ], stops: [
        0.05,
        0.2,
        0.75,
      ]).createShader(Rect.fromCenter(
        height: size.height,
        width: size.width,
        center: Offset(size.width / 2, size.height / 2),
      ));
  }

  /// Initalizes the nebula background [Paint].
  void initNebulaBackground(Size size) {
    nebulaBackground = Paint()
      ..shader = RadialGradient(colors: [
        Colors.pink.withOpacity(0.08),
        Colors.red.withOpacity(0.15),
        Colors.white.withOpacity(0.115),
      ], stops: [
        0.05,
        0.2,
        0.75,
      ]).createShader(Rect.fromCenter(
        height: size.height,
        width: size.width,
        center: Offset(size.width / 2, size.height / 2),
      ));
  }

  /// Draws the [Star] objects on the provided [Canvas].
  void drawStars(Canvas canvas) {
    for (int i = 0; i < starfieldController!.stars.length - 1; i++) {
      if (i < starfieldController!.stars.length ~/ 15) {
        drawLargeSizedStar(canvas, starfieldController!.stars[i], starPaint);
      } else {
        drawSmallSizedStar(canvas, starfieldController!.stars[i], starPaint);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    /// Initialize the [Paint] objects.
    initStarPaint();
    initNebulaForegroud(size);
    initNebulaBackground(size);

    /// Animate the stars.
    transformStars(size);

    /// Draw the stars.
    drawStars(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // Repaint in any case
    return true;
  }
}
