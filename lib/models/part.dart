import 'package:cloud_firestore/cloud_firestore.dart';

class Part {
  final String id;
  final Map<String, dynamic> background;
  final Map<String, dynamic> groups;
  final Map<String, dynamic> individuals;
  final String story;
  final double plausibility;

  Part({
    required this.id,
    required this.background,
    required this.groups,
    required this.individuals,
    required this.story,
    required this.plausibility,
  });

  factory Part.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Part(
      id: doc.id,
      background: data['background'] ?? {},
      groups: data['groups'] ?? {},
      individuals: data['individuals'] ?? {},
      story: data['story'] ?? '',
      plausibility: (data['plausibility'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'background': background,
    'groups': groups,
    'individuals': individuals,
    'story': story,
    'plausibility': plausibility,
  };
}