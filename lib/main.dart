
import 'package:blog_application/Screens/Forgetpassword.dart';
import 'package:blog_application/Screens/Signup.dart';
import 'package:blog_application/Screens/dashboard.dart';
import 'package:blog_application/Screens/login.dart';
import 'package:blog_application/Screens/publish_Blog.dart';
import 'package:blog_application/Screens/splash.dart';
import 'package:blog_application/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const startupscreen());
}

class startupscreen extends StatefulWidget {
  const startupscreen({super.key});

  @override
  State<startupscreen> createState() => _startupscreenState();
}

class _startupscreenState extends State<startupscreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 255, 255, 255),
      )),
      routes: {
        "/": (context) => const Splash(),
        "/checkuser": (context) => const AuthPage(),
        "/login": (context) => const LoginScreen(),
        "/Signup": (context) => const SignupScreen(),
        "/dashboard": (context) => const Dashboard(),
        "/publishblog": (context) => const PublishBlog(),
        "/Forgetpassword": (context) => const Forgetpassword(),
      },
    );
  }
}
