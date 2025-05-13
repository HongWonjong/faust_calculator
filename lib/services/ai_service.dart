import 'package:http/http.dart' as http;
import 'dart:convert';

class AIService {
  final String apiUrl = 'https://api.xai.com/generate'; // 가정된 API URL

  Future<String> generateStory(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['story'];
      } else {
        throw Exception('Failed to generate story');
      }
    } catch (e) {
      return 'AI 생성 실패: $e';
    }
  }

  Future<double> analyzePlausibility(
      String story, Map<String, dynamic> data) async {
    // 가정된 API 호출
    return 0.85; // 임시 값
  }
}