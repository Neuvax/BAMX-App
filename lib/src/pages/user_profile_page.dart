import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/components/editable_display_name.dart';
import 'package:bamx_app/src/components/image_picker.dart';
import 'package:bamx_app/src/pages/privacy_policy_page.dart';
import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? firebaseUser = auth.currentUser;

    return Scaffold(
        appBar: const MyAppBar(),
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: context
                        .read<AuthCubit>()
                        .getCurrentUserProfilePicture(),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ImagePickerWidget(imageUrl: snapshot.data);
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  StreamBuilder<String?>(
                    stream:
                        context.read<AuthCubit>().getCurrentUserDisplayName(),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return EditableDisplayName(displayName: snapshot.data);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Correo electrónico:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<String?>(
                          stream:
                              context.read<AuthCubit>().getCurrentUserEmail(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              );
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: (firebaseUser
                                          ?.providerData[0].providerId !=
                                      'google.com'),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (firebaseUser != null) {
                                        context
                                            .read<AuthCubit>()
                                            .sendPasswordResetEmail(
                                                firebaseUser.email!);
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text(
                                        'Restablecer Contraseña',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (firebaseUser
                                          ?.providerData[0].providerId !=
                                      'google.com'),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Routes.twoFactorAuth);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text(
                                        'Configurar 2FA',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        BlocBuilder<AuthCubit, CurrentAuthState>(
                          builder: (context, state) {
                            if (state.status == Status.error) {
                              return Text(
                                state.errorMessage ?? '',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              );
                            } else if (state.status == Status.success) {
                              return Text(
                                state.errorMessage ?? '',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      'Aviso de Privacidad',
                      style: TextStyle(color: MyColors.accent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Cerrar Sesión',
                        style: TextStyle(color: Colors.white)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 120),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().deleteUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Eliminar mi cuenta',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
