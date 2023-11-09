import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class DonacionesHome extends StatelessWidget {
  const DonacionesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
              child: Image.network(
                "https://images.vexels.com/media/users/3/145460/isolated/preview/d08a1157100d2e42f31b4a752e71c33b-ilustracion-de-manzana.png",
                height: 60,
                width: 60,
                fit: BoxFit.fill,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                "Manzana",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {},
              color: MyColors.green,
            )
          ],
        )
      ),
    );
  }
}