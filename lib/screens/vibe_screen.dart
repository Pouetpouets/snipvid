import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:snipvid/models/project.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/theme/app_theme.dart';

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
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedVibe = vibe),
                  );
                }).toList(),
              ),
            ),
            if (_selectedVibe != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_selectedVibe!.icon} ${_selectedVibe!.label.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
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

class _VibeCard extends StatelessWidget {
  final VibeType vibe;
  final bool isSelected;
  final VoidCallback onTap;

  const _VibeCard({
    required this.vibe,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppTheme.accent, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              vibe.icon,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            Text(
              vibe.label.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                vibe.description,
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
    );
  }
}
