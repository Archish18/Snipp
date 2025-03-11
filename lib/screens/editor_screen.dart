import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/languages/python.dart';
import 'package:flutter_highlight/languages/cpp.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/ai_suggestion_widget.dart';
import '../widgets/code_history_widget.dart'; // ✅ Import your history widget
import '../services/backend_service.dart';
import '../services/firebase_service.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late CodeController _codeController;
  String selectedLanguage = 'Python';
  String output = "";
  bool isLoading = false;
  String userId = '';
  
  get python => null;
  
  get cpp => null;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? "Unknown";

    _codeController = CodeController(
      language: selectedLanguage == "Python" ? python : cpp,
    );
  }

  void runCode() async {
    setState(() => isLoading = true);

    final code = _codeController.text;
    final result = await BackendService.executeCode(code, selectedLanguage);

    FirebaseService.saveCodeHistory(code, result, selectedLanguage);

    setState(() {
      output = result;
      isLoading = false;
    });
  }

  void showAISuggestions() async {
    final code = _codeController.text;
    final suggestion = await BackendService.getAISuggestion(code);
    showModalBottomSheet(
      context: context,
      builder: (_) => AISuggestionWidget(suggestion: suggestion),
    );
  }

  void showCodeHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: const CodeHistoryWidget(), // ✅ This widget should be implemented
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Snipp Code Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: "Code History",
            onPressed: showCodeHistory,
          ),
          DropdownButton<String>(
            dropdownColor: Colors.grey[900],
            value: selectedLanguage,
            style: const TextStyle(color: Colors.white),
            items: ['Python', 'C++'].map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Text(lang),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                _codeController.language = selectedLanguage == "Python" ? python : cpp;
              });
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "User ID: $userId",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: CodeField(
              controller: _codeController,
              textStyle: const TextStyle(fontFamily: 'SourceCodePro', color: Colors.white),
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: Colors.black,
            child: Text(
              "Output:\n$output",
              style: const TextStyle(color: Colors.greenAccent, fontFamily: 'Courier'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: runCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Run"),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: showAISuggestions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text("Fix Errors (AI)"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
