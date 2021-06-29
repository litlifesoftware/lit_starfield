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
  /// By default the required values are already
  /// initialized. Set custom values for different behavior.

  const LitStarfieldBackground({
    Key? key,
    this.animated = true,
    this.showNebulaBackground = true,
    this.showNebulaForeground = true,
    this.starCount = 400,
    this.travelVelocity = 0.5,
    this.spaceDepth = 100,
  }) : super(key: key);

  /// States whether or not the starfield should be animated.
  final bool animated;

  /// States whether or not to show the nebula background.
  final bool showNebulaBackground;

  /// States whether or not to show the nebula foreground.
  final bool showNebulaForeground;

  /// Defines the total number of stars.
  final int starCount;

  /// The speed at which the stars will approximating the screen edges.
  final double travelVelocity;

  /// The depth which will determine the user's perspective on viewing
  /// the starfield. The larger it is, the further away the field will be.
  final double spaceDepth;

  @override
  _LitStarfieldBackgroundState createState() => _LitStarfieldBackgroundState();
}

class _LitStarfieldBackgroundState extends State<LitStarfieldBackground>
    with TickerProviderStateMixin {
  StarfieldController? starfieldController;

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
        seconds: 10,
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
    starfieldController = StarfieldController(
      starCount: widget.starCount,
      deviceSize: MediaQuery.of(context).size,
      travelVelocity: widget.travelVelocity,
      spaceDepth: widget.spaceDepth,
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
      builder: (BuildContext context, Widget? child) {
        return Container(
          color: Colors.black,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: StarfieldPainter(
                starfieldController: starfieldController,
                moved: moved,
                setMovedCallback: setMoved,
                animated: widget.animated,
                showNebulaBackground: widget.showNebulaBackground,
                showNebulaForeground: widget.showNebulaForeground,
              ),
            ),
          ),
        );
      },
    );
  }
}
