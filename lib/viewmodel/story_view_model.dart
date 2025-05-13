import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story.dart';
import '../models/part.dart';
import '../repository/story_repository.dart';
import '../services/ai_service.dart';
import '../services/firestore_service.dart';

final storyRepositoryProvider = Provider((ref) => StoryRepository(ref.watch(firestoreServiceProvider)));final aiServiceProvider = Provider((ref) => AIService());

final storiesProvider = StreamProvider.family<List<Story>, String>((ref, userId) {
  return ref.watch(storyRepositoryProvider).getStories(userId);
});

final partsProvider =
StreamProvider.family<List<Part>, Map<String, String>>((ref, params) {
  return ref
      .watch(storyRepositoryProvider)
      .getParts(params['userId']!, params['storyId']!);
});

class StoryViewModel extends StateNotifier<Story?> {
  final StoryRepository _repository;
  final AIService _aiService;

  StoryViewModel(this._repository, this._aiService) : super(null);

  void selectStory(Story story) => state = story;

  Future<void> createStory(String userId, String title) async {
    final newStory = Story(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      settings: {'genre': 'fantasy', 'ending': 'open'},
      overview: '',
      tags: [],
      createdAt: Timestamp.now(),
    );
    await _repository.addStory(userId, newStory);
  }

  Future<void> createPart(String userId, String storyId) async {
    final newPart = Part(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      background: {},
      groups: {},
      individuals: {},
      story: '',
      plausibility: 0.85,
    );
    await _repository.addPart(userId, storyId, newPart);
  }

  Future<String> generateStoryContent(Map<String, dynamic> data) async {
    return await _aiService.generateStory(data);
  }
}

final storyViewModelProvider =
StateNotifierProvider<StoryViewModel, Story?>((ref) {
  return StoryViewModel(
    ref.watch(storyRepositoryProvider),
    ref.watch(aiServiceProvider),
  );
});