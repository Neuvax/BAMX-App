import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState {
  initial,
  signedIn,
  signedOut,
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = getIt();
  StreamSubscription? _authSubscription;

  AuthCubit() : super(AuthState.initial);

  /// Initializes the cubit and listens to the authentication state changes.
  Future<void> init() async {
    _authSubscription = _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  void _authStateChanged(String? userUID) {
    if (userUID != null) {
      emit(AuthState.signedIn);
    } else {
      emit(AuthState.signedOut);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(AuthState.signedOut);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

}