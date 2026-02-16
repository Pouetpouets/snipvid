import 'package:flutter/foundation.dart';
import 'package:snipvid/models/project.dart';

class ProjectService extends ChangeNotifier {
  Project? _currentProject;
  final List<Project> _projects = [];

  Project? get currentProject => _currentProject;
  List<Project> get projects => List.unmodifiable(_projects);

  void createNewProject() {
    _currentProject = Project();
    notifyListeners();
  }

  void setPhotos(List<String> paths) {
    if (_currentProject == null) return;
    _currentProject = _currentProject!.copyWith(photoPaths: paths);
    notifyListeners();
  }

  void addPhoto(String path) {
    if (_currentProject == null) return;
    final newPaths = [..._currentProject!.photoPaths, path];
    _currentProject = _currentProject!.copyWith(photoPaths: newPaths);
    notifyListeners();
  }

  void removePhoto(String path) {
    if (_currentProject == null) return;
    final newPaths = _currentProject!.photoPaths.where((p) => p != path).toList();
    _currentProject = _currentProject!.copyWith(photoPaths: newPaths);
    notifyListeners();
  }

  void reorderPhotos(int oldIndex, int newIndex) {
    if (_currentProject == null) return;
    final paths = [..._currentProject!.photoPaths];
    if (newIndex > oldIndex) newIndex--;
    final item = paths.removeAt(oldIndex);
    paths.insert(newIndex, item);
    _currentProject = _currentProject!.copyWith(photoPaths: paths);
    notifyListeners();
  }

  void setMusic(MusicTrack track) {
    if (_currentProject == null) return;
    _currentProject = _currentProject!.copyWith(music: track);
    notifyListeners();
  }

  void setVibe(VibeType vibe) {
    if (_currentProject == null) return;
    _currentProject = _currentProject!.copyWith(vibe: vibe);
    notifyListeners();
  }

  void setExportRatio(ExportRatio ratio) {
    if (_currentProject == null) return;
    _currentProject = _currentProject!.copyWith(exportRatio: ratio);
    notifyListeners();
  }

  void setOutputPath(String path) {
    if (_currentProject == null) return;
    _currentProject = _currentProject!.copyWith(outputPath: path);
    notifyListeners();
  }

  void saveCurrentProject() {
    if (_currentProject == null) return;
    final index = _projects.indexWhere((p) => p.id == _currentProject!.id);
    if (index >= 0) {
      _projects[index] = _currentProject!;
    } else {
      _projects.add(_currentProject!);
    }
    notifyListeners();
  }

  void loadProject(String id) {
    _currentProject = _projects.firstWhere((p) => p.id == id);
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    if (_currentProject?.id == id) {
      _currentProject = null;
    }
    notifyListeners();
  }
}
