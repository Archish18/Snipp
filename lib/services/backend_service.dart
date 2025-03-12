import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'https://snipp-1.onrender.com'; // 🔁 Replace this with your Render URL

  // Run Code (Python / C++)
  static Future<String> executeCode(String code, String language) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/execute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'language': language,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['output'] ?? 'No output returned.';
      } else {
        return 'Server error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      return '❌ Error connecting to backend: $e';
    }
  }

  // AI Suggestion / Fix Errors
  static Future<String> getAISuggestion(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai-suggestion'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['suggestion'] ?? 'No suggestion returned.';
      } else {
        return 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      return '❌ Error connecting to backend: $e';
    }
  }
}
