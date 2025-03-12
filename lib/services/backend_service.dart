import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const baseUrl = "https://snipp-1.onrender.com"; // ✅ your backend URL

  static Future<String> executeCode(String code, String language) async {
    try {
      final endpoint = language == 'cpp' ? '/execute/cpp' : '/execute/python';
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['output'] ?? "No output";
      } else {
        return "Error: ${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Code execution failed: $e";
    }
  }

  static Future<String> getAISuggestion(String code, String language) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/suggestion'), // ✅ correct AI endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code, 'language': language}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['suggestion'] ?? "No suggestion found";
      } else {
        return "AI Suggestion failed: ${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      return "AI Suggestion failed: $e";
    }
  }
}
