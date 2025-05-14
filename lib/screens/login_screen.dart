import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../theme/style.dart';
import '../widgets/sparkle_background_painter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _sparkleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _sparkleAnimation;
  bool _isLoading = false;
  bool _isInitialized = false;
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppStyles.animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppStyles.animationCurve),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: AppStyles.animationCurve),
    );

    _sparkleController = AnimationController(
      duration: AppStyles.sparkleDuration,
      vsync: this,
    )..repeat(reverse: true);
    _sparkleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _controller.forward();

    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId: '174839303003-huddi6sn9b16o8cs2l8ed3m6e0uomc7l.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );
      _initializeGoogleSignIn();
    }
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      log('Initializing Google Sign-In');
      await _googleSignIn.signInSilently();
      log('Google Sign-In initialized');
      setState(() => _isInitialized = true);
    } catch (e) {
      log('Google Sign-In initialization error: $e');
      setState(() => _isInitialized = true); // 초기화 실패해도 버튼 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('초기화 오류: $e')),
      );
    }
  }

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    try {
      log('Starting Google Sign-In');
      final user = await _googleSignIn.signIn();
      log('Google Sign-In completed: user=${user?.email}');
      await ref.read(authServiceProvider.notifier).signInWithGoogle(context, user);
    } catch (e) {
      log('Sign-in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
      if (e.toString().contains('popup')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('브라우저의 팝업 차단을 해제하고 다시 시도하세요.')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppStyles.backgroundGradient,
            ),
            child: AnimatedBuilder(
              animation: _sparkleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: SparkleBackgroundPainter(_sparkleAnimation.value),
                  child: Container(),
                );
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: AppStyles.pagePadding,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Card(
                    color: AppStyles.backgroundDark.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: AppStyles.neonGlow.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    elevation: 0,
                    child: Container(
                      padding: AppStyles.cardPadding,
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '파우스트의 계산기',
                            style: AppStyles.headline.copyWith(
                              fontSize: 40,
                              shadows: [AppStyles.neonGlowShadow],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '파우스트의 계산기는 당신의 창작을 위한 궁극의 도구입니다.\n'
                                '복잡한 스토리를 체계적으로 관리하고,\n'
                                '캐릭터와 세계관을 2D 맵과 관계 그래프로 시각화하며,\n'
                                'AI의 도움을 받아 일관성 있는 이야기를 생성하세요.\n'
                                '지금 상상의 문을 열고, 당신만의 서사를 만들어 보세요!',
                            style: AppStyles.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          _isLoading
                              ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppStyles.primaryColor),
                          )
                              : _isInitialized
                              ? ElevatedButton(
                            onPressed: _handleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              shadowColor: AppStyles.neonGlow,
                            ),
                            child: const Text(
                              'Google로 로그인',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                              : const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppStyles.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}