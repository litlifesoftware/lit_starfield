import 'package:flutter/painting.dart';

/// Model class to depict a star in space.
///
/// Each single [Star] which will be part the starfield.
class Star {
  /// The base velocity the [Star] will travel at.
  final double baseDepth;

  final double baseVelocity;

  /// The position of the [Star] on the given x-axis.
  double dx;

  /// The position of the [Star] on the given y-axis.
  double dy;

  /// The position of the [Star] on the given z-axis.
  double dz;

  /// Creates a [Star].
  ///
  /// It will be used to compound the starfield.
  Star({
    required this.baseDepth,
    required this.baseVelocity,
    required this.dx,
    required this.dy,
    required this.dz,
  });

  /// The current [Star]'s radius. This value will be as
  /// reference on the [CustomPainter].
  late double radius;

  /// Stores the translated [dy] value.
  late Offset translatedOffset;
}
