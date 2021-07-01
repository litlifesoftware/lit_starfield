import 'package:flutter/material.dart';
import 'package:lit_starfield/controller/starfield_controller.dart';
import 'package:lit_starfield/model/star.dart';

/// A Flutter custom painter drawing a starfield on a [CustomPaint].
class StarfieldPainter extends CustomPainter {
  /// Creates a [StarfieldPainter].
  StarfieldPainter({
    required this.controller,
    required this.starColor,
    required this.animated,
    required this.moved,
    required this.setMovedCallback,
  });

  /// The controller providing the star data and transform logic.
  final StarfieldController controller;

  /// The color each star will be painted with.
  final Color starColor;

  /// State whether or not the [Star] objects will be animated.
  final bool animated;

  /// The callback [Function] executed once the starfield has been
  /// initially animated.
  final void Function(bool) setMovedCallback;

  final bool moved;

  /// The [Paint] used to draw the stars.
  late Paint starPaint;

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
      for (Star star in controller.stars) {
        controller.transformStar(star);
      }
    }
  }

  /// Initializes the star [Paint].
  void initStarPaint() {
    starPaint = Paint()
      ..color = starColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill;
  }

  /// Draws the [Star] objects on the provided [Canvas].
  ///
  /// Based on the stars index value, either a smaller or a larger start will
  /// be painted to create variety.
  void drawStars(Canvas canvas) {
    for (int i = 0; i < controller.stars.length - 1; i++) {
      if (i < controller.stars.length ~/ 15) {
        drawLargeSizedStar(
          canvas,
          controller.stars[i],
          starPaint,
        );
      } else {
        drawSmallSizedStar(
          canvas,
          controller.stars[i],
          starPaint,
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    /// Initialize the [Paint] objects.
    initStarPaint();

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
