import 'dart:async';

import 'package:flutter/material.dart';

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
    var dur = const Duration(seconds: 1);
    return Timer(dur, route);
  }

  route() {
    Navigator.of(context).pushReplacementNamed('/checkuser');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(250, 185, 203, 200),
      child: Column(children: [
        Image.asset("assets/startup.jpg"),
        const SizedBox(
          height: 80,
        ),
        const Text(
          "Welcome To Blog App",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Create, Publish your Thoughts into Blogs",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              decoration: TextDecoration.none),
        )
      ]),
    );
  }
}
