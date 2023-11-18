import 'dart:io' show Platform;

import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final googleSignInId = kIsWeb
        ? "773494367421-oggkhjsdg0b29fgluid0ammb2hnr7tfe.apps.googleusercontent.com"
        : Platform.isIOS
            ? "773494367421-422ivqc2pclhjqsgpphp90g2jms4r8u8.apps.googleusercontent.com"
            : "773494367421-oggkhjsdg0b29fgluid0ammb2hnr7tfe.apps.googleusercontent.com";
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    BlocBuilder<AuthCubit, CurrentAuthState>(
                      builder: (context, state) {
                        if (state.status == Status.error) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              state.errorMessage ?? "",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0), // Add this
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: 'Nombre',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0), // Add this
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
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0), // Add this
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: 'Contraseña',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'La contraseña debe tener al menos 10 caracteres, '
                      'una letra mayúscula, una letra minúscula, un número y un carácter especial.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0), // Add this
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: 'Confirmar contraseña',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().signUpWithEmailAndPassword(
                            nameController.text,
                            emailController.text,
                            passwordController.text,
                            confirmPasswordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10), // Reduce these values
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Registrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '¿Ya tienes una cuenta? Inicia sesión',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: MyColors.green,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GoogleSignInButton(
                      label: 'Regístrate con Google',
                      loadingIndicator: const CircularProgressIndicator(),
                      clientId: googleSignInId,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
