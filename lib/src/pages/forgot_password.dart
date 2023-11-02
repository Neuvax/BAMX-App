import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            BlocProvider.of<AuthCubit>(context).reset(),
            Navigator.pop(context)
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0, left: 30.0),
                  child: Text(
                    "Ingresa tu correo electrónico para recuperar tu contraseña:",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                        } else if (state.status == Status.success) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Se ha enviado un correo de recuperación a ${emailController.text}",
                              style: const TextStyle(color: MyColors.green),
                            ),
                          );
                        }
                        else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context)
                            .sendPasswordResetEmail(emailController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Enviar correo de recuperación',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
