import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '245171599369-i2mrkqifs6c85bf60s9j5b0eq8dkblp1.apps.googleusercontent.com',
  );

  // Helper to save user to Firestore
  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  // Returns UserModel if successful, throws exception if domain is invalid or auth fails
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String originSection,
  }) async {
    email = email.trim().toLowerCase();
    String role;

    if (originSection == 'student') {
      if (!email.endsWith('@alustudent.com')) {
        throw Exception('Only @alustudent.com emails are allowed for students.');
      }
      role = 'student';
    } else if (originSection == 'employer') {
      if (email.endsWith('@alustudent.com')) {
        role = 'startup';
      } else if (email.endsWith('@alueducation.com')) {
        role = 'staff';
      } else {
        throw Exception('Only @alustudent.com or @alueducation.com emails are allowed for employers.');
      }
    } else {
      throw Exception('Invalid origin section.');
    }

    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserModel(
      uid: userCredential.user!.uid,
      fullName: fullName,
      email: email,
      role: role,
      createdAt: DateTime.now(),
    );

    await _saveUserToFirestore(user);
    return user;
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Returns UserCredential if successful, or null if the user cancelled the sign-in
  Future<UserCredential?> signInWithGoogle(String originSection) async {
    UserCredential? userCredential;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      authProvider.setCustomParameters({'prompt': 'select_account'});
      
      try {
        userCredential = await _auth.signInWithPopup(authProvider);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'popup-closed-by-user' || e.code == 'cancelled') {
          return null;
        }
        rethrow;
      }
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      userCredential = await _auth.signInWithCredential(credential);
    }

    if (userCredential != null) {
      // Check if user already exists in Firestore
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      if (!userDoc.exists) {
        // Assign role based on origin section (skip domain checks for Google sign-in)
        String role = originSection == 'student' ? 'student' : 'startup';
        
        final user = UserModel(
          uid: userCredential.user!.uid,
          fullName: userCredential.user!.displayName ?? 'Unknown',
          email: userCredential.user!.email ?? '',
          role: role,
          createdAt: DateTime.now(),
        );
        
        await _saveUserToFirestore(user);
      }
    }

    return userCredential;
  }

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> completeSetup(String uid) async {
    await _firestore.collection('users').doc(uid).update({'hasCompletedSetup': true});
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      try {
        await _googleSignIn.disconnect();
      } catch (e) {
        try {
          await _googleSignIn.signOut();
        } catch (_) {}
      }
    }
  }
}
