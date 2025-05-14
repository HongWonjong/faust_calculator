import 'package:cloud_firestore/cloud_firestore.dart';

class CollaborationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCollaborator(
      String userId, String storyId, String collaboratorId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('Stories')
        .doc(storyId)
        .update({
      'collaborators': FieldValue.arrayUnion([collaboratorId])
    });
  }

  Stream<List<String>> getCollaborators(String userId, String storyId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('Stories')
        .doc(storyId)
        .snapshots()
        .map((snapshot) =>
    List<String>.from(snapshot.data()?['collaborators'] ?? []));
  }
}