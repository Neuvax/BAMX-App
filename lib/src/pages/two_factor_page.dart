import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';

class TwoFactorAuthPage extends StatelessWidget {
  const TwoFactorAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final verificationCodeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autentificación de 2 factores'),
      ),
      body: BlocListener<AuthCubit, CurrentAuthState>(
        listener: (context, state) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.hideCurrentSnackBar();

          if (state.status == Status.error && state.errorMessage != null) {
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          } else if (state.status == Status.success ||
              state.status == Status.codeSent) {
            // Aquí puedes poner un mensaje de éxito si es necesario
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    CountryCodePicker(
                      onChanged: (country) {
                        // Actualiza el texto del controlador con el código del país
                        phoneNumberController.text = country.toString();
                      },
                      initialSelection: 'MX',
                      favorite: const ['+52', 'MX'],
                    ),
                    Expanded(
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Número de teléfono',
                          hintText: 'Ejemplo: +52 55 5555 5555',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Inicia el proceso de configuración de 2FA
                    context
                        .read<AuthCubit>()
                        .enrollSecondFactor(phoneNumberController.text);
                  },
                  child: const Text('Enviar código SMS'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: verificationCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Código de verificación',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Completa el proceso de configuración de 2FA
                    String? verificationId =
                        context.read<AuthCubit>().getVerificationId();
                    context.read<AuthCubit>().verifySecondFactor(
                        verificationId!, verificationCodeController.text);
                  },
                  child: const Text('Verificar teléfono'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
