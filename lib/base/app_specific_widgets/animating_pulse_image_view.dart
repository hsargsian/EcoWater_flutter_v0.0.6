import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatingPulseImageView extends StatefulWidget {
  const AnimatingPulseImageView(
      {required this.images,
      required this.size,
      required this.color,
      this.text,
      super.key});
  final List<String> images;
  final double size;
  final Color color;
  final String? text;

  @override
  State<AnimatingPulseImageView> createState() =>
      _AnimatingPulseImageViewState();
}

class _AnimatingPulseImageViewState extends State<AnimatingPulseImageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Set the duration of the animation
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0, end: 2.5).animate(_controller);
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              (_controller.value * widget.images.length).floor();
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SvgPicture.asset(widget.images[0],
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(widget.color, BlendMode.srcIn)),
                ),
              );
            },
          ),
          Center(
            child: Text(
              widget.text ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
