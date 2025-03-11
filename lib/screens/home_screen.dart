import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/backend_service.dart';
import '../services/ai_service.dart';
import '../widgets/output_box.dart';
import '../widgets/ai_suggestion_widget.dart';
import '../widgets/code_editor_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String language = 'python';
  String output = '';
  String aiSuggestion = '';
  String code = '';
  bool isLoading = false;

  void runCode() async {
    setState(() => isLoading = true);
    final result = await BackendService.executeCode(code, language);
    setState(() {
      output = result;
      isLoading = false;
    });
  }

  void fixErrorsAI() async {
    setState(() => isLoading = true);
    final suggestion = await AIService.analyzeCode(code, language);
    setState(() {
      aiSuggestion = suggestion;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Snipp Code Editor"),
        actions: [
          DropdownButton<String>(
            value: language,
            dropdownColor: Colors.black,
            underline: Container(),
            style: const TextStyle(color: Colors.white),
            items: ['python', 'cpp']
                .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                .toList(),
            onChanged: (value) => setState(() => language = value!),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
            child: Column(
              children: [
                CodeEditorWidget(
                  onCodeChanged: (val) => code = val,
                  language: language,
                ),
                const SizedBox(height: 10),
                GlassBox(title: "Output", content: output),
                const SizedBox(height: 10),
                GlassBox(title: "AI Suggestion", content: aiSuggestion),
              ],
            ),
          ),

          // Loading Overlay
          if (isLoading)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const CircularProgressIndicator(color: Colors.greenAccent),
              ),
            ),
        ],
      ),

      // Floating Action Buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.greenAccent,
            onPressed: runCode,
            icon: const Icon(Icons.play_arrow),
            label: const Text("Run"),
          ),
          const SizedBox(height: 15),
          FloatingActionButton.extended(
            backgroundColor: Colors.orangeAccent,
            onPressed: fixErrorsAI,
            icon: const Icon(Icons.auto_fix_high),
            label: const Text("AI Fix"),
          ),
        ],
      ),
    );
  }
}

// Glassmorphism-style Output Box
class GlassBox extends StatelessWidget {
  final String title;
  final String content;

  const GlassBox({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(content,
                  style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'SourceCodePro',
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
