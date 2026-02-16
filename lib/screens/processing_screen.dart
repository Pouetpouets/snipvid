import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/services/video_service.dart';
import 'package:snipvid/theme/app_theme.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  double _progress = 0;
  int _messageIndex = 0;
  String? _error;

  final _messages = [
    'On mixe tes souvenirs...',
    'Synchronisation avec le beat...',
    'Ajout de la magie ✨',
    'Presque prêt...',
  ];

  Timer? _messageTimer;
  Timer? _fakeProgressTimer;

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    // Rotation des messages
    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
      }
    });

    // Fake progress pendant le traitement réel
    _fakeProgressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && _progress < 0.9) {
        setState(() {
          _progress += 0.005;
        });
      }
    });

    // Traitement réel
    final projectService = context.read<ProjectService>();
    final project = projectService.currentProject;

    if (project == null) {
      _onError('Projet non trouvé');
      return;
    }

    final videoService = VideoService(
      onProgress: (progress) {
        if (mounted) {
          setState(() => _progress = progress);
        }
      },
    );

    final outputPath = await videoService.generateVideo(project);

    _fakeProgressTimer?.cancel();

    if (outputPath != null) {
      projectService.setOutputPath(outputPath);
      setState(() => _progress = 1.0);
      await Future.delayed(const Duration(milliseconds: 500));
      _onComplete();
    } else {
      _onError('Échec de la génération vidéo');
    }
  }

  void _onComplete() {
    _messageTimer?.cancel();
    _fakeProgressTimer?.cancel();
    if (mounted) {
      context.go('/export');
    }
  }

  void _onError(String message) {
    _messageTimer?.cancel();
    _fakeProgressTimer?.cancel();
    if (mounted) {
      setState(() {
        _error = message;
      });
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _fakeProgressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.error,
                ),
                const SizedBox(height: 24),
                Text(
                  'Oups !',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.go('/vibe'),
                  child: const Text('RÉESSAYER'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Retour à l\'accueil'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Pourcentage
              Text(
                '⚡ ${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  backgroundColor: AppTheme.surface,
                  valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
                ),
              ),
              const SizedBox(height: 32),
              // Message
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _messages[_messageIndex],
                  key: ValueKey(_messageIndex),
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              // Icône
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    '📷→🎬',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
