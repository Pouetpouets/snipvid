import 'package:flutter/material.dart';
import 'package:snipvid/theme/app_theme.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool showGradientBorder;
  final bool isSelected;
  final BorderRadius borderRadius;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.width = 100,
    this.height,
    this.padding,
    this.showGradientBorder = false,
    this.isSelected = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.animFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.animCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final showBorder = widget.showGradientBorder || _isPressed || widget.isSelected;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: AppTheme.animNormal,
              curve: AppTheme.animCurve,
              width: widget.width,
              height: widget.height,
              padding: showBorder ? const EdgeInsets.all(2) : EdgeInsets.zero,
              decoration: BoxDecoration(
                gradient: showBorder ? AppTheme.primaryGradient : null,
                borderRadius: widget.borderRadius,
                boxShadow: showBorder
                    ? [
                        BoxShadow(
                          color: AppTheme.accent.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: showBorder
                      ? widget.borderRadius - const BorderRadius.all(Radius.circular(2))
                      : widget.borderRadius,
                ),
                padding: widget.padding,
                child: child,
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
