import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/widgets/gradient_text.dart';
import 'package:snipvid/widgets/gradient_button.dart';
import 'package:snipvid/widgets/animated_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectService = context.watch<ProjectService>();
    final projects = projectService.projects;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Logo with gradient
              const GradientText(
                'SNIPVID',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tes photos. Ta musique.\nTa vidéo. En 30 sec.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              // CTA Principal with gradient and scale animation
              GradientButton(
                onPressed: () {
                  projectService.createNewProject();
                  context.push('/photos');
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('CRÉER UNE VIDÉO'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Projets récents
              if (projects.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mes projets (${projects.length})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return AnimatedCard(
                        width: 100,
                        height: 100,
                        showGradientBorder: false,
                        onTap: () {
                          projectService.loadProject(project.id);
                          context.push('/photos');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.video_library, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              project.name ?? 'Sans titre',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
