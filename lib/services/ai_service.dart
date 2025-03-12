import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const baseUrl = "https://snipp-1.onrender.com";

  static Future<String> analyzeCode(String code, String language) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/ai-analyze"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code, 'language': language}),
      );
      return jsonDecode(response.body)['suggestion'] ?? "No suggestions";
    } catch (e) {
      return "AI analysis failed: $e";
    }
  }
}
