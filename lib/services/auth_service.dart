import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../viewmodel/story_view_model.dart';

final authServiceProvider = StateNotifierProvider<AuthService, User?>((ref) {
  return AuthService(ref);
});

class AuthService extends StateNotifier<User?> {
  final Ref _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn;

  AuthService(this._ref)
      : _googleSignIn = GoogleSignIn(
    clientId: '174839303003-huddi6sn9b16o8cs2l8ed3m6e0uomc7l.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  ),
        super(FirebaseAuth.instance.currentUser);

  Future<void> signInWithGoogle(BuildContext context, GoogleSignInAccount? user) async {
    if (user == null) {
      log('Google Sign-In: User is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In에서 사용자 정보를 가져오지 못했습니다.')),
      );
      return;
    }

    try {
      log('Attempting to get idToken for user: ${user.email}');
      final auth = await user.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        log('Google Sign-In: idToken is null');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In에서 idToken을 가져오지 못했습니다.')),
        );
        return;
      }

      log('Attempting Firebase sign-in with idToken');
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _auth.signInWithCredential(credential);
      state = _auth.currentUser;
      log('Firebase sign-in successful: ${state?.email}, uid=${state?.uid}');

      final uid = state!.uid;
      var doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // 문서가 없으면 생성
      if (!doc.exists) {
        final username = user.displayName ?? user.email?.split('@')[0] ?? 'Anonymous';
        log('User document does not exist for uid: $uid, creating new document with username: $username');
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        log('Created new user document for uid: $uid');
        // 문서 생성 후 재조회
        doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      }

      if (doc.exists) {
        final nickname = doc.data()?['username'] as String?;
        log('User document exists for uid: $uid, username: $nickname');
        _ref.invalidate(storyViewModelProvider);
        Navigator.pushReplacementNamed(context, '/main_dashboard');
      } else {
        log('User document still does not exist after creation for uid: $uid');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용자 등록에 실패했습니다. 관리자에게 문의하세요.')),
        );
      }
    } catch (e, stackTrace) {
      log('Firebase sign-in failed: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
      if (e.toString().contains('popup')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('브라우저의 팝업 차단을 해제하고 다시 시도하세요.')),
        );
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      log('Google Sign-In signed out');
      await _auth.signOut();
      state = null;
      log('Sign-out completed');
    } catch (e) {
      log('Sign-out failed: $e');
    }
  }
}