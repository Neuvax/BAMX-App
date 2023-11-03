abstract class AuthRepository {
  /// Abstract class for authentication repository

  /// Subscribes to the authentication state change
  Stream<String?> get onAuthStateChanged;

  /// Gets the current user display name
  Stream<String?> get getUserDisplayName;

  /// Gets the current user email
  Stream<String?> get getCurrentUserEmail;

  ///Sign in with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password);

  ///Sign up with Email and Password
  Future<void> signUpWithEmailAndPassword(String name, String email, String password);

  ///Forgot Password
  Future<void> sendPasswordResetEmail(String email);

  ///Send Email Verification
  Future<void> sendEmailVerification();

  /// Signs out
  Future<void> signOut();
}