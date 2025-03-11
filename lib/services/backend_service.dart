import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'https://your-render-backend-url.com'; // Replace with your Render backend

  static Future<String> executeCode(String code, String language) async {
    final response = await http.post(
      Uri.parse('$baseUrl/execute'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code, 'language': language}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['output'] ?? "No output";
    } else {
      return "Error executing code: ${response.body}";
    }
  }

  static Future<String> getAISuggestion(String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai-fix'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['suggestion'] ?? "No suggestion found";
    } else {
      return "AI Error Fixing Failed: ${response.body}";
    }
  }
}
