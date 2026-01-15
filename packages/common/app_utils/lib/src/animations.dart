import 'package:flutter/material.dart';

/// Animation library for consistent motion design
class AppAnimations {
  const AppAnimations._();

  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;
  static const Curve decelerate = Curves.decelerate;

  /// Fade in animation widget
  static Widget fadeIn(
    Widget child, {
    Duration? duration,
    Curve curve = easeInOut,
    VoidCallback? onComplete,
  }) {
    return _AnimatedWrapper(
      duration: duration ?? normal,
      curve: curve,
      onComplete: onComplete,
      builder: (context, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide in animation widget
  static Widget slideIn(
    Widget child, {
    Duration? duration,
    Curve curve = easeOut,
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
    VoidCallback? onComplete,
  }) {
    return _AnimatedWrapper(
      duration: duration ?? normal,
      curve: curve,
      onComplete: onComplete,
      builder: (context, animation) {
        return SlideTransition(
          position: Tween<Offset>(begin: begin, end: end).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Scale in animation widget
  static Widget scaleIn(
    Widget child, {
    Duration? duration,
    Curve curve = easeOut,
    double begin = 0.8,
    double end = 1.0,
    VoidCallback? onComplete,
  }) {
    return _AnimatedWrapper(
      duration: duration ?? normal,
      curve: curve,
      onComplete: onComplete,
      builder: (context, animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: begin, end: end).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Rotate animation widget
  static Widget rotate(
    Widget child, {
    Duration? duration,
    Curve curve = easeInOut,
    double begin = 0,
    double end = 1,
    VoidCallback? onComplete,
  }) {
    return _AnimatedWrapper(
      duration: duration ?? normal,
      curve: curve,
      onComplete: onComplete,
      builder: (context, animation) {
        return RotationTransition(
          turns: Tween<double>(begin: begin, end: end).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Combined fade and slide animation
  static Widget fadeInUp(
    Widget child, {
    Duration? duration,
    Curve curve = easeOut,
    VoidCallback? onComplete,
  }) {
    return _AnimatedWrapper(
      duration: duration ?? normal,
      curve: curve,
      onComplete: onComplete,
      builder: (context, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  /// Combined fade and scale animation
  static Widget fadeInScale(
    Widget child, {
    Duration? duration,
    Curve curve = easeOut,
    VoidCallback? onComplete,
  }) {
    return _AnimatedWrapper(
      duration: duration ?? normal,
      curve: curve,
      onComplete: onComplete,
      builder: (context, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  /// Shimmer loading effect
  static Widget shimmer(Widget child, {bool enabled = true}) {
    if (!enabled) return child;

    return _ShimmerWidget(child: child);
  }

  /// Skeleton loader
  static Widget skeleton({
    required double width,
    required double height,
    double? borderRadius,
  }) {
    return _SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

/// Internal animated wrapper
class _AnimatedWrapper extends StatefulWidget {
  const _AnimatedWrapper({
    required this.duration,
    required this.curve,
    required this.builder,
    this.onComplete,
  });

  final Duration duration;
  final Curve curve;
  final VoidCallback? onComplete;
  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  State<_AnimatedWrapper> createState() => _AnimatedWrapperState();
}

class _AnimatedWrapperState extends State<_AnimatedWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _animation);
  }
}

/// Shimmer effect widget
class _ShimmerWidget extends StatefulWidget {
  const _ShimmerWidget({required this.child});

  final Widget child;

  @override
  State<_ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<_ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [Colors.grey, Colors.white, Colors.grey],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Skeleton loader widget
class _SkeletonLoader extends StatefulWidget {
  const _SkeletonLoader({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final double? borderRadius;

  @override
  State<_SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<_SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
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
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300.withValues(
              alpha: 0.3 + (_controller.value * 0.3),
            ),
            borderRadius: widget.borderRadius != null
                ? BorderRadius.circular(widget.borderRadius!)
                : null,
          ),
        );
      },
    );
  }
}

/// Page transition builders
class LMSPageTransitions {
  const LMSPageTransitions._();

  static Route<T> fadeTransition<T>(
    Widget page, {
    Duration duration = AppAnimations.normal,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<T> slideTransition<T>(
    Widget page, {
    Duration duration = AppAnimations.normal,
    Offset begin = const Offset(1, 0),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  static Route<T> scaleTransition<T>(
    Widget page, {
    Duration duration = AppAnimations.normal,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
