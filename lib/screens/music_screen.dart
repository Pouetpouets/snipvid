import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:snipvid/models/project.dart';
import 'package:snipvid/services/music_service.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/theme/app_theme.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final MusicService _musicService = MusicService();
  String? _selectedTrackId;
  String _selectedCategory = '🔥 Upbeat';

  @override
  void initState() {
    super.initState();
    final current = context.read<ProjectService>().currentProject?.music;
    _selectedTrackId = current?.id;
  }

  List<MusicTrack> get _currentTracks {
    if (_selectedCategory == 'Tous') {
      return _musicService.getAllTracks();
    }
    return _musicService.getTracksByCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Tous', ...MusicService.categories.keys];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Choisis ta musique'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Import perso
            OutlinedButton(
              onPressed: () {
                // TODO: File picker pour importer musique
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Import musique — bientôt disponible'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_note),
                  SizedBox(width: 8),
                  Text('IMPORTER MA MUSIQUE'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Séparateur
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ou explore',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Filtres catégories
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accent : AppTheme.surface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Liste tracks
            Expanded(
              child: ListView.separated(
                itemCount: _currentTracks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final track = _currentTracks[index];
                  final isSelected = track.id == _selectedTrackId;
                  return _TrackTile(
                    track: track,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedTrackId = track.id);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // CTA
            ElevatedButton(
              onPressed: _selectedTrackId == null
                  ? null
                  : () {
                      final track = _musicService.getTrackById(_selectedTrackId!);
                      if (track != null) {
                        context.read<ProjectService>().setMusic(track);
                      }
                      context.push('/vibe');
                    },
              child: const Text('CONTINUER'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackTile extends StatelessWidget {
  final MusicTrack track;
  final bool isSelected;
  final VoidCallback onTap;

  const _TrackTile({
    required this.track,
    required this.isSelected,
    required this.onTap,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppTheme.accent, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Play button (TODO: implémenter preview audio)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.accent.withValues(alpha: 0.2)
                    : AppTheme.background,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                Icons.play_arrow,
                color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatDuration(track.duration)} • ${track.artist}',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.accent),
          ],
        ),
      ),
    );
  }
}
