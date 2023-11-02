abstract class AuthRepository {
  /// Abstract class for authentication repository

  /// Subscribes to the authentication state change
  Stream<String?> get onAuthStateChanged;

  ///Sign in with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password);

  ///Sign up with Email and Password
  Future<void> signUpWithEmailAndPassword(String name, String email, String password);

  ///Forgot Password
  Future<void> sendPasswordResetEmail(String email);

  /// Signs out
  Future<void> signOut();
}