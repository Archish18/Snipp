import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// ✅ Convert HomeScreen into StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = '';

  // ✅ This is your Cloud Run or Firebase Function call
  Future<void> executeCode(String code, String language) async {
    final response = await http.post(
      Uri.parse('https://YOUR_CLOUD_RUN_URL_HERE/run'), // <-- Replace this!
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': code,
        'language': language,
      }),
    );

    final result = jsonDecode(response.body);
    setState(() {
      _output = result['output'] ?? result['error'] ?? 'No response from server';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Code Editor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "Enter your Python or C++ code here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => executeCode(_codeController.text, 'python'),
                  child: const Text("Run Python"),
                ),
                ElevatedButton(
                  onPressed: () => executeCode(_codeController.text, 'cpp'),
                  child: const Text("Run C++"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Output:", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              child: Text(
                _output,
                style: const TextStyle(color: Colors.greenAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
