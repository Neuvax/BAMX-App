import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImp extends AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<String?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().asyncMap((user) => user?.uid);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}