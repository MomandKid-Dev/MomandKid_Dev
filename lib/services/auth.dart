import 'package:firebase_auth/firebase_auth.dart';
import 'package:momandkid/services/database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

abstract class AuthService {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String name, String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
  Future loginWithFacebook();
}

class Auth implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  Future loginWithFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin
        .logIn(['email', "public_profile"]);
 
    String token = result.accessToken.token;
    print("Access token = $token");
    await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(accessToken: token));
    // checkAuth(context); // after success, navigate to home.
    FirebaseUser user = await _firebaseAuth.currentUser();
    dynamic info;
    await Database(userId: user.uid).getUserData().then((onValue) => info = onValue.data);
    print(info);
    if(info == null){
      await Database(userId: user.uid).createUserInfo(user.displayName.split(' ')[0], user.email, 'image path');
    }
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
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
}
