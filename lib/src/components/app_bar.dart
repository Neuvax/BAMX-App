import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/bamx_logo.png",
              fit: BoxFit.cover,
              height: 40,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Navigator.pushNamed(context, Routes.cart),
                  color: MyColors.accent,
                  iconSize: 27.0,
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => Navigator.pushNamed(context, Routes.userProfile),
                  color: MyColors.accent,
                  iconSize: 27.0,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
