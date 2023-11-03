import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Status {
  signedIn,
  signedOut,
  error,
  success,
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

  /// Gets the current user display name.
  Stream<String?> getCurrentUserDisplayName() {
    return _authRepository.getUserDisplayName;
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

  /// Signs up the user with email and password and throws an error if the sign up fails.
  Future<void> signUpWithEmailAndPassword(String name, String email, String password, String confirmPassword) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      emit(const CurrentAuthState(Status.error, 'Todos los campos son requeridos.'));
      return;
    } else if (password != confirmPassword) {
      emit(const CurrentAuthState(Status.error, 'Las contraseñas no coinciden.'));
      return;
    }

    if (password.length < 10) {
      emit(const CurrentAuthState(Status.error, 'La contraseña debe tener al menos 10 caracteres.'));
      return;
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      emit(const CurrentAuthState(Status.error, 'La contraseña debe tener al menos una letra mayúscula.'));
      return;
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      emit(const CurrentAuthState(Status.error, 'La contraseña debe tener al menos una letra minúscula.'));
      return;
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      emit(const CurrentAuthState(Status.error, 'La contraseña debe tener al menos un número.'));
      return;
    } else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\-_]'))) {
      emit(const CurrentAuthState(Status.error, 'La contraseña debe tener al menos un caracter especial.'));
      return;
    }

    try {
      await _authRepository.signUpWithEmailAndPassword(name, email, password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emit(const CurrentAuthState(Status.error, 'Error al registrar la cuenta.'));
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

    //Send email verification
    await _authRepository.sendEmailVerification();
  }

  /// Sends a password reset email to the user.
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      emit(const CurrentAuthState(Status.error, 'El correo electrónico es requerido.'));
      return;
    } else if (!email.contains('@')) {
      emit(const CurrentAuthState(Status.error, 'El correo electrónico no es válido.'));
      return;
    }
    try {
      await _authRepository.sendPasswordResetEmail(email);
      emit(const CurrentAuthState(Status.success, 'Se envió un correo de recuperación a su cuenta.'));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(const CurrentAuthState(Status.error, 'Error al enviar el correo de recuperación.'));
          break;
        default:
          emit(const CurrentAuthState(Status.error, 'Ocurrió un error desconocido.'));
          break;
      }
    } catch (e) {
      emit(const CurrentAuthState(Status.error, 'Ocurrió un error inesperado.'));
    }
  }

  /// Resets the error message.
  Future<void> reset() async {
    emit(const CurrentAuthState(Status.signedOut, null));
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