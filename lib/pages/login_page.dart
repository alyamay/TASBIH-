import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    final email = emailC.text.trim();
    final pass = passC.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    try {
      setState(() => loading = true);

      // 🔹 Login Firebase Auth
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final uid = credential.user!.uid;

      // 🔹 Ambil data di Firestore
      final snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final userName = snap["name"];

      // 🔹 Simpan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", userName);
      await prefs.setString("email", email);

      // 🔹 Pindah ke home
      Navigator.pushReplacementNamed(context, '/home');
    }
    // ----------------------------------------
    // 🔥 Perbaikan error handling
    // ----------------------------------------
    on FirebaseAuthException catch (e) {
      String message = "Login gagal.";

      switch (e.code) {
        case "wrong-password":
          message = "Password salah.";
          break;
        case "invalid-credential":
        case "user-not-found":
          message = "Email atau password salah.";
          break;
        case "invalid-email":
          message = "Format email tidak valid.";
          break;
        default:
          message = "Login gagal. Silakan coba lagi.";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
    // Error Firebase umum seperti AppCheck, token expired, dsb
    on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Terjadi kesalahan pada server Firebase."),
        ),
      );
    }
    // Error selain Firebase (network, parsing, dll)
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kesalahan tak terduga terjadi.")),
      );
    }
    // ----------------------------------------
    // 🔥 Ini memastikan loading SELALU berhenti
    // ----------------------------------------
    finally {
      setState(() => loading = false);
    }
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
                  "Login",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4FB7B3),
                    fontSize: w * 0.08,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: h * 0.05),

                // EMAIL
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
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
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0x198789A3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: emailC,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your email",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // PASSWORD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
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
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0x198789A3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: passC,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your password",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.08),

                // BUTTON LOGIN
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
                    onPressed: loading ? null : login,
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Color(0xFF4FB7B3),
                          )
                        : Text(
                            "Login",
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
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    "First Time Here?",
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
}
