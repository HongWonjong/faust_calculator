import 'package:flutter/material.dart';
import '../services/export_service.dart';

class ExportScreen extends StatelessWidget {
  final String storyId;
  final String storyContent;

  ExportScreen({required this.storyId, required this.storyContent});

  @override
  Widget build(BuildContext context) {
    final exportService = ExportService();
    return Scaffold(
      appBar: AppBar(title: Text('스토리 내보내기')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await exportService.exportAsPDF(storyContent);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF로 내보내기 완료')),
                );
              },
              child: Text('PDF로 내보내기'),
            ),
            ElevatedButton(
              onPressed: () async {
                await exportService.exportAsText(storyContent);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('텍스트로 내보내기 완료')),
                );
              },
              child: Text('텍스트로 내보내기'),
            ),
            ElevatedButton(
              onPressed: () async {
                final link = await exportService.generateShareableLink(storyId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('공유 링크: $link')),
                );
              },
              child: Text('공유 링크 생성'),
            ),
          ],
        ),
      ),
    );
  }
}