import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CurrentAuthState {
  signedIn,
  signedOut,
}

class AuthCubit extends Cubit<CurrentAuthState> {
  final AuthRepository _authRepository = getIt();
  StreamSubscription? _authSubscription;

  AuthCubit() : super(CurrentAuthState.signedOut);

  /// Initializes the cubit and listens to the authentication state changes.
  Future<void> init() async {
    _authSubscription = _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  void _authStateChanged(String? userUID) {
    if (userUID != null) {
      emit(CurrentAuthState.signedIn);
    } else {
      emit(CurrentAuthState.signedOut);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(CurrentAuthState.signedOut);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

}