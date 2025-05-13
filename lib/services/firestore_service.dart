import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  Stream<QuerySnapshot> collectionStream(String path) {
    return _firestore.collection(path).snapshots();
  }

  Future<void> setDocument(String path, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(path).doc(docId).set(data);
  }

  Future<DocumentSnapshot> getDocument(String path, String docId) async {
    return await _firestore.collection(path).doc(docId).get();
  }
}