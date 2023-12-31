import 'dart:io';

abstract class AuthRepository {
  /// Abstract class for authentication repository

  /// Subscribes to the authentication state change
  Stream<String?> get onAuthStateChanged;

  /// Gets the current user display name
  Stream<String?> get getUserDisplayName;

  /// Gets the current user email
  Stream<String?> get getCurrentUserEmail;

  /// Gets the current user profile picture
  Stream<String?> get getCurrentUserProfilePicture;

  /// Gets the current user UID
  String? get getCurrentUserUID;

  ///Update display name
  Future<void> updateDisplayName(String name);

  ///Update profile picture
  Future<void> updateProfilePicture(String url);

  ///Push image to firebase storage
  Future<String> pushImageToFirebaseStorage(
      String uid, String path, File image);

  /// Deletes the current user
  Future<void> deleteUser();

  ///Sign in with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password);

  ///Sign up with Email and Password
  Future<void> signUpWithEmailAndPassword(
      String name, String email, String password);

  ///Forgot Password
  Future<void> sendPasswordResetEmail(String email);

  ///Send Email Verification
  Future<void> sendEmailVerification();

  /// Signs out
  Future<void> signOut();

  /// Check if user is admin
  Future<bool> getIsAdmin();
  
  Future<void> enrollSecondFactor(
      String phoneNumber, Function(String, int?) codeSentCallback);

  Future<void> completeSecondFactorEnrollment(
      String verificationId, String smsCode);
}

