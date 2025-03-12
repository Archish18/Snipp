import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/editor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization for Web and other platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC-rr2MHXm79CUSdfYJvOu7vbq_ez89KqI",
        authDomain: "snipp-code.firebaseapp.com",
        projectId: "snipp-code",
        storageBucket: "snipp-code.firebasestorage.app",
        messagingSenderId: "953183690774",
        appId: "1:953183690774:web:2c8cb165be811897755537",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Sign in anonymously
  await FirebaseAuth.instance.signInAnonymously();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snipp Code Editor',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const EditorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
