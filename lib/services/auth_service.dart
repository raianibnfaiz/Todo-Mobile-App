import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Stream of user changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Current user
  User? get currentUser => _auth.currentUser;
  
  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;
  
  // Convert Firebase user to our UserModel
  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }
  
  // Get current user model
  UserModel? get currentUserModel => _userFromFirebase(currentUser);
  
  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;
      
      // Get authentication details from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create credential for Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      notifyListeners();
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
} 