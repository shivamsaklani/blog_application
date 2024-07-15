import 'package:blog_application/components/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blog_application/components/blocks.dart';
import 'package:blog_application/services/google_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_snackbars/smart_snackbars.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _errorMessage = '';

  void _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to another screen or show success message
      if (userCredential.user != null) {
        await _storeUserEmail(userCredential.user!.email!);
        // Example: Navigator.pushNamed(context, '/home');
        Navigator.pushNamed(context, '/dashboard');

        SmartSnackBars.showTemplatedSnackbar(
          context: context,
          backgroundColor: const Color.fromARGB(188, 12, 188, 156),
          leading: Text(
            "Login successful for: ${userCredential.user!.email}",
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            SmartSnackBars.showTemplatedSnackbar(
              context: context,
              backgroundColor: const Color.fromARGB(188, 12, 188, 156),
              leading: Text(
                "No user found for that email.",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            );

            break;
          case 'wrong-password':
            SmartSnackBars.showTemplatedSnackbar(
              context: context,
              backgroundColor: const Color.fromARGB(188, 12, 188, 156),
              leading: Text(
                "Wrong password provided for that user.",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            );

            break;
          case 'invalid-email':
            SmartSnackBars.showTemplatedSnackbar(
              context: context,
              backgroundColor: const Color.fromARGB(188, 12, 188, 156),
              leading: Text(
                "The email address is not valid.",
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            );
            break;
          default:
            SmartSnackBars.showTemplatedSnackbar(
              context: context,
              backgroundColor: const Color.fromARGB(188, 12, 188, 156),
              leading: Text(
                'An error occurred. Please try again later.',
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            );
        }
      });
    } catch (e) {
      setState(() {
        SmartSnackBars.showTemplatedSnackbar(
          context: context,
          backgroundColor: const Color.fromARGB(188, 12, 188, 156),
          leading: Text(
            'An unexpected error occurred. Please try again later.',
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        );
      });
    }
  }

  Future<void> _storeUserEmail(String userEmail) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'email': userEmail,
      });
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156),
        leading: Text(
          'User email stored in Firestore: $userEmail',
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );
    } catch (e) {
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156),
        leading: Text(
          'Error storing user email: $e',
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );

      // Handle Firestore errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 202, 199, 199),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Image(
                image: AssetImage('assets/Login.jpg'),
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),
              _buildErrorMessage(),
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.mail,
              ),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/resetpassword");
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Buttons(
                onPressed: _login,
                textColor: Colors.white,
                color: Colors.black,
                text: "Login",
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 52),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Blocks(
                    ontap: () => GoogleAuth().signInWithGoogle().then((_) {
                      Navigator.pushNamed(context, '/dashboard');
                    }),
                    imagepath: 'assets/Google.png',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('New User?'),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 88, 32),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _errorMessage,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
