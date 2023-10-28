import 'package:bamx_app/src/app.dart';
import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:bamx_app/src/data-source/firebase_data_source.dart';
import 'package:bamx_app/src/repository/auth_repository.dart';
import 'package:bamx_app/src/repository/implementations/auth_repository.dart';
import 'package:bamx_app/src/repository/implementations/item_donacion_repository.dart';
import 'package:bamx_app/src/repository/item_donacion_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await injectDependencies();

  runApp(BlocProvider(
    create: (_) => AuthCubit()..init(),
    child: const MyApp(),
  ));
}

Future<void> injectDependencies() async {
  getIt.registerLazySingleton<FirebaseDataSource>(() => FirebaseDataSource());

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImp());
  getIt.registerLazySingleton<ItemDonacionRepository>(() => ItemDonacionRepositoryImp());
}
