import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../viewmodel/story_view_model.dart'; // 추가: DotEnv 패키지

final authServiceProvider = StateNotifierProvider<AuthService, User?>((ref) {
  return AuthService(ref);
});

class AuthService extends StateNotifier<User?> {
  final Ref _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn;

  AuthService(this._ref)
      : _googleSignIn = GoogleSignIn(
    clientId: '174839303003-ntfa4g52f5f6601oq7p1apa3dem9mg62.apps.googleusercontent.com',
    scopes: ['email'],
  ),
        super(FirebaseAuth.instance.currentUser);

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      log('Initializing Google Sign-In with clientId: ${_googleSignIn.clientId}');
      if (_googleSignIn.clientId == null || _googleSignIn.clientId!.isEmpty) {
        throw Exception('Google Sign-In 클라이언트 ID가 설정되지 않았습니다. 환경 변수를 확인하세요.');
      }

      final isSignedIn = await _googleSignIn.isSignedIn();
      GoogleSignInAccount? googleUser;

      if (isSignedIn) {
        googleUser = await _googleSignIn.signInSilently();
        log('기존 계정으로 자동 로그인 시도');
      } else {
        googleUser = await _googleSignIn.signIn();
        log('로그인 창 표시됨');
      }

      if (googleUser == null) {
        log('사용자가 로그인을 취소했거나 실패함');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인이 취소되었습니다.')),
        );
        return;
      }

      final googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        log('Google auth tokens are null: accessToken=$accessToken, idToken=$idToken');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google 인증 토큰을 가져오지 못했습니다.')),
        );
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      await _auth.signInWithCredential(credential);
      state = _auth.currentUser;

      log('로그인 성공: ${state?.email}');

      // Firestore에서 사용자 데이터 확인
      final uid = state!.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final nickname = doc.data()?['username'] as String?;

      if (doc.exists && nickname != null && nickname.isNotEmpty) {
        _ref.invalidate(storyViewModelProvider);
        Navigator.pushReplacementNamed(context, '/main_dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자 등록이 필요합니다. 관리자에게 문의하세요.')),
        );
      }
    } catch (e, stackTrace) {
      log('로그인 실패: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (_) {}
    await _googleSignIn.signOut();
    await _auth.signOut();
    state = null;
    log('로그아웃 완료');
  }
}