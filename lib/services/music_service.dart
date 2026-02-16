import 'package:snipvid/models/project.dart';

/// Service pour gérer la bibliothèque musicale.
/// 
/// MVP : Tracks bundlées dans assets/audio/
/// V2 : Intégration Jamendo API
class MusicService {
  /// Tracks bundlées dans l'app (royalty-free)
  /// 
  /// À télécharger depuis https://pixabay.com/music/
  /// Formats acceptés : MP3, durée 1-3 min
  static final List<MusicTrack> bundledTracks = [
    // 🔥 Upbeat / Dynamique
    MusicTrack(
      id: 'upbeat_1',
      title: 'Happy Day',
      artist: 'Upbeat',
      duration: Duration(minutes: 2, seconds: 15),
      url: 'assets/audio/happy_day.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'upbeat_2',
      title: 'Good Vibes',
      artist: 'Energetic',
      duration: Duration(minutes: 1, seconds: 58),
      url: 'assets/audio/good_vibes.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'upbeat_3',
      title: 'Celebrate',
      artist: 'Party',
      duration: Duration(minutes: 2, seconds: 30),
      url: 'assets/audio/celebrate.mp3',
      isLocal: true,
    ),
    
    // 🌊 Chill / Lent
    MusicTrack(
      id: 'chill_1',
      title: 'Peaceful Moments',
      artist: 'Ambient',
      duration: Duration(minutes: 3, seconds: 12),
      url: 'assets/audio/peaceful_moments.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'chill_2',
      title: 'Sunset Dreams',
      artist: 'Relaxing',
      duration: Duration(minutes: 2, seconds: 45),
      url: 'assets/audio/sunset_dreams.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'chill_3',
      title: 'Ocean Breeze',
      artist: 'Nature',
      duration: Duration(minutes: 3, seconds: 00),
      url: 'assets/audio/ocean_breeze.mp3',
      isLocal: true,
    ),
    
    // 🎹 Emotional / Piano
    MusicTrack(
      id: 'emotional_1',
      title: 'Memories',
      artist: 'Piano',
      duration: Duration(minutes: 2, seconds: 50),
      url: 'assets/audio/memories.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'emotional_2',
      title: 'Tender Heart',
      artist: 'Emotional',
      duration: Duration(minutes: 3, seconds: 20),
      url: 'assets/audio/tender_heart.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'emotional_3',
      title: 'Nostalgia',
      artist: 'Cinematic',
      duration: Duration(minutes: 2, seconds: 35),
      url: 'assets/audio/nostalgia.mp3',
      isLocal: true,
    ),
    
    // 🎬 Epic / Cinematic
    MusicTrack(
      id: 'epic_1',
      title: 'Rise Up',
      artist: 'Epic',
      duration: Duration(minutes: 2, seconds: 40),
      url: 'assets/audio/rise_up.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'epic_2',
      title: 'Adventure Awaits',
      artist: 'Cinematic',
      duration: Duration(minutes: 3, seconds: 05),
      url: 'assets/audio/adventure_awaits.mp3',
      isLocal: true,
    ),
    MusicTrack(
      id: 'epic_3',
      title: 'Triumphant',
      artist: 'Orchestral',
      duration: Duration(minutes: 2, seconds: 55),
      url: 'assets/audio/triumphant.mp3',
      isLocal: true,
    ),
  ];

  /// Catégories de musique
  static const Map<String, List<String>> categories = {
    '🔥 Upbeat': ['upbeat_1', 'upbeat_2', 'upbeat_3'],
    '🌊 Chill': ['chill_1', 'chill_2', 'chill_3'],
    '🎹 Emotional': ['emotional_1', 'emotional_2', 'emotional_3'],
    '🎬 Epic': ['epic_1', 'epic_2', 'epic_3'],
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
          ...getTracksByCategory('🎹 Emotional'),
        ];
      case VibeType.mix:
        return bundledTracks; // Toutes
      case VibeType.epic:
        return getTracksByCategory('🎬 Epic');
    }
  }
}
