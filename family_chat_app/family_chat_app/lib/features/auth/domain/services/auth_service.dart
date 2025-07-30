import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        await _createUserDocument(
          credential.user!,
          firstName: firstName,
          lastName: lastName,
        );

        // Update display name
        await credential.user!.updateDisplayName('$firstName $lastName');
      }

      return credential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last seen
      if (credential.user != null) {
        await _updateLastSeen(credential.user!.uid);
      }

      return credential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Update last seen before signing out
      if (currentUser != null) {
        await _updateLastSeen(currentUser!.uid);
      }
      await _auth.signOut();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Get user data stream
  Stream<UserModel?> getUserDataStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }

  // Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(
    User user, {
    required String firstName,
    required String lastName,
  }) async {
    final userModel = UserModel(
      id: user.uid,
      email: user.email!,
      firstName: firstName,
      lastName: lastName,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toJson());
  }

  // Update last seen timestamp
  Future<void> _updateLastSeen(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silently fail for last seen updates
    }
  }

  // Handle authentication exceptions
  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('No user found with this email address.');
        case 'wrong-password':
          return Exception('Wrong password provided.');
        case 'email-already-in-use':
          return Exception('An account already exists with this email.');
        case 'weak-password':
          return Exception('The password provided is too weak.');
        case 'invalid-email':
          return Exception('The email address is not valid.');
        case 'user-disabled':
          return Exception('This user account has been disabled.');
        case 'too-many-requests':
          return Exception('Too many requests. Try again later.');
        default:
          return Exception('Authentication failed: ${e.message}');
      }
    }
    return Exception('Authentication failed: $e');
  }
}

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
