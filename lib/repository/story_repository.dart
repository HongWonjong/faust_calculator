import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story.dart';
import '../models/part.dart';
import '../services/firestore_service.dart';

class StoryRepository {
  final FirestoreService _firestoreService;

  StoryRepository(this._firestoreService);

  Stream<List<Story>> getStories(String userId) {
    return _firestoreService
        .collectionStream('Users/$userId/Stories')
        .map((snapshot) =>
        snapshot.docs.map((doc) => Story.fromFirestore(doc)).toList());
  }

  Future<void> addStory(String userId, Story story) async {
    await _firestoreService.setDocument(
      'Users/$userId/Stories',
      story.id,
      story.toFirestore(),
    );
  }

  Stream<List<Part>> getParts(String userId, String storyId) {
    return _firestoreService
        .collectionStream('Users/$userId/Stories/$storyId/Parts')
        .map((snapshot) =>
        snapshot.docs.map((doc) => Part.fromFirestore(doc)).toList());
  }

  Future<void> addPart(String userId, String storyId, Part part) async {
    await _firestoreService.setDocument(
      'Users/$userId/Stories/$storyId/Parts',
      part.id,
      part.toFirestore(),
    );
  }
}

final storyRepositoryProvider = Provider((ref) {
  return StoryRepository(ref.watch(firestoreServiceProvider));
});