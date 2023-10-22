import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

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
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: MyColors.accent,
        width: 0.2,
      ))),
      child: AppBar(
        title: Image.asset(
          "assets/images/bamx_logo.png",
          fit: BoxFit.cover,
          height: 40,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => navigateToRoute(context, Routes.cart),
            color: MyColors.accent,
            iconSize: 27.0,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => navigateToRoute(context, Routes.userProfile),
            color: MyColors.accent,
            iconSize: 27.0,
          )
        ],
      ),
    );
  }
}
