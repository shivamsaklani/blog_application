import 'dart:async';

import 'package:blog_application/components/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  TextEditingController _resetpassword = TextEditingController();

  String msg = '';
  @override
  void dispose() {
    _resetpassword.dispose();
    super.dispose();
  }

  Future passwordreset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _resetpassword.text.trim());
      msg = 'Mail sent Successfully';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        msg = 'The email address you entered is not registered.';
      } else if (e.code == 'invalid-email') {
        msg = 'Please enter a valid email address.';
      } else {
        msg = 'An unexpected error occurred. Please try again later.';
      }
    } catch (e) {
      // Handle other non-Firebase exceptions (e.g., network errors)
      msg = 'An error occurred. Please try again later.';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Align(
          alignment: AlignmentDirectional(0, -1),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: 570,
            ),
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // This row exists for when the "app bar" is hidden on desktop, having a way back for the user can work well.

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                  child: Text(
                    'Forgot Password',
                    style: GoogleFonts.jua(
                      color: Color(0xFF15161E),
                      fontSize: 24,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
                  child: Text(
                    'We will send you an email with a link to reset your password, please enter the email associated with your account below.',
                    style: GoogleFonts.jua(
                      color: Color(0xFF606A85),
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _resetpassword,
                      autofillHints: [AutofillHints.email],
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Your email address...',
                        labelStyle: GoogleFonts.jua(
                          color: Color(0xFF606A85),
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Enter your email...',
                        hintStyle: GoogleFonts.jua(
                          color: Color(0xFF606A85),
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF6F61EF),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF5963),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFFF5963),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      ),
                      style: GoogleFonts.jua(
                        color: Color(0xFF15161E),
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Color(0xFF6F61EF),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
                    child: Buttons(
                      color: const Color.fromARGB(188, 12, 188, 156),
                      textColor: Colors.white,
                      onPressed: () async {
                        passwordreset();
                      },
                      text: 'Send Link',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (msg == 'Mail sent Successfully') {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "mail sent",
          style: TextStyle(color: Color.fromARGB(255, 23, 125, 7)),
        ),
      );
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
