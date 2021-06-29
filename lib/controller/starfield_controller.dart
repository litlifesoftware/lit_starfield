import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lit_starfield/model/star.dart';

/// Controller class to add functionality to the starfield.
///
/// Each individual star will be generated using the provided configuration.
/// Thenever the an property has changed (e.g. the [starCount]), the app must
/// be restarted in order for the [StarfieldController] to be initialized
/// using the updated configuration.
class StarfieldController {
  /// The number of stars to be displayed.
  final int starCount;

  /// The screen size.
  final Size deviceSize;

  /// The velocity the stars will travel at.
  final double travelVelocity;

  /// The depth of the space in which the stars are displayed.
  final double spaceDepth;

  /// States which scale to apply on each star.
  final double scale;

  /// Creates a [StarfieldController].

  StarfieldController({
    required this.starCount,
    required this.deviceSize,
    required this.travelVelocity,
    required this.spaceDepth,
    required this.scale,
  }) {
    init();
  }

  /// The [Random] instance used to create aberrations of the
  /// given center point, therefore making the [Star] move towards
  /// the user.
  late Random random;

  /// The [List] of [Star] objects which will be part of the starfield.
  late List<Star> stars;

  Offset get center {
    return Offset(deviceSize.width / 2, deviceSize.height / 2);
  }

  /// The uttermost [Star]'s x-axis position when it will be
  /// initialized.
  double get availableX {
    return deviceSize.width * spaceDepth;
  }

  /// The uttermost [Star]'s y-axis position when it will be
  /// initialized.
  double get availableY {
    return deviceSize.height * spaceDepth;
  }

  /// The uttermost [Star]'s z-axis position when it will be
  /// initialized.
  double get availableZ {
    return spaceDepth * 2;
  }

  /// Translates the provided [Star]'s points.
  ///
  /// Sets the [Star.translatedOffset] values will be defined using the current
  /// [Star.dx] and [Star.dy] values which will be devided by the current
  /// [Star.dz] value. The result will be increased by the corresponding center
  /// point values to center the [Star.translatedOffset].
  ///
  /// The [Star.dz] value will be decreased by the current [Star.velocity] in
  /// order for the star to travel towards the foreground.
  ///
  /// If the [Star.dz] value is below the [Star.baseVelocity], set the [Star.dz]
  /// value again using a random value on the available space.
  /// The [Star.spaceDepth] will be added. The [Star.radius] will be set to its
  /// default.
  /// Else the [Star.radius] will be adjusted to the current velocity in regard
  /// to the defined [Star.spaceDepth] and the current [Star.dz] value.
  void transformStar(Star star) {
    star.translatedOffset =
        Offset((star.dx / star.dz + center.dx), star.dy / star.dz + center.dy);

    star.dz -= star.baseVelocity;

    if (star.dz < star.baseVelocity) {
      final Random random = Random();
      star.dz = random.nextDouble() * availableZ + spaceDepth;
      star.radius = scale;
    } else {
      star.radius = ((spaceDepth / 8) / star.dz + star.baseVelocity) * scale;
    }
  }

  /// Initializes the [StarfieldController] by creating the [Star]s.
  void init() {
    stars = [];
    for (var i = 0; i < starCount; i++) {
      random = Random();
      double dx = (random.nextDouble() * availableX) - availableX / 2;
      double dy = (random.nextDouble() * availableY) - availableY / 2;
      double dz = (random.nextDouble() * availableZ) + spaceDepth;
      stars.add(
        Star(
          baseVelocity: travelVelocity,
          spaceDepth: spaceDepth,
          dx: dx,
          dy: dy,
          dz: dz,
        ),
      );
      transformStar(stars[i]);
    }
  }
}
