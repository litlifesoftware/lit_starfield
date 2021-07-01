import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:lit_starfield/model/star.dart';

/// Controller class to add functionality to the starfield.
///
/// Each individual star will be generated using the provided configuration.
/// Thenever the an property has changed (e.g. the [number]), the app must
/// be restarted in order for the [StarfieldController] to be initialized
/// using the updated configuration.
class StarfieldController {
  /// The number of stars to be displayed.
  final int number;

  /// The starfield's size.
  final Size size;

  /// The depth of the space in which the stars are displayed.
  ///
  /// Its can have any value between `0.0` and `1.0`.
  final double depth;

  /// The velocity the stars will travel at.
  ///
  final double velocity;

  /// States which scale to apply on each star.
  final double scale;

  /// Creates a [StarfieldController].

  StarfieldController({
    required this.number,
    required this.size,
    required this.depth,
    required this.velocity,
    required this.scale,
  }) {
    init();
  }

  double absoluteVelocity = 0;

  /// The random instance used to create aberrations of the given center point,
  /// therefore making the [Star]s appear on different locations.
  late Math.Random random;

  /// The [List] of [Star] objects which will be part of the starfield.
  late List<Star> stars = [];

  /// Returns a revised depth (0-1) based on the provided depth.
  double get revisedDepth {
    const double thresholdMin = 0.1;
    const double thresholdMax = 1.0;

    // If the depth exceeds the minimum
    if (depth > thresholdMax) {
      // Return the lower threshold as base depth
      return ((thresholdMax) - 1.0).abs();
    }
    // If the depth exceeds the maximum
    if (depth < thresholdMin) {
      // Return the upper threshold as base depth
      return ((thresholdMin) - 1.0).abs();
    }
    return ((depth) - 1.0).abs();
  }

  /// Returns the view port's center point.
  Offset get center {
    return Offset(size.width / 2, size.height / 2);
  }

  /// Returns the larger view port axis (x,y).
  double get maxAxisLength {
    return Math.max(size.width, size.height);
  }

  /// Returns the larger view port axis (x,y) as an absolute value.
  double get maxAxisLengthAbs {
    return maxAxisLength.abs();
  }

  /// The uttermost starfield's x-axis position.
  double get minX {
    return size.width * absoluteVelocity;
  }

  /// The uttermost starfield's y-axis position.
  double get maxY {
    return size.height * absoluteVelocity;
  }

  /// Translates the provided [Star]'s points.
  ///
  /// The star will either be transformed to move towards the screen or its
  /// radius will be updated to create a 'flicker' effect.
  ///
  /// To create a transform offset, the star's current position are set in
  /// relation to the provided velocity.
  ///
  /// The star's z value is decreased by the starfield's depth to make the star
  /// appear moving towards the screen.
  void transformStar(Star star) {
    // Transform
    star.translatedOffset =
        Offset((star.dx / star.dz + center.dx), star.dy / star.dz + center.dy);
    // Slowly move the star to the size edges.
    star.dz -= star.baseDepth;

    // If the star's z point is closer to the screen than the base depth
    if (star.dz < star.baseDepth) {
      // Accelerate it
      final Math.Random random = Math.Random();
      star.dz = random.nextDouble() * absoluteVelocity + absoluteVelocity;
      star.radius = scale;
      // Else only adjust the radius to create a 'flicker' effect.
    } else {
      star.radius = ((absoluteVelocity / 8) / star.dz + star.baseDepth) * scale;
    }
  }

  /// Calculates a absolute velocity based on the current view port and returns
  /// its value.
  double calcAbsVelo(double relVelo) {
    // Check if the provided velocity is greater than 0
    if (!(relVelo > 0.0)) {
      return maxAxisLengthAbs;
    }

    double maxDiff = velocity - maxAxisLengthAbs;

    double maxDiffAb = maxDiff.abs() - (maxAxisLengthAbs - 1);

    double velo = (maxDiffAb * (maxAxisLengthAbs / 4) + 1);

    return velo;
  }

  /// Disposes the controller state by emptying the [stars] list.
  void dispose() {
    stars = [];
  }

  /// Initializes the [StarfieldController] by creating the [Star]s.
  void init() {
    absoluteVelocity = calcAbsVelo(velocity);
    print("rel velo: $velocity abs vel: $absoluteVelocity");
    print("min x: $minX");
    print("min y: $maxY");
    for (var i = 0; i < number; i++) {
      random = Math.Random();
      double dx = (random.nextDouble() * minX) - minX / 2;
      double dy = (random.nextDouble() * maxY) - maxY / 2;
      double dz = (random.nextDouble() * absoluteVelocity) + absoluteVelocity;
      stars.add(
        Star(
          baseDepth: revisedDepth,
          baseVelocity: absoluteVelocity,
          dx: dx,
          dy: dy,
          dz: dz,
        ),
      );
      transformStar(stars[i]);
    }
  }
}
