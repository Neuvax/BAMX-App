import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImp extends AuthRepository {
  /// `AuthRepositoryImp` class extends `AuthRepository`.
  /// It uses Firebase for authentication.
 
  /// Instance of Firebase authentication.
  final _firebaseAuth = FirebaseAuth.instance;

  /// Returns a Stream of Strings representing the authentication state changes.
  /// Each emitted event is the user's UID, or null if the user is not signed in.
  @override
  Stream<String?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().asyncMap((user) => user?.uid);
  }

  /// Returns the current user.
  @override
  Stream<String?> get getUserDisplayName {
    return _firebaseAuth.authStateChanges().asyncMap((user) => user?.displayName);
  }

  /// Returns the current user email.
  @override
  Stream<String?> get getCurrentUserEmail {
    return _firebaseAuth.authStateChanges().asyncMap((user) => user?.email);
  }

  /// Returns the current user profile picture.
  @override
  Stream<String?> get getCurrentUserProfilePicture {
    return _firebaseAuth.authStateChanges().asyncMap((user) => user?.photoURL);
  }

  /// Deletes the current user.
  @override
  Future<void> deleteUser() async {
    await _firebaseAuth.currentUser?.delete();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmailAndPassword(String name, String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await _firebaseAuth.currentUser?.updateDisplayName(name);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  /// Signs out the current user from Firebase.
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}