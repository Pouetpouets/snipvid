import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:snipvid/models/project.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/theme/app_theme.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  ExportRatio _selectedRatio = ExportRatio.portrait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Ta vidéo est prête !'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Preview vidéo
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline, size: 64),
                      SizedBox(height: 16),
                      Text('Preview vidéo'),
                      Text(
                        '(Player à implémenter)',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sélecteur de ratio
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ExportRatio.values.map((ratio) {
                final isSelected = ratio == _selectedRatio;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedRatio = ratio);
                      context.read<ProjectService>().setExportRatio(ratio);
                    },
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accent : AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            ratio.label,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ratio.subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white.withOpacity(0.8)
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            // Boutons export
            OutlinedButton(
              onPressed: () {
                // TODO: Export avec watermark
                _showExportSuccess(context, withWatermark: true);
              },
              child: const Text('EXPORTER (watermark)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: In-app purchase + export HD
                _showExportSuccess(context, withWatermark: false);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: 18),
                  SizedBox(width: 8),
                  Text('EXPORTER HD  3.99€'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Modifier le vibe
            TextButton(
              onPressed: () => context.go('/vibe'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, size: 18, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Modifier le vibe',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportSuccess(BuildContext context, {required bool withWatermark}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          withWatermark
              ? 'Vidéo exportée avec watermark !'
              : 'Vidéo HD exportée !',
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
