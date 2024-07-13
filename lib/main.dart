import 'package:blog_application/Screens/Profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blog_application/Screens/ResetPassword.dart';
import 'package:blog_application/Screens/Signup.dart';
import 'package:blog_application/Screens/dashboard.dart';
import 'package:blog_application/Screens/login.dart';
import 'package:blog_application/Screens/publish_Blog.dart';
import 'package:blog_application/Screens/splash.dart';
import 'package:blog_application/pages/auth_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StartUpScreen());
}

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/checkuser': (context) => const AuthPage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/publishblog': (context) => const PublishBlog(),
        '/profile': (context) => const ProfileScreen(),
        '/resetpassword': (context) => const Resetpassword(),
      },
    );
  }
}
