import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story.dart';
import '../models/part.dart';

class StoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Story>> getStories(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('Stories')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Story.fromFirestore(doc)).toList());
  }

  Future<void> addStory(String userId, Story story) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('Stories')
        .doc(story.id)
        .set(story.toFirestore());
  }


  Stream<List<Part>> getParts(String userId, String storyId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('Stories')
        .doc(storyId)
        .collection('Parts')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Part.fromFirestore(doc)).toList());
  }

  Future<void> addPart(String userId, String storyId, Part part) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('Stories')
        .doc(storyId)
        .collection('Parts')
        .doc(part.id)
        .set(part.toFirestore());
  }
}