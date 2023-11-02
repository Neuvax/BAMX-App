import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Status {
  signedIn,
  signedOut,
  error,
}

class CurrentAuthState {
  final Status status;
  final String? errorMessage;

  const CurrentAuthState(this.status, this.errorMessage);
}

class AuthCubit extends Cubit<CurrentAuthState> {
  final AuthRepository _authRepository = getIt();
  StreamSubscription? _authSubscription;

  AuthCubit() : super(const CurrentAuthState(Status.signedOut, null));

  /// Initializes the cubit and listens to the authentication state changes.
  Future<void> init() async {
    _authSubscription = _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  void _authStateChanged(String? userUID) {
    if (userUID != null) {
      emit(const CurrentAuthState(Status.signedIn, null));
    } else {
      emit(const CurrentAuthState(Status.signedOut, null));
    }
  }

  /// Signs in the user with email and password and throws an error if the sign in fails.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const CurrentAuthState(Status.error, 'El correo electrónico y contraseña son requeridos.'));
      return;
    }
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(const CurrentAuthState(Status.error, 'No se encontró ningún usuario con ese correo electrónico.'));
          break;
        case 'wrong-password':
          emit(const CurrentAuthState(Status.error, 'El correo electrónico o contraseña no son válidos.'));
          break;
        case 'invalid-email':
          emit(const CurrentAuthState(Status.error, 'El correo electrónico o contraseña no son válidos.'));
          break;
        default:
          emit(const CurrentAuthState(Status.error, 'Ocurrió un error desconocido.'));
          break;
      }
    } catch (e) {
      emit(const CurrentAuthState(Status.error, 'Ocurrió un error inesperado.'));
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(const CurrentAuthState(Status.signedOut, null));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

}