import 'package:go_router/go_router.dart';
import 'package:snipvid/screens/home_screen.dart';
import 'package:snipvid/screens/photos_screen.dart';
import 'package:snipvid/screens/music_screen.dart';
import 'package:snipvid/screens/vibe_screen.dart';
import 'package:snipvid/screens/processing_screen.dart';
import 'package:snipvid/screens/export_screen.dart';
import 'package:snipvid/widgets/page_transitions.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => fadeSlideTransition(
        context: context,
        state: state,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/photos',
      pageBuilder: (context, state) => slideRightTransition(
        context: context,
        state: state,
        child: const PhotosScreen(),
      ),
    ),
    GoRoute(
      path: '/music',
      pageBuilder: (context, state) => slideRightTransition(
        context: context,
        state: state,
        child: const MusicScreen(),
      ),
    ),
    GoRoute(
      path: '/vibe',
      pageBuilder: (context, state) => slideRightTransition(
        context: context,
        state: state,
        child: const VibeScreen(),
      ),
    ),
    GoRoute(
      path: '/processing',
      pageBuilder: (context, state) => fadeSlideTransition(
        context: context,
        state: state,
        child: const ProcessingScreen(),
      ),
    ),
    GoRoute(
      path: '/export',
      pageBuilder: (context, state) => fadeSlideTransition(
        context: context,
        state: state,
        child: const ExportScreen(),
      ),
    ),
  ],
);
