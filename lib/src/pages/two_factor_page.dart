import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TwoFactorAuthPage extends StatelessWidget {
  const TwoFactorAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final verificationCodeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Two Factor Authentication'),
      ),
      body: BlocListener<AuthCubit, CurrentAuthState>(
        listener: (context, state) {
          if (state.status == Status.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
          } else if (state.status == Status.success ||
              state.status == Status.codeSent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Start the 2FA setup process
                    context
                        .read<AuthCubit>()
                        .enrollSecondFactor(phoneNumberController.text);
                  },
                  child: const Text('Configurar 2FA'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: verificationCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Verification Code',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Complete the 2FA setup process
                    String? verificationId =
                        context.read<AuthCubit>().getVerificationId();
                    context.read<AuthCubit>().verifySecondFactor(
                        verificationId!, verificationCodeController.text);
                  },
                  child: const Text('Verificar 2FA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
