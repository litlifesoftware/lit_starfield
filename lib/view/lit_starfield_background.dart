import 'package:flutter/material.dart';
import 'package:lit_starfield/controller/starfield_controller.dart';
import 'package:lit_starfield/model/star.dart';
import 'package:lit_starfield/view/starfield_painter.dart';

/// The background on which the starfield will be painted on.
///
/// The painter will fit the whole screen, therefore it should only be used as a background
/// (e.g. as the undermost layer of a [Stack]).
class LitStarfieldBackground extends StatefulWidget {
  /// Creates a [StarfieldBackground] widget.

  const LitStarfieldBackground({
    Key? key,
    this.animated = true,
    this.number = 400,
    this.velocity = 0.3,
    this.depth = 0.9,
    this.scale = 1.0,
  }) : super(key: key);

  /// States whether or not the starfield should be animated.
  final bool animated;

  /// States the total number of stars.
  final int number;

  /// The speed at which the stars will approximating the screen edges.
  final double velocity;

  /// The depth which will determine the user's perspective on viewing
  /// the starfield. The larger it is, the further away the field will be.
  final double depth;

  /// States which scale to apply on each individual star.
  final double scale;

  @override
  _LitStarfieldBackgroundState createState() => _LitStarfieldBackgroundState();
}

class _LitStarfieldBackgroundState extends State<LitStarfieldBackground>
    with TickerProviderStateMixin {
  /// Controller to build the starfield's data layer.
  late StarfieldController _starfieldController;

  /// State whether or not the starfield has been initially animated.
  bool moved = false;

  /// [AnimationController] to enforce a rerender on the [AnimatedBuilder]
  /// [Widget]. Its [Duration] will have any impact because the animation
  /// will be performed by the [Star] object itself.
  late AnimationController _starfieldAnimation;
  @override
  void initState() {
    super.initState();

    _starfieldAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 20,
      ),
    );

    _starfieldAnimation.repeat(reverse: false);
  }

  void setMoved(bool value) {
    moved = value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the controller here to ensure it has access to the
    // MediaQuery object.
    _starfieldController = StarfieldController(
      number: widget.number,
      size: MediaQuery.of(context).size,
      velocity: widget.velocity,
      depth: widget.depth,
      scale: widget.scale,
    );
  }

  @override
  void dispose() {
    _starfieldAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _starfieldAnimation,
      builder: (BuildContext context, Widget? _) {
        return Container(
          color: Colors.black,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: StarfieldPainter(
                starfieldController: _starfieldController,
                moved: moved,
                setMovedCallback: setMoved,
                animated: widget.animated,
              ),
            ),
          ),
        );
      },
    );
  }
}
