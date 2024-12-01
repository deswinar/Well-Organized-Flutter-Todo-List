import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthRepository(this._firebaseAuth);

  // Register user using Firebase and store in Firestore
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        await _storeUserData(user); // Store user data in Firestore
      }

      return user;
    } catch (e) {
      throw Exception("Registration failed: ${e.toString()}");
    }
  }

  // Sign in with Google and store user data in Firestore if new
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore, if not add them
        await _checkAndStoreUserData(user);
      }

      return user;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore
        await _checkAndStoreUserData(user);
      }

      return user;
    } catch (e) {
      throw Exception("Sign-in failed: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Helper function to store user data in Firestore
  Future<void> _storeUserData(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? '',
      'photoURL': user.photoURL ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Check if user data already exists in Firestore and store if it doesn't
  Future<void> _checkAndStoreUserData(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await _storeUserData(user);
    }
  }
}
