import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snipvid/models/project.dart';

/// Service de génération vidéo avec FFmpeg
class VideoService {
  /// Callback pour le progress (0.0 - 1.0)
  final ValueChanged<double>? onProgress;
  
  VideoService({this.onProgress});

  /// Génère une vidéo à partir des photos et de la musique
  /// 
  /// Retourne le path de la vidéo générée ou null si échec
  Future<String?> generateVideo(Project project) async {
    if (project.photoPaths.isEmpty || project.music == null || project.vibe == null) {
      debugPrint('VideoService: Project incomplete');
      return null;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/snipvid_${DateTime.now().millisecondsSinceEpoch}.mp4';
      
      // Paramètres selon le vibe
      final vibeParams = _getVibeParams(project.vibe!);
      
      // Paramètres selon le ratio
      final ratioParams = _getRatioParams(project.exportRatio);
      
      // Construire la commande FFmpeg
      final command = await _buildCommand(
        photos: project.photoPaths,
        musicPath: project.music!.url ?? '',
        outputPath: outputPath,
        vibeParams: vibeParams,
        ratioParams: ratioParams,
      );

      debugPrint('FFmpeg command: $command');

      // Exécuter FFmpeg
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        debugPrint('VideoService: Video generated at $outputPath');
        return outputPath;
      } else {
        final logs = await session.getAllLogsAsString();
        debugPrint('VideoService: FFmpeg failed - $logs');
        return null;
      }
    } catch (e) {
      debugPrint('VideoService: Error - $e');
      return null;
    }
  }

  /// Paramètres de montage selon le vibe
  _VibeParams _getVibeParams(VibeType vibe) {
    switch (vibe) {
      case VibeType.dynamic:
        return _VibeParams(
          photoDuration: 0.8,  // Rapide
          transition: 'fade',
          transitionDuration: 0.2,
        );
      case VibeType.slow:
        return _VibeParams(
          photoDuration: 3.5,  // Lent, émotionnel
          transition: 'fade',
          transitionDuration: 1.0,
        );
      case VibeType.mix:
        return _VibeParams(
          photoDuration: 2.0,  // Moyen
          transition: 'fade',
          transitionDuration: 0.5,
        );
      case VibeType.epic:
        return _VibeParams(
          photoDuration: 2.5,  // Build-up progressif
          transition: 'fade',
          transitionDuration: 0.8,
        );
    }
  }

  /// Paramètres de résolution selon le ratio
  _RatioParams _getRatioParams(ExportRatio ratio) {
    switch (ratio) {
      case ExportRatio.portrait:
        return _RatioParams(width: 1080, height: 1920); // 9:16
      case ExportRatio.square:
        return _RatioParams(width: 1080, height: 1080); // 1:1
      case ExportRatio.landscape:
        return _RatioParams(width: 1920, height: 1080); // 16:9
    }
  }

  /// Construit la commande FFmpeg
  Future<String> _buildCommand({
    required List<String> photos,
    required String musicPath,
    required String outputPath,
    required _VibeParams vibeParams,
    required _RatioParams ratioParams,
  }) async {
    final tempDir = await getTemporaryDirectory();
    
    // Créer un fichier de liste des images pour FFmpeg
    final listFile = File('${tempDir.path}/images.txt');
    final listContent = photos.map((p) => "file '$p'\nduration ${vibeParams.photoDuration}").join('\n');
    // Ajouter la dernière image sans durée (requis par FFmpeg)
    final fullContent = '$listContent\nfile \'${photos.last}\'';
    await listFile.writeAsString(fullContent);

    // Commande FFmpeg
    // -f concat : utilise le fichier de liste
    // -vf scale : redimensionne + crop pour le ratio
    // -c:v libx264 : codec vidéo H.264
    // -c:a aac : codec audio AAC
    // -shortest : arrête quand le plus court (audio ou vidéo) finit
    final scaleFilter = 'scale=${ratioParams.width}:${ratioParams.height}:force_original_aspect_ratio=increase,crop=${ratioParams.width}:${ratioParams.height}';
    
    return '-f concat -safe 0 -i "${listFile.path}" '
        '-i "$musicPath" '
        '-vf "$scaleFilter" '
        '-c:v libx264 -preset fast -crf 23 '
        '-c:a aac -b:a 192k '
        '-pix_fmt yuv420p '
        '-shortest '
        '-y "$outputPath"';
  }

  /// Ajoute un watermark à la vidéo
  Future<String?> addWatermark(String videoPath, String watermarkPath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/snipvid_watermarked_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Position: coin bas droit, 10px de marge, opacity 70%
      final command = '-i "$videoPath" '
          '-i "$watermarkPath" '
          '-filter_complex "[1:v]format=rgba,colorchannelmixer=aa=0.7[wm];[0:v][wm]overlay=W-w-20:H-h-20" '
          '-c:a copy '
          '-y "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      }
      return null;
    } catch (e) {
      debugPrint('VideoService: Watermark error - $e');
      return null;
    }
  }
}

class _VibeParams {
  final double photoDuration;
  final String transition;
  final double transitionDuration;

  _VibeParams({
    required this.photoDuration,
    required this.transition,
    required this.transitionDuration,
  });
}

class _RatioParams {
  final int width;
  final int height;

  _RatioParams({required this.width, required this.height});
}
