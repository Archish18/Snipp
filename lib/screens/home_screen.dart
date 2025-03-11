import 'package:flutter/material.dart';
import 'package:snipp/widgets/ai_suggestion_widget.dart';
import '../widgets/ai_suggestion_widget.dart';
import '../widgets/output_box.dart';
import '../services/backend_service.dart';
import '../services/ai_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String language = 'python';
  String output = '';
  String aiSuggestion = '';
  String code = '';

  void runCode() async {
    final result = await BackendService.executeCode(code, language);
    setState(() => output = result);
  }

  void fixErrorsAI() async {
    final suggestion = await AIService.analyzeCode(code, language);
    setState(() => aiSuggestion = suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Snipp Code Editor"),
        actions: [
          DropdownButton<String>(
            value: language,
            dropdownColor: Colors.black,
            underline: Container(),
            items: ['python', 'cpp']
                .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                .toList(),
            onChanged: (value) => setState(() => language = value!),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CodeEditorWidget(
              onCodeChanged: (val) => code = val,
              language: language,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: runCode, child: const Text("Run Code")),
                ElevatedButton(onPressed: fixErrorsAI, child: const Text("AI Fix")),
              ],
            ),
            OutputBox(title: "Output", content: output),
            OutputBox(title: "AI Suggestion", content: aiSuggestion),
          ],
        ),
      ),
    );
  }
}
