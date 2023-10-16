abstract class AuthRepository {
  /// Abstract class for authentication repository

  /// Subscribes to the authentication state change
  Stream<String?> get onAuthStateChanged;

  /// Signs out
  Future<void> signOut();
}