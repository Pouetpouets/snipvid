import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:snipvid/models/project.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/theme/app_theme.dart';

// Musiques de démo (à remplacer par Pixabay API)
final _demoTracks = [
  MusicTrack(
    id: '1',
    title: 'Happy Vibes',
    artist: 'Upbeat',
    duration: Duration(minutes: 2, seconds: 34),
  ),
  MusicTrack(
    id: '2',
    title: 'Emotional Piano',
    artist: 'Slow',
    duration: Duration(minutes: 3, seconds: 12),
  ),
  MusicTrack(
    id: '3',
    title: 'Epic Adventure',
    artist: 'Cinematic',
    duration: Duration(minutes: 2, seconds: 58),
  ),
  MusicTrack(
    id: '4',
    title: 'Summer Chill',
    artist: 'Relaxing',
    duration: Duration(minutes: 3, seconds: 45),
  ),
];

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  String? _selectedTrackId;

  @override
  void initState() {
    super.initState();
    final current = context.read<ProjectService>().currentProject?.music;
    _selectedTrackId = current?.id;
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(child: Divider(color: AppTheme.textSecondary.withOpacity(0.3))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ou explore',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                Expanded(child: Divider(color: AppTheme.textSecondary.withOpacity(0.3))),
              ],
            ),
            const SizedBox(height: 24),
            // Section populaires
            Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Populaires',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Liste tracks
            Expanded(
              child: ListView.separated(
                itemCount: _demoTracks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final track = _demoTracks[index];
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
                      final track = _demoTracks.firstWhere((t) => t.id == _selectedTrackId);
                      context.read<ProjectService>().setMusic(track);
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
            Icon(
              Icons.play_circle_outline,
              color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
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
