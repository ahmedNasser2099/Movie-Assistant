import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      return user;
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<String?> getCurrentUserId() async {
    User? user = _auth.currentUser;
    return user?.uid;
  }
}
