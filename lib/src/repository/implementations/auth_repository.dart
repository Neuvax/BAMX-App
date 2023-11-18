import 'dart:io';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/data-source/firebase_data_source.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthRepositoryImp extends AuthRepository {
  /// `AuthRepositoryImp` class extends `AuthRepository`.
  /// It uses Firebase for authentication.

  /// Instance of Firebase authentication.
  final _firebaseAuth = FirebaseAuth.instance;
  
  final FirebaseDataSource _firebaseDataSource = getIt();


  ///Instance of Firebase storage.
  final _firebaseStorage = firebase_storage.FirebaseStorage.instance;

  /// Returns a Stream of Strings representing the authentication state changes.
  /// Each emitted event is the user's UID, or null if the user is not signed in.
  @override
  Stream<String?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().asyncMap((user) => user?.uid);
  }

  /// Returns the current user.
  @override
  Stream<String?> get getUserDisplayName {
    return _firebaseAuth
        .authStateChanges()
        .asyncMap((user) => user?.displayName);
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

  /// Returns the current user UID.
  @override
  String? get getCurrentUserUID {
    return _firebaseAuth.currentUser?.uid;
  }

  /// Deletes the current user.
  @override
  Future<void> deleteUser() async {
    await _firebaseAuth.currentUser?.delete();
  }

  /// Updates the current user display name.
  @override
  Future<void> updateDisplayName(String name) async {
    await _firebaseAuth.currentUser?.updateDisplayName(name);
  }

  ///Push image to firebase storage
  @override
  Future<String> pushImageToFirebaseStorage(
      String uid, String path, File image) async {
    final ref = _firebaseStorage.ref().child(path).child(uid);
    final uploadTask = ref.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  /// Updates the current user profile picture.
  @override
  Future<void> updateProfilePicture(String url) async {
    await _firebaseAuth.currentUser?.updatePhotoURL(url);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
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

  /// Checks if the current user is admin.
  @override
  Future<bool> getIsAdmin() async {
    return await _firebaseDataSource.getIsAdmin();
  }
}
