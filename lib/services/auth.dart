import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:momandkid/services/database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

abstract class AuthService {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String name, String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future resetPassword(String email);

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<String> loginWithFacebook();

  Future<String> signInWithGoogle();
}

class Auth implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String name, String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    // create user info in firestore
    await Database(userId: user.uid).createUserInfo(name, email, 'image path');

    return user.uid;
  }

  Future resetPassword(String email) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return e.toString();
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();

    print("User Sign Out");

    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // check new user
    dynamic info;
    await Database(userId: user.uid).getUserData().then((val) {
      info = val.data;
    });

    print('info: $info');

    if (info == null) {
      String name = user.displayName;
      String email = user.email;
      String imageUrl = user.photoUrl;

      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      await Database(userId: user.uid).createUserInfo(name, email, imageUrl);
    }

    print('Login with google');
    return user.uid;
  }

  Future<String> loginWithFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult result =
        await facebookLogin.logIn(['email', "public_profile"]);
    print(result);
    if(result.accessToken != null){
      String token = result.accessToken.token;
    await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(accessToken: token));

    FirebaseUser user = await _firebaseAuth.currentUser();

    dynamic info;
    await Database(userId: user.uid)
        .getUserData()
        .then((onValue) => info = onValue.data);

    print(info);
    if (info == null) {
      await Database(userId: user.uid).createUserInfo(
          user.displayName.split(' ')[0], user.email, user.photoUrl);
    }

    print('Login with Facebook');
    return user.uid;
    }
    return null;
  }
}
