abstract class AuthRepository {
  /// Abstract class for authentication repository

  /// Subscribes to the authentication state change
  Stream<String?> get onAuthStateChanged;

  ///Sign in with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password);

  /// Signs out
  Future<void> signOut();
}