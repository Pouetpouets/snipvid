import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:snipvid/models/project.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/services/video_service.dart';
import 'package:snipvid/theme/app_theme.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  ExportRatio _selectedRatio = ExportRatio.portrait;
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideo();
    });
  }

  Future<void> _initializeVideo() async {
    final project = context.read<ProjectService>().currentProject;
    if (project?.outputPath == null) return;

    final file = File(project!.outputPath!);
    if (!await file.exists()) {
      debugPrint('ExportScreen: Video file does not exist');
      return;
    }

    _controller = VideoPlayerController.file(file);

    try {
      await _controller!.initialize();
      await _controller!.setLooping(true);
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('ExportScreen: Failed to initialize video - $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _exportVideo({required bool withWatermark}) async {
    final project = context.read<ProjectService>().currentProject;
    if (project?.outputPath == null) return;

    setState(() => _isExporting = true);

    try {
      String videoToShare = project!.outputPath!;

      if (withWatermark) {
        // Add watermark using VideoService
        final videoService = VideoService();
        final watermarkedPath = await videoService.addWatermark(
          project.outputPath!,
          'assets/images/watermark.png',
        );

        if (watermarkedPath != null) {
          videoToShare = watermarkedPath;
        } else {
          // Fallback: share original if watermark fails
          debugPrint('ExportScreen: Watermark failed, sharing original');
        }
      }

      // Share the video
      final result = await Share.shareXFiles(
        [XFile(videoToShare)],
        text: 'Créé avec Snipvid ✨',
      );

      if (result.status == ShareResultStatus.success && mounted) {
        _showExportSuccess(context, withWatermark: withWatermark);
      }
    } catch (e) {
      debugPrint('ExportScreen: Export failed - $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export: $e'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

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
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _buildVideoPlayer(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Video position/duration
            if (_isInitialized && _controller != null)
              _buildVideoProgress(),
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
                                  ? Colors.white.withValues(alpha: 0.8)
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
              onPressed: _isExporting ? null : () => _exportVideo(withWatermark: true),
              child: _isExporting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.textSecondary,
                      ),
                    )
                  : const Text('EXPORTER (watermark)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isExporting ? null : () => _exportVideo(withWatermark: false),
              child: _isExporting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
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

  Widget _buildVideoPlayer() {
    if (!_isInitialized || _controller == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.accent),
            SizedBox(height: 16),
            Text(
              'Chargement de la vidéo...',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
        // Play/Pause overlay
        AnimatedOpacity(
          opacity: _controller!.value.isPlaying ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoProgress() {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller!,
      builder: (context, value, child) {
        final position = value.position;
        final duration = value.duration;
        
        return Column(
          children: [
            // Progress bar
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: AppTheme.accent,
                inactiveTrackColor: AppTheme.surfaceLight,
                thumbColor: AppTheme.accent,
                overlayColor: AppTheme.accent.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: position.inMilliseconds.toDouble(),
                min: 0,
                max: duration.inMilliseconds.toDouble().clamp(1, double.infinity),
                onChanged: (value) {
                  _controller!.seekTo(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
            // Time labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
