import 'package:blog_application/components/blocks.dart';
import 'package:blog_application/components/buttons.dart';
import 'package:blog_application/components/custom_textfields.dart';
import 'package:blog_application/services/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Handle login button click
  _loginButton() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      // Navigate to home page or display success message
      if (userCredential.user != null) {
        // Replace with your navigation logic
        Navigator.pushNamed(context, '/dashboard'); // Assuming a home route
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Display error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        // Display error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
          ),
        );
      }
    } catch (e) {}
  }

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
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextfields(
                        hintText: "UserMail",
                        obscureText: false,
                        Icons: Icons.mail,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 10),
                      CustomTextfields(
                        hintText: "Password",
                        obscureText: true,
                        Icons: Icons.lock,
                        controller: _passwordController,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/Forgetpassword");
                              },
                              child: const Text(
                                "forget password?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Buttons(
                        text: "SignIn",
                        color: Colors.black,
                        textColor: Colors.white,
                        onPressed: () {
                          // Check if _formKey is initialized and has a current state
                          if (_formKey.currentState != null) {
                            if (_formKey.currentState!.validate()) {
                              _loginButton();
                            }
                          } else {
                            // Handle the error gracefully
                          }
                        },
                      ),
                    ],
                  )),
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
                    imagepath: "assets/Google.png",
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New User?"),
                  InkWell(
                    onTap: () => {
                      Navigator.pushNamed(context, '/Signup'),
                    },
                    child: const Text(
                      "Signup",
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
