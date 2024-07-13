import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Google Sign In
class GoogleAuth {
  signInWithGoogle() async {
    //begin interactive sign in process
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
    //obtain user details from request
    final GoogleSignInAuthentication gauth = await guser!.authentication;
    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gauth.accessToken,
      idToken: gauth.idToken,
    );
    //finally, sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
