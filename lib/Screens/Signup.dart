import 'package:blog_application/components/blocks.dart';
import 'package:blog_application/components/buttons.dart';
import 'package:blog_application/components/custom_textfields.dart';
import 'package:blog_application/services/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _confirmpassword = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance; // Initialize Firebase Auth

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 202, 199, 199),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/Login.jpg'),
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 10),
              CustomTextfields(
                controller: _emailController,
                hintText: "UserMail",
                obscureText: false,
                Icons: Icons.mail,
              ),
              const SizedBox(height: 10),
              CustomTextfields(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true,
                Icons: Icons.lock,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextfields(
                controller: _confirmpassword,
                hintText: "Confirm Password",
                obscureText: true,
                Icons: Icons.lock,
              ),
              const SizedBox(height: 20),
              Buttons(
                text: 'Sign Up',
                color: Colors.black,
                textColor: Colors.white,
                onPressed: () async {
                  // Handle user registration with Firebase Auth
                  try {
                    if (_confirmpassword.text == _passwordController.text) {
                      final credential =
                          await _auth.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (credential.user != null) {}
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      // Show appropriate error message to user
                    } else if (e.code == 'email-already-in-use') {
                      // Show appropriate error message to user
                    }
                  } catch (e) {
                    // Handle other exceptions
                  }
                },
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 52),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Or",
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
                children: [
                  Blocks(
                      ontap: () => GoogleAuth().signInWithGoogle(),
                      imagepath: "assets/Google.png"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have account ?"),
                  InkWell(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 88, 32),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
