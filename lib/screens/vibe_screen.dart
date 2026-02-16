import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:snipvid/models/project.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/theme/app_theme.dart';
import 'package:snipvid/widgets/gradient_button.dart';

class VibeScreen extends StatefulWidget {
  const VibeScreen({super.key});

  @override
  State<VibeScreen> createState() => _VibeScreenState();
}

class _VibeScreenState extends State<VibeScreen> {
  VibeType? _selectedVibe;

  @override
  void initState() {
    super.initState();
    _selectedVibe = context.read<ProjectService>().currentProject?.vibe;
  }

  IconData _getVibeIcon(VibeType vibe) {
    switch (vibe) {
      case VibeType.dynamic:
        return Icons.bolt;
      case VibeType.slow:
        return Icons.waves;
      case VibeType.mix:
        return Icons.casino;
      case VibeType.epic:
        return Icons.movie;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Quel style ?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
                children: VibeType.values.map((vibe) {
                  final isSelected = vibe == _selectedVibe;
                  return _VibeCard(
                    vibe: vibe,
                    icon: _getVibeIcon(vibe),
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedVibe = vibe),
                  );
                }).toList(),
              ),
            ),
            if (_selectedVibe != null) ...[
              AnimatedContainer(
                duration: AppTheme.animNormal,
                curve: AppTheme.animCurve,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppTheme.subtleGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_selectedVibe!.icon} ${_selectedVibe!.label.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
            ],
            GradientButton(
              onPressed: _selectedVibe == null
                  ? null
                  : () {
                      context.read<ProjectService>().setVibe(_selectedVibe!);
                      context.push('/processing');
                    },
              child: const Text('GÉNÉRER LA VIDÉO'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VibeCard extends StatefulWidget {
  final VibeType vibe;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _VibeCard({
    required this.vibe,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_VibeCard> createState() => _VibeCardState();
}

class _VibeCardState extends State<_VibeCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.animCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_VibeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: widget.isSelected ? const EdgeInsets.all(2) : EdgeInsets.zero,
              decoration: BoxDecoration(
                gradient: widget.isSelected ? AppTheme.primaryGradient : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.accent.withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(widget.isSelected ? 14 : 16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with glow effect when selected
                    AnimatedContainer(
                      duration: AppTheme.animNormal,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: widget.isSelected
                            ? AppTheme.subtleGradient
                            : null,
                        color: widget.isSelected ? null : AppTheme.surfaceLight,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 32,
                        color: widget.isSelected
                            ? AppTheme.accent
                            : AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.vibe.label.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: widget.isSelected
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.vibe.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
