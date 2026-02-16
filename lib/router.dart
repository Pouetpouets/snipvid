import 'package:go_router/go_router.dart';
import 'package:snipvid/screens/home_screen.dart';
import 'package:snipvid/screens/photos_screen.dart';
import 'package:snipvid/screens/music_screen.dart';
import 'package:snipvid/screens/vibe_screen.dart';
import 'package:snipvid/screens/processing_screen.dart';
import 'package:snipvid/screens/export_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/photos',
      builder: (context, state) => const PhotosScreen(),
    ),
    GoRoute(
      path: '/music',
      builder: (context, state) => const MusicScreen(),
    ),
    GoRoute(
      path: '/vibe',
      builder: (context, state) => const VibeScreen(),
    ),
    GoRoute(
      path: '/processing',
      builder: (context, state) => const ProcessingScreen(),
    ),
    GoRoute(
      path: '/export',
      builder: (context, state) => const ExportScreen(),
    ),
  ],
);
