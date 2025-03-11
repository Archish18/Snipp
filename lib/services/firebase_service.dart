import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> saveCodeHistory(String code, String result, String language) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final historyData = {
      'code': code,
      'result': result,
      'language': language,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('code_history')
        .add(historyData);
  }
}
