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

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  /// Signs out the current user from Firebase.
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}