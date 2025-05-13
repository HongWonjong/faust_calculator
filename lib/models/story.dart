import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String id;
  final String title;
  final Map<String, dynamic> settings;
  final String overview;
  final List<String> tags;
  final Timestamp createdAt;

  Story({
    required this.id,
    required this.title,
    required this.settings,
    required this.overview,
    required this.tags,
    required this.createdAt,
  });

  factory Story.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Story(
      id: doc.id,
      title: data['title'] ?? '',
      settings: data['settings'] ?? {},
      overview: data['overview'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'settings': settings,
    'overview': overview,
    'tags': tags,
    'createdAt': createdAt,
  };
}