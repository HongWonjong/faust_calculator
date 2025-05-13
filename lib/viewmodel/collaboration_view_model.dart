import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/collaboration_service.dart';

final collaborationServiceProvider = Provider((ref) => CollaborationService());

class CollaborationViewModel extends StateNotifier<List<String>> {
  final CollaborationService _service;

  CollaborationViewModel(this._service) : super([]);

  void loadCollaborators(String userId, String storyId) {
    _service.getCollaborators(userId, storyId).listen((collaborators) {
      state = collaborators;
    });
  }

  Future<void> addCollaborator(
      String userId, String storyId, String collaboratorId) async {
    await _service.addCollaborator(userId, storyId, collaboratorId);
  }
}

final collaborationViewModelProvider =
StateNotifierProvider<CollaborationViewModel, List<String>>((ref) {
  return CollaborationViewModel(ref.watch(collaborationServiceProvider));
});