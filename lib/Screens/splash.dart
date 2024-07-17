import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    start_timer();
    super.initState();
  }

  start_timer() {
    var dur = const Duration(seconds: 3);
    return Timer(dur, route);
  }

  route() {
    Navigator.of(context).pushReplacementNamed('/checkuser');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(248, 115, 122, 120),
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image(
                image: AssetImage('assets/startup.jpg'),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Text(
              "Welcome To Blog App",
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Create, Publish your Thoughts into Blogs",
              style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 249, 243, 243),
                  fontSize: 18,
                  decoration: TextDecoration.none),
            )
          ]),
        ),
      ),
    );
  }
}