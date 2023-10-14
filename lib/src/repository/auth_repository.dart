abstract class AuthRepository {
  /// Abstract class for authentication repository

  Stream<String?> get onAuthStateChanged;
  Future<void> signOut();
}