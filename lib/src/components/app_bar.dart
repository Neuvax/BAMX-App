import 'package:bamx_app/src/cubits/auth_cubit.dart';
import 'package:bamx_app/src/cubits/cart_cubit.dart';
import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  void navigateToRoute(BuildContext context, String route) {
    if (!ModalRoute.of(context)!.settings.name!.contains(route)) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pushReplacementNamed(route);
      } else {
        Navigator.pushNamed(context, route);
      }
    }
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // default AppBar height

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CartCubit()..init(),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: MyColors.accent,
            width: 0.2,
          ))),
          child: AppBar(
            leading: ModalRoute.of(context)?.isFirst == true
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.read<AuthCubit>().resetMessage();
                      Navigator.of(context).pop();
                    },
                    color: MyColors.accent,
                    iconSize: 27.0,
                  ),
            title: Image.asset(
              "assets/images/bamx_logo.png",
              fit: BoxFit.cover,
              height: 40,
            ),
            actions: [
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () => navigateToRoute(context, Routes.cart),
                        color: MyColors.accent,
                        iconSize: 27.0,
                      ),
                      if (state.cartItems.isNotEmpty && !state.isLoading)
                        Positioned(
                          right: 3,
                          top: 3,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${state.cartItems.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              StreamBuilder(
                stream:
                    context.read<AuthCubit>().getCurrentUserProfilePicture(),
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () =>
                          navigateToRoute(context, Routes.userProfile),
                      color: MyColors.accent,
                      iconSize: 27.0,
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => navigateToRoute(context, Routes.userProfile),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(snapshot.data!),
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
