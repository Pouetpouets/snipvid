import 'package:snipvid/models/project.dart';

/// Service pour gérer la bibliothèque musicale.
/// 
/// MVP : Tracks bundlées dans assets/audio/
/// V2 : Intégration Jamendo API
class MusicService {
  /// Tracks bundlées dans l'app (Pixabay - royalty-free)
  static final List<MusicTrack> bundledTracks = [
    // 🔥 Upbeat / Energetic
    MusicTrack(
      id: 'vlog_hiphop',
      title: 'Vlog Hip-Hop',
      artist: 'ProducesPlatinum',
      duration: Duration(minutes: 1, seconds: 53),
      url: 'assets/audio/vlog_hiphop.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'groovy_trap',
      title: 'Berry (Groovy Bass)',
      artist: 'GiorgioVitté',
      duration: Duration(minutes: 2, seconds: 22),
      url: 'assets/audio/groovy_trap.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'no_sleep',
      title: 'No Sleep',
      artist: 'kontraa',
      duration: Duration(minutes: 2, seconds: 46),
      url: 'assets/audio/no_sleep_hiphop.mp3',
      isLocal: true,
    ),
    
    // 🌊 Chill / Relaxing
    MusicTrack(
      id: 'summer_lounge',
      title: 'Night Summer Lounge',
      artist: 'Bransboynd',
      duration: Duration(minutes: 1, seconds: 41),
      url: 'assets/audio/summer_lounge.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'lofi_jazzy',
      title: 'Lo-fi Sentimental Jazzy',
      artist: 'Sonican',
      duration: Duration(minutes: 1, seconds: 40),
      url: 'assets/audio/lofi_jazzy.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'nature_ambient',
      title: 'New Age Nature',
      artist: 'Sonican',
      duration: Duration(minutes: 2, seconds: 24),
      url: 'assets/audio/nature_ambient.mp3',
      isLocal: true,
    ),
    
    // 🎹 Emotional / Cinematic
    MusicTrack(
      id: 'cinematic_inspiring',
      title: 'Inspiring Cinematic',
      artist: 'Tunetank',
      duration: Duration(minutes: 2, seconds: 12),
      url: 'assets/audio/cinematic_inspiring.mp3',
      isLocal: true,
    ),
    
    // 🎬 Epic / Action
    MusicTrack(
      id: 'epic_adventure',
      title: 'Epic Adventure',
      artist: 'kornevmusic',
      duration: Duration(minutes: 2, seconds: 0),
      url: 'assets/audio/epic_adventure.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'sport_rock',
      title: 'Inspiring Sport Rock',
      artist: 'AlexGrohl',
      duration: Duration(minutes: 2, seconds: 8),
      url: 'assets/audio/sport_rock.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'dark_cyberpunk',
      title: 'Dark Cyberpunk',
      artist: 'FreeMusicLab',
      duration: Duration(minutes: 1, seconds: 58),
      url: 'assets/audio/dark_cyberpunk.mp3',
      isLocal: true,
    ),
  ];

  /// Catégories de musique
  static const Map<String, List<String>> categories = {
    '🔥 Upbeat': ['vlog_hiphop', 'groovy_trap', 'no_sleep'],
    '🌊 Chill': ['summer_lounge', 'lofi_jazzy', 'nature_ambient'],
    '🎹 Cinematic': ['cinematic_inspiring'],
    '🎬 Epic': ['epic_adventure', 'sport_rock', 'dark_cyberpunk'],
  };

  /// Récupère toutes les tracks
  List<MusicTrack> getAllTracks() => bundledTracks;

  /// Récupère les tracks par catégorie
  List<MusicTrack> getTracksByCategory(String category) {
    final ids = categories[category] ?? [];
    return bundledTracks.where((t) => ids.contains(t.id)).toList();
  }

  /// Récupère une track par ID
  MusicTrack? getTrackById(String id) {
    try {
      return bundledTracks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Tracks recommandées pour un vibe donné
  List<MusicTrack> getTracksForVibe(VibeType vibe) {
    switch (vibe) {
      case VibeType.dynamic:
        return getTracksByCategory('🔥 Upbeat');
      case VibeType.slow:
        return [
          ...getTracksByCategory('🌊 Chill'),
          ...getTracksByCategory('🎹 Cinematic'),
        ];
      case VibeType.mix:
        return bundledTracks; // Toutes
      case VibeType.epic:
        return [
          ...getTracksByCategory('🎬 Epic'),
          ...getTracksByCategory('🎹 Cinematic'),
        ];
    }
  }
}
