import 'package:flutter/material.dart';

/// Fades and slides its [child] into view. Designed to be placed on siblings
/// that should animate in sequentially — pass an incrementing [index] and
/// they'll cascade based on [stagger].
///
/// While [enabled] is `false`, the child renders at full opacity/no offset
/// so things like `Skeletonizer` can still shimmer over it. When [enabled]
/// flips to `true`, the animation resets and plays after `index * stagger`.
class StaggeredFadeIn extends StatefulWidget {
  final Widget child;
  final int index;
  final bool enabled;
  final Duration stagger;
  final Duration duration;
  final double slideOffset;
  final Curve curve;

  const StaggeredFadeIn({
    super.key,
    required this.child,
    this.index = 0,
    this.enabled = true,
    this.stagger = const Duration(milliseconds: 90),
    this.duration = const Duration(milliseconds: 520),
    this.slideOffset = 0.18,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.enabled ? 0.0 : 1.0,
    );
    _fade = CurvedAnimation(parent: _controller, curve: widget.curve);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.enabled) _scheduleStart();
  }

  @override
  void didUpdateWidget(covariant StaggeredFadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.value = 0.0;
      _scheduleStart();
    } else if (!widget.enabled && oldWidget.enabled) {
      _controller.value = 1.0;
    }
  }

  void _scheduleStart() {
    Future.delayed(widget.stagger * widget.index, () {
      if (mounted) _controller.forward(from: _controller.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: FractionalTranslation(
            translation: _slide.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
