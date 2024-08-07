import 'package:blog_application/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String msg = '';

  void _signUp() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();
    String msg = '';
    if (password != confirmPassword) {
      msg = 'Passwords do not match.';
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

      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      if (userCredential.user != null) {
        msg = 'email sent to $email.';
        SmartSnackBars.showTemplatedSnackbar(
          context: context,
          animateFrom: AnimateFrom.fromTop,
          backgroundColor:
              const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
          trailing: Text(
            msg,
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
          case 'weak-password':
            msg = 'The password provided is too weak.';

            break;
          case 'email-already-in-use':
            msg = "The account already exists for that email.";

            break;
          case 'invalid-email':
            msg = 'The email address is not valid.';

            break;
          default:
            msg = 'An error occurred. Please try again later.';
        }
      });
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
        animateFrom: AnimateFrom.fromTop,
        trailing: Text(
          msg,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        msg = 'An unexpected error occurred. Please try again later.';
      });
      SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: const Color.fromARGB(188, 12, 188, 156).withOpacity(1),
        animateFrom: AnimateFrom.fromTop,
        trailing: Expanded(
          child: Text(
            overflow: TextOverflow.clip,
            msg,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      );
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
                "SignUp",
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
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Buttons(
                onPressed: _signUp,
                textColor: Colors.white,
                color: Colors.black,
                text: "SignUp",
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.lato(),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Login',
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
    if (msg.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        msg,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
