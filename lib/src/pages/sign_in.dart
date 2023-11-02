import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/smiling_apple.png",
              width: 250,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Builder(builder: (context) {
                    return BlocBuilder<AuthCubit, CurrentAuthState>(
                      builder: (context, state) {
                        if (state.status == Status.error) {
                          return Text(
                            state.errorMessage ?? "",
                            style: const TextStyle(color: Colors.red),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0), // Add this
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0), // Add this
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      labelText: 'Contraseña',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().signInWithEmailAndPassword(
                          emailController.text, passwordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // Reduce these values
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Iniciar Sesión',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Registrarse',
                      style: TextStyle(
                          color: MyColors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  //Sign in with Google
                  const GoogleSignInButton(
                      loadingIndicator: CircularProgressIndicator(),
                      clientId:
                          "773494367421-oggkhjsdg0b29fgluid0ammb2hnr7tfe.apps.googleusercontent.com")
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
