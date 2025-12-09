import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    // Validasi dasar
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showMsg("Semua field harus diisi");
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // 2. Simpan profil user ke Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "created_at": DateTime.now(),
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", name);
      await prefs.setString("email", email);

      showMsg("Registrasi berhasil!");

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      showMsg(e.message ?? "Gagal mendaftar");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final w = screen.width;
    final h = screen.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Register",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4FB7B3),
                    fontSize: w * 0.08,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: h * 0.05),

                // NAME
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Name",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4FB7B3),
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                field(nameC, "Enter your name"),

                const SizedBox(height: 25),

                // USERNAME
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4FB7B3),
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                field(emailC, "Enter your email"),

                const SizedBox(height: 25),

                // PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4FB7B3),
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                field(passwordC, "Create a password", obscure: true),

                SizedBox(height: h * 0.05),

                SizedBox(
                  width: w * 0.5,
                  height: 60,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF4FB7B3),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: isLoading ? null : register,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            "Register",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF4FB7B3),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    "Already Have an Account?",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF230E4E),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget field(TextEditingController c, String hint, {bool obscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0x198789A3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
