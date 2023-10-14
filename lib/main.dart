import 'package:bamx_app/src/app.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:bamx_app/src/repository/implementations/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await injectDependencies();

  runApp(const MyApp());
}

Future<void> injectDependencies() async {
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImp());
}
