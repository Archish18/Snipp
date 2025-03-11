// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/languages/python.dart';
import 'package:flutter_highlight/languages/cpp.dart';

class CodeEditor extends StatefulWidget {
  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late CodeController _codeController;
  String language = "python";
  
  get python => null;
  
  get cpp => null; // Default language

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: '',
      language: language == "python" ? python : cpp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: language,
          items: ["python", "cpp"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.toUpperCase()),
            );
          }).toList(),
          onChanged: (newLang) {
            setState(() {
              language = newLang!;
              _codeController = CodeController(
                text: '',
                language: language == "python" ? python : cpp,
              );
            });
          },
        ),
        Expanded(
          child: CodeField(
            controller: _codeController,
            textStyle: TextStyle(fontSize: 16),
            theme: monokaiTheme,
          ),
        ),
        ElevatedButton(
          onPressed: () => executeCode(_codeController.text, language),
          child: const Text("Run Code"),
        ),
      ],
    );
  }
  
  executeCode(String text, String language) {}
}
