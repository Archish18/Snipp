import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/highlight.dart'; 

class CodeEditorWidget extends StatefulWidget {
  final String language;
  final Function(String) onCodeChanged;

  const CodeEditorWidget({
    Key? key,
    required this.language,
    required this.onCodeChanged,
  }) : super(key: key);

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: '',
      language: _getLanguage(widget.language),
    );

    _codeController.addListener(() {
      widget.onCodeChanged(_codeController.text);
    });
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language) {
      setState(() {
        _codeController.language = _getLanguage(widget.language);
      });
    }
  }

  Mode _getLanguage(String lang) {
    switch (lang.toLowerCase()) {
      case 'cpp':
        return cpp;
      case 'python':
      default:
        return python;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: CodeField(
        controller: _codeController,
        textStyle: const TextStyle(
          fontFamily: 'SourceCodePro',
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
