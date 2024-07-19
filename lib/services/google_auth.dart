import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  Future<UserCredential> signInWithGoogle() async {
    // Sign out any currently signed-in user
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();

    // Begin interactive sign-in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      // The user canceled the sign-in process
      throw Exception('Sign-in process was canceled.');
    }

    // Obtain user details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // Create a new credential for the user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in with the credential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if the user is new and perform additional setup if needed
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {}

    return userCredential;
  }
}
