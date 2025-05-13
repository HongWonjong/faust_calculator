import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider((ref) => StorageService());

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseStorage get instance => _storage;

  Future<String> uploadFile(String path, List<int> data) async {
    final ref = _storage.ref(path);
    final uploadTask = await ref.putData(Uint8List.fromList(data));
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> deleteFile(String path) async {
    await _storage.ref(path).delete();
  }
}