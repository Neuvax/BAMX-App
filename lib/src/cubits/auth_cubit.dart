import 'dart:async';
import 'dart:io';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Status {
  signedIn,
  signedOut,
  loading,
  error,
  success,
  codeSent,
}

class CurrentAuthState {
  final Status status;
  final String? errorMessage;

  const CurrentAuthState(this.status, this.errorMessage);
}

class AuthCubit extends Cubit<CurrentAuthState> {
  final AuthRepository _authRepository = getIt();
  StreamSubscription? _authSubscription;
  String? _verificationId;

  AuthCubit() : super(const CurrentAuthState(Status.signedOut, null));

  /// Initializes the cubit and listens to the authentication state changes.
  Future<void> init() async {
    _authSubscription =
        _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  void resetMessage() {
    emit(const CurrentAuthState(Status.signedIn, null));
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

  /// Gets the current user email.
  Stream<String?> getCurrentUserEmail() {
    return _authRepository.getCurrentUserEmail;
  }

  /// Gets the current user profile picture.
  Stream<String?> getCurrentUserProfilePicture() {
    return _authRepository.getCurrentUserProfilePicture;
  }

  /// Deletes the current user.
  Future<void> deleteUser() async {
    await _authRepository.deleteUser();
  }

  /// Signs in the user with email and password and throws an error if the sign in fails.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const CurrentAuthState(
          Status.error, 'El correo electrónico y contraseña son requeridos.'));
      return;
    }
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(const CurrentAuthState(Status.error,
              'No se encontró ningún usuario con ese correo electrónico.'));
          break;
        case 'wrong-password':
          emit(const CurrentAuthState(Status.error,
              'El correo electrónico o contraseña no son válidos.'));
          break;
        case 'invalid-email':
          emit(const CurrentAuthState(Status.error,
              'El correo electrónico o contraseña no son válidos.'));
          break;
        default:
          emit(const CurrentAuthState(
              Status.error, 'Ocurrió un error desconocido.'));
          break;
      }
    } catch (e) {
      emit(
          const CurrentAuthState(Status.error, 'Ocurrió un error inesperado.'));
    }
  }

  /// Signs up the user with email and password and throws an error if the sign up fails.
  Future<void> signUpWithEmailAndPassword(String name, String email,
      String password, String confirmPassword) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      emit(const CurrentAuthState(
          Status.error, 'Todos los campos son requeridos.'));
      return;
    } else if (password != confirmPassword) {
      emit(const CurrentAuthState(
          Status.error, 'Las contraseñas no coinciden.'));
      return;
    }

    if (password.length < 10) {
      emit(const CurrentAuthState(
          Status.error, 'La contraseña debe tener al menos 10 caracteres.'));
      return;
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      emit(const CurrentAuthState(Status.error,
          'La contraseña debe tener al menos una letra mayúscula.'));
      return;
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      emit(const CurrentAuthState(Status.error,
          'La contraseña debe tener al menos una letra minúscula.'));
      return;
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      emit(const CurrentAuthState(
          Status.error, 'La contraseña debe tener al menos un número.'));
      return;
    } else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\-_]'))) {
      emit(const CurrentAuthState(Status.error,
          'La contraseña debe tener al menos un caracter especial.'));
      return;
    }

    try {
      await _authRepository.signUpWithEmailAndPassword(name, email, password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emit(const CurrentAuthState(
              Status.error, 'Error al registrar la cuenta.'));
          break;
        case 'invalid-email':
          emit(const CurrentAuthState(Status.error,
              'El correo electrónico o contraseña no son válidos.'));
          break;
        default:
          emit(const CurrentAuthState(
              Status.error, 'Ocurrió un error desconocido.'));
          break;
      }
    } catch (e) {
      emit(
          const CurrentAuthState(Status.error, 'Ocurrió un error inesperado.'));
    }

    //Send email verification
    await _authRepository.sendEmailVerification();
  }

  /// Sends a password reset email to the user.
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      emit(const CurrentAuthState(
          Status.error, 'El correo electrónico es requerido.'));
      return;
    } else if (!email.contains('@')) {
      emit(const CurrentAuthState(
          Status.error, 'El correo electrónico no es válido.'));
      return;
    }
    try {
      await _authRepository.sendPasswordResetEmail(email);
      emit(const CurrentAuthState(
          Status.success, 'Se envió un correo de recuperación a su cuenta.'));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(const CurrentAuthState(
              Status.error, 'Error al enviar el correo de recuperación.'));
          break;
        default:
          emit(const CurrentAuthState(
              Status.error, 'Ocurrió un error desconocido.'));
          break;
      }
    } catch (e) {
      emit(
          const CurrentAuthState(Status.error, 'Ocurrió un error inesperado.'));
    }
  }

  ///Updates the current user display name.
  Future<void> updateDisplayName(String name) async {
    if (name.isEmpty) {
      emit(const CurrentAuthState(Status.error, 'El nombre es requerido.'));
      return;
    }
    try {
      await _authRepository.updateDisplayName(name);
      emit(const CurrentAuthState(
          Status.success, 'Nombre actualizado correctamente.'));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(const CurrentAuthState(
              Status.error, 'Error al actualizar el nombre.'));
          break;
        default:
          emit(const CurrentAuthState(
              Status.error, 'Ocurrió un error desconocido.'));
          break;
      }
    } catch (e) {
      emit(
          const CurrentAuthState(Status.error, 'Ocurrió un error inesperado.'));
    }
  }

  ///Updates the current user profile picture.
  ///Push image to firebase storage
  Future<void> updateProfilePicture(String path, File image) async {
    final uid = _authRepository.getCurrentUserUID;
    if (uid == null) {
      emit(const CurrentAuthState(
          Status.error, 'Error al actualizar la imagen.'));
      return;
    }
    try {
      final url =
          await _authRepository.pushImageToFirebaseStorage(uid, path, image);
      await _authRepository.updateProfilePicture(url);
      emit(const CurrentAuthState(
          Status.success, 'Imagen actualizada correctamente.'));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(const CurrentAuthState(
              Status.error, 'Error al actualizar la imagen.'));
          break;
        default:
          emit(const CurrentAuthState(
              Status.error, 'Ocurrió un error desconocido.'));
          break;
      }
    } catch (e) {
      emit(
          const CurrentAuthState(Status.error, 'Ocurrió un error inesperado.'));
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

  // Método para inscribir el segundo factor
  Future<void> enrollSecondFactor(String phoneNumber) async {
    emit(const CurrentAuthState(Status.loading, null));
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'no-user', message: 'No user is signed in.');
      }

      final multiFactorSession = await user.multiFactor.getSession();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        multiFactorSession: multiFactorSession,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          emit(CurrentAuthState(Status.error, e.message));
        },
        codeSent: (String verificationId, int? resendToken) async {
          _verificationId = verificationId;
          emit(CurrentAuthState(Status.codeSent, 'Code sent to $phoneNumber'));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(CurrentAuthState(
          Status.error, 'Failed to enroll second factor: ${e.toString()}'));
    }
  }

  String? getVerificationId() {
    return _verificationId;
  }

  // Método para verificar el segundo factor durante la inscripción
  Future<void> verifySecondFactor(String verificationId, String smsCode) async {
    emit(const CurrentAuthState(Status.loading, null));
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'no-user', message: 'No user is signed in.');
      }

      await user.multiFactor
          .enroll(PhoneMultiFactorGenerator.getAssertion(credential));
      emit(const CurrentAuthState(
          Status.success, 'Second factor enrolled successfully'));
    } catch (e) {
      emit(CurrentAuthState(
          Status.error, 'Failed to verify second factor: ${e.toString()}'));
    }
  }

  // Método para iniciar sesión con el segundo factor
  Future<void> signInWithSecondFactor(PhoneAuthCredential credential) async {
    emit(const CurrentAuthState(Status.loading, null));
    try {
      // Este método se llamaría después de que el usuario haya ingresado el código de verificación enviado a su teléfono.
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(const CurrentAuthState(Status.signedIn, null));
    } on FirebaseAuthException catch (e) {
      emit(CurrentAuthState(Status.error, e.message));
    } catch (e) {
      emit(CurrentAuthState(Status.error,
          'Failed to sign in with second factor: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
