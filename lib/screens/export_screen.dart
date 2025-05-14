import 'package:flutter/material.dart';
import '../services/export_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_glow_button.dart';

class ExportScreen extends StatelessWidget {
  final String storyId;
  final String storyContent;

  const ExportScreen({
    super.key,
    required this.storyId,
    required this.storyContent,
  });

  @override
  Widget build(BuildContext context) {
    final exportService = ExportService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('스토리 내보내기'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTheme.headline.copyWith(fontSize: 28),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeonGlowButton(
                text: 'PDF로 내보내기',
                onPressed: () async {
                  await exportService.exportAsPDF(storyContent);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF로 내보내기 완료')),
                  );
                },
              ),
              const SizedBox(height: 16),
              NeonGlowButton(
                text: '텍스트로 내보내기',
                onPressed: () async {
                  await exportService.exportAsText(storyContent);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('텍스트로 내보내기 완료')),
                  );
                },
              ),
              const SizedBox(height: 16),
              NeonGlowButton(
                text: '공유 링크 생성',
                onPressed: () async {
                  final link = await exportService.generateShareableLink(storyId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('공유 링크: $link')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}