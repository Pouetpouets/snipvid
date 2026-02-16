import 'package:flutter/material.dart';
import 'package:snipvid/theme/app_theme.dart';

class GradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 56,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.animFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.animCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedOpacity(
              duration: AppTheme.animFast,
              opacity: isDisabled ? 0.5 : 1.0,
              child: Container(
                height: widget.height,
                width: widget.width ?? double.infinity,
                padding: widget.padding,
                decoration: BoxDecoration(
                  gradient: isDisabled
                      ? LinearGradient(
                          colors: [
                            AppTheme.accent.withOpacity(0.5),
                            AppTheme.accentPurple.withOpacity(0.5),
                          ],
                        )
                      : AppTheme.primaryGradient,
                  borderRadius: widget.borderRadius,
                  boxShadow: isDisabled
                      ? null
                      : [
                          BoxShadow(
                            color: AppTheme.accent.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  child: IconTheme(
                    data: const IconThemeData(
                      color: AppTheme.textPrimary,
                      size: 20,
                    ),
                    child: Center(child: child),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
