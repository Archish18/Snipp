import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/ai_suggestion_widget.dart';
import '../widgets/code_history_widget.dart';
import '../services/backend_service.dart';
import '../services/firebase_service.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> with SingleTickerProviderStateMixin {
  late CodeController _codeController;
  String selectedLanguage = 'Python';
  String output = "";
  bool isLoading = false;
  String userId = '';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? "Unknown";

    _codeController = CodeController(
      language: selectedLanguage == "Python" ? python : cpp,
    );

    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
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

    _animController.forward(from: 0);
  }

  void showAISuggestions() async {
    final code = _codeController.text;
    final suggestion = await BackendService.getAISuggestion(code);
    showModalBottomSheet(
      context: context,
      builder: (_) => AISuggestionWidget(suggestion: suggestion),
    );
  }

  void showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: const CodeHistoryWidget(),
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
            icon: const Icon(Icons.history),
            onPressed: showHistory,
          ),
          DropdownButton<String>(
            dropdownColor: Colors.grey[900],
            value: selectedLanguage,
            style: const TextStyle(color: Colors.white),
            items: ['Python', 'C++'].map((lang) {
              return DropdownMenuItem(value: lang, child: Text(lang));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                _codeController.language = selectedLanguage == "Python" ? python : cpp;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("User ID: $userId", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ),
              Expanded(
                child: CodeField(
                  controller: _codeController,
                  textStyle: const TextStyle(fontFamily: 'SourceCodePro', color: Colors.white),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Text(
                    "Output:\n$output",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'Courier',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60), // for FAB spacing
            ],
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "run",
            backgroundColor: Colors.green[700],
            icon: const Icon(Icons.play_arrow),
            label: const Text("Run"),
            onPressed: runCode,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "fix",
            backgroundColor: Colors.orange[700],
            icon: const Icon(Icons.auto_fix_high),
            label: const Text("Fix (AI)"),
            onPressed: showAISuggestions,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
