import 'package:flutter/material.dart';
import 'package:snipp/widgets/output_box.dart';
import 'package:snipp/services/backend_service.dart';
import 'package:snipp/services/ai_service.dart';
import 'package:snipp/widgets/code_editor_widget.dart'; // Make sure this is implemented

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String language = 'python';
  String output = '';
  String aiSuggestion = '';
  String code = '';
  bool isLoading = false;

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void runCode() async {
    setState(() => isLoading = true);
    final result = await BackendService.executeCode(code, language);
    setState(() {
      output = result;
      isLoading = false;
    });
    _fadeController.forward(from: 0);
  }

  void fixErrorsAI() async {
    setState(() => isLoading = true);
    final suggestion = await AIService.analyzeCode(code, language);
    setState(() {
      aiSuggestion = suggestion;
      isLoading = false;
    });
    _fadeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
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
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CodeEditorWidget(
                    language: language,
                    onCodeChanged: (val) => code = val,
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: output.isNotEmpty ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: OutputBox(
                      title: "Output",
                      content: output,
                      glass: true,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: aiSuggestion.isNotEmpty ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: OutputBox(
                      title: "AI Suggestion",
                      content: aiSuggestion,
                      glass: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔄 Custom Loading Spinner
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.greenAccent,
              ),
            ),

          // 🟢 Floating Run & AI Fix Buttons
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  onPressed: runCode,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Run"),
                ),
                const SizedBox(height: 15),
                FloatingActionButton.extended(
                  backgroundColor: Colors.orange,
                  onPressed: fixErrorsAI,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text("AI Fix"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
}
