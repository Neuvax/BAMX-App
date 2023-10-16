
import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:bamx_app/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, CurrentAuthState> (
      listener: (context, state) {
        if (state == CurrentAuthState.signedOut) {
          _navigatorKey.currentState?.pushNamedAndRemoveUntil(Routes.login, (_) => false);
        } else if (state == CurrentAuthState.signedIn) {
          _navigatorKey.currentState?.pushNamedAndRemoveUntil(Routes.home, (_) => false);
        }
      },
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'BAMX App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: Routes.routes,
      ),
    );
  }
}
