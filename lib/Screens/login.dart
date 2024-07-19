import 'package:blog_application/components/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blog_application/components/blocks.dart';
import 'package:blog_application/services/google_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
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
    String msg = '';

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

        msg = "Login successful for: ${userCredential.user!.email}";
      }
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        animateFrom: AnimateFrom.fromTop,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
        leading: Text(
          msg,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            msg = "No user found for that email.";

            break;
          case 'wrong-password':
            msg = "Wrong password provided for that user.";

            break;
          case 'invalid-email':
            msg = "The email address is not valid.";

            break;
          default:
            msg = 'An error occurred. Please try again later.';
        }
        SmartSnackBars.showTemplatedSnackbar(
          context: context,
          animateFrom: AnimateFrom.fromTop,
          backgroundColor:
              const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
          leading: Text(
            msg,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        );
      });
    } catch (e) {
      msg = 'An unexpected error occurred. Please try again later.';
      setState(() {
        SmartSnackBars.showTemplatedSnackbar(
          context: context,
          animateFrom: AnimateFrom.fromTop,
          backgroundColor:
              const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
          leading: Text(
            msg,
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
    String msg = '';
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'email': userEmail,
      });
      msg = 'User email stored in Firestore: $userEmail';
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
        animateFrom: AnimateFrom.fromTop,
        leading: Text(
          msg,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );
    } catch (e) {
      msg = 'Error storing user email: $e';
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
        animateFrom: AnimateFrom.fromTop,
        leading: Text(
          msg,
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
              Text(
                "Login",
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/resetpassword");
                      },
                      child: Text(
                        "Forgot Password",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 1,
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
                        color: Color.fromARGB(255, 143, 139, 139),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Or',
                        style: TextStyle(
                            color: Color.fromARGB(255, 143, 139, 139)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Color.fromARGB(255, 143, 139, 139),
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
                    ontap: () {
                      GoogleAuth().signInWithGoogle().then((userCredential) {
                        Navigator.pushNamed(context, '/dashboard');
                      }).catchError((error) {
                        // Handle any errors here
                        SmartSnackBars.showTemplatedSnackbar(
                          context: context,
                          backgroundColor:
                              const Color.fromARGB(188, 12, 188, 156)
                                  .withOpacity(1),
                          animateFrom: AnimateFrom.fromTop,
                          leading: Text(
                            error,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        );
                      });
                    },
                    imagepath: 'assets/Google.png',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New User?',
                    style: GoogleFonts.lato(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
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
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:
                      const Color.fromARGB(188, 12, 188, 156).withOpacity(1))),
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
