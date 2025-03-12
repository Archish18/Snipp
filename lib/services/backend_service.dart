import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const baseUrl = "https://snipp-1.onrender.com";

  static Future<String> executeCode(String code, String language) async {
    // Normalize language to lowercase
    final lang = language.toLowerCase() == 'c++' ? 'cpp' : 'python';

    try {
      final endpoint = '/execute/$lang';
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
    // Normalize language here too
    final lang = language.toLowerCase() == 'c++' ? 'cpp' : 'python';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/suggestion'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code, 'language': lang}),
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
