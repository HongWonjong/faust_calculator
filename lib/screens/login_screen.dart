import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../theme/style.dart';

class LoginScreen extends ConsumerStatefulWidget {
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

  @override
  void initState() {
    super.initState();
    // 메인 애니메이션 컨트롤러
    _controller = AnimationController(
      duration: AppStyles.animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppStyles.animationCurve),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: AppStyles.animationCurve),
    );

    // 반짝임 애니메이션 컨트롤러
    _sparkleController = AnimationController(
      duration: AppStyles.sparkleDuration,
      vsync: this,
    )..repeat(reverse: true);
    _sparkleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _controller.forward();
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
          // 배경
          Container(
            decoration: BoxDecoration(
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
          // 메인 콘텐츠
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
                      constraints: BoxConstraints(maxWidth: 450),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 로고
                          Text(
                            '파우스트의 계산기',
                            style: AppStyles.headline.copyWith(
                              fontSize: 40,
                              shadows: [
                                AppStyles.neonGlowShadow,
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          // 디테일한 소개 텍스트
                          Text(
                            '파우스트의 계산기는 당신의 창작을 위한 궁극의 도구입니다.\n'
                                '복잡한 스토리를 체계적으로 관리하고,\n'
                                '캐릭터와 세계관을 2D 맵과 관계 그래프로 시각화하며,\n'
                                'AI의 도움을 받아 일관성 있는 이야기를 생성하세요.\n'
                                '지금 상상의 문을 열고, 당신만의 서사를 만들어 보세요!',
                            style: AppStyles.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),
                          // Google 로그인 버튼
                          _isLoading
                              ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppStyles.primaryColor),
                          )
                              : MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _isLoading = true;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  gradient: AppStyles.buttonGradient,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    AppStyles.neonGlowShadow,
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.login,
                                    color: AppStyles.textLight,
                                    shadows: [
                                      Shadow(
                                        color: AppStyles.accentGlow,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  label: Text(
                                    'Google로 로그인',
                                    style: AppStyles.buttonText,
                                  ),
                                  style: AppStyles.googleButtonStyle.copyWith(
                                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                    overlayColor: MaterialStateProperty.all(AppStyles.neonGlow.withOpacity(0.2)),
                                  ),
                                  onPressed: () async {
                                    await ref.read(authServiceProvider.notifier).signInWithGoogle(context);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                ),
                              ),
                            ),
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

// 반짝이는 별 효과를 위한 CustomPainter
class SparkleBackgroundPainter extends CustomPainter {
  final double animationValue;

  SparkleBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint();

    // 별 50개 생성
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;
      final opacity = (animationValue * random.nextDouble()).clamp(0.3, 1.0);

      paint.color = AppStyles.sparkleColors[random.nextInt(AppStyles.sparkleColors.length)]
          .withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SparkleBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}