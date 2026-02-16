import 'package:uuid/uuid.dart';

enum VibeType {
  dynamic,
  slow,
  mix,
  epic,
}

extension VibeTypeExtension on VibeType {
  String get label {
    switch (this) {
      case VibeType.dynamic:
        return 'Dynamique';
      case VibeType.slow:
        return 'Lent';
      case VibeType.mix:
        return 'Mix';
      case VibeType.epic:
        return 'Épique';
    }
  }

  String get icon {
    switch (this) {
      case VibeType.dynamic:
        return '⚡';
      case VibeType.slow:
        return '🌊';
      case VibeType.mix:
        return '🎲';
      case VibeType.epic:
        return '🎬';
    }
  }

  String get description {
    switch (this) {
      case VibeType.dynamic:
        return 'Cuts rapides, beat-sync';
      case VibeType.slow:
        return 'Transitions douces, émotionnel';
      case VibeType.mix:
        return 'Varié, surprise';
      case VibeType.epic:
        return 'Build-up, climax';
    }
  }
}

enum ExportRatio {
  portrait, // 9:16 (Reels, TikTok, Stories)
  square,   // 1:1 (Feed)
  landscape, // 16:9 (YouTube)
}

extension ExportRatioExtension on ExportRatio {
  String get label {
    switch (this) {
      case ExportRatio.portrait:
        return '9:16';
      case ExportRatio.square:
        return '1:1';
      case ExportRatio.landscape:
        return '16:9';
    }
  }

  String get subtitle {
    switch (this) {
      case ExportRatio.portrait:
        return 'Reels';
      case ExportRatio.square:
        return 'Feed';
      case ExportRatio.landscape:
        return 'YT';
    }
  }

  double get aspectRatio {
    switch (this) {
      case ExportRatio.portrait:
        return 9 / 16;
      case ExportRatio.square:
        return 1;
      case ExportRatio.landscape:
        return 16 / 9;
    }
  }
}

class MusicTrack {
  final String id;
  final String title;
  final String? artist;
  final Duration duration;
  final String? url; // URL ou path local
  final bool isLocal;

  const MusicTrack({
    required this.id,
    required this.title,
    this.artist,
    required this.duration,
    this.url,
    this.isLocal = false,
  });
}

class Project {
  final String id;
  String? name;
  final DateTime createdAt;
  DateTime updatedAt;
  List<String> photoPaths;
  MusicTrack? music;
  VibeType? vibe;
  ExportRatio exportRatio;
  String? outputPath;

  Project({
    String? id,
    this.name,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? photoPaths,
    this.music,
    this.vibe,
    this.exportRatio = ExportRatio.portrait,
    this.outputPath,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        photoPaths = photoPaths ?? [];

  bool get isReadyToProcess =>
      photoPaths.isNotEmpty && music != null && vibe != null;

  Project copyWith({
    String? name,
    List<String>? photoPaths,
    MusicTrack? music,
    VibeType? vibe,
    ExportRatio? exportRatio,
    String? outputPath,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      photoPaths: photoPaths ?? this.photoPaths,
      music: music ?? this.music,
      vibe: vibe ?? this.vibe,
      exportRatio: exportRatio ?? this.exportRatio,
      outputPath: outputPath ?? this.outputPath,
    );
  }
}
