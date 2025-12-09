import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static final picker = ImagePicker();

  // -----------------------------
  // UPDATE NAME
  // -----------------------------
  static Future<void> updateName(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "name": newName,
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("username", newName);
  }
}
