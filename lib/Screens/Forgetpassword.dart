import 'dart:async';

import 'package:blog_application/components/buttons.dart';
import 'package:blog_application/components/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  TextEditingController _resetpassword = TextEditingController();
  @override
  void dispose() {
    _resetpassword.dispose();
    super.dispose();
  }

  Future passwordreset() async {
    try {} catch (e) {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(188, 12, 188, 156),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 30,
            ),
            child: Text(
              "Enter your Email and We will send you mail to reset your Password.",
              style: GoogleFonts.lato(
                fontSize: 20,
              ),
            ),
          ),
          CustomTextfields(
              controller: _resetpassword,
              hintText: "Enter Mail",
              obscureText: false,
              Icons: null),
          SizedBox(
            height: 10,
          ),
          Buttons(
              text: "Reset",
              color: const Color.fromARGB(188, 12, 188, 156),
              textColor: Colors.white,
              onPressed: () {}),
        ],
      ),
    );
  }
}
