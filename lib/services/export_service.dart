import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  Future<void> exportAsPDF(String story) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text(story),
      ),
    ));
    // 실제로는 파일 저장 또는 다운로드 로직 필요
    // 예: File('story.pdf').writeAsBytes(await pdf.save());
  }

  Future<void> exportAsText(String story) async {
    // 실제로는 파일 저장 또는 다운로드 로직 필요
    // 예: File('story.txt').writeAsString(story);
  }

  Future<String> generateShareableLink(String storyId) async {
    return 'https://faust-calculator.com/story/$storyId';
  }
}