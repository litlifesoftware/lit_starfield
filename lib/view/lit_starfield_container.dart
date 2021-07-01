import 'package:flutter/material.dart';
import 'package:lit_starfield/controller/starfield_controller.dart';
import 'package:lit_starfield/view/starfield_painter.dart';

/// A Container on which a starfield will be painted on.
///
/// The painter will fit the whole screen, therefore it is recommended to use
/// this container as background.
class LitStarfieldContainer extends StatefulWidget {
  /// Creates a [LitStarfieldContainer].

  const LitStarfieldContainer({
    Key? key,
    this.animated = true,
    this.number = 400,
    this.velocity = 0.7,
    this.depth = 0.9,
    this.scale = 1.5,
    this.starColor = Colors.white,
    this.backgroundDecoration = const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF283828),
          Color(0xFF181818),
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
  }) : super(key: key);

  /// States whether or not the starfield should be animated.
  final bool animated;

  /// States the total number of stars.
  final int number;

  /// The speed at which the stars will approximating the screen edges.
  final double velocity;

  /// The depth of the space, the will be painted on starfield.
  ///
  /// The larger the depth it is, the further the field will be stretched.
  ///
  /// Only relative values are accepted (`0.0`-`1.0`).
  final double depth;

  /// States which scale to apply on each individual star.
  ///
  /// Only relative values are accepted (`0.0`-`1.0`).
  final double scale;

  /// States the color each star will be painted with.
  final Color starColor;

  /// The container's background decoration.
  final BoxDecoration backgroundDecoration;
  @override
  _LitStarfieldContainerState createState() => _LitStarfieldContainerState();
}

class _LitStarfieldContainerState extends State<LitStarfieldContainer>
    with TickerProviderStateMixin {
  /// Controller to build the starfield's data layer.
  late StarfieldController _controller;

  /// State whether or not the starfield has been initially animated.
  bool moved = false;

  /// [AnimationController] enforces a re-render on the [AnimatedBuilder]
  /// widget. Its [Duration] won't have any impact.
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

  /// Sets the [moved] value.
  void setMoved(bool value) {
    moved = value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the controller on didChangeDependencies to ensure it has
    // access to the BuildContext.
    _controller = StarfieldController(
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _starfieldAnimation,
      builder: (BuildContext context, Widget? _) {
        return Container(
          decoration: widget.backgroundDecoration,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: StarfieldPainter(
                controller: _controller,
                moved: moved,
                setMovedCallback: setMoved,
                animated: widget.animated,
                starColor: widget.starColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
