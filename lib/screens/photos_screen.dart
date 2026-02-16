import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snipvid/services/project_service.dart';
import 'package:snipvid/theme/app_theme.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});

  Future<void> _pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty && context.mounted) {
      final paths = images.map((x) => x.path).toList();
      context.read<ProjectService>().setPhotos(paths);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectService = context.watch<ProjectService>();
    final photos = projectService.currentProject?.photoPaths ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Sélectionne tes photos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Zone d'ajout
            GestureDetector(
              onTap: () => _pickImages(context),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.textSecondary.withOpacity(0.3),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AJOUTER DES PHOTOS',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grille photos
            Expanded(
              child: photos.isEmpty
                  ? Center(
                      child: Text(
                        'Aucune photo sélectionnée',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: photos.length,
                      onReorder: projectService.reorderPhotos,
                      itemBuilder: (context, index) {
                        final path = photos[index];
                        return ReorderableDragStartListener(
                          key: ValueKey(path),
                          index: index,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _PhotoTile(
                              path: path,
                              index: index,
                              onRemove: () => projectService.removePhoto(path),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Compteur + CTA
            if (photos.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${photos.length} photo${photos.length > 1 ? 's' : ''} sélectionnée${photos.length > 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Maintiens pour réordonner',
                style: TextStyle(
                  color: AppTheme.textSecondary.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: photos.isEmpty ? null : () => context.push('/music'),
              child: const Text('CONTINUER'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String path;
  final int index;
  final VoidCallback onRemove;

  const _PhotoTile({
    required this.path,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.file(
              File(path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Photo ${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onRemove,
            color: AppTheme.textSecondary,
          ),
          Icon(Icons.drag_handle, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
