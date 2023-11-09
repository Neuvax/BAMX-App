import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        color: MyColors.background,
        elevation: 1,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
              child: Image.asset(
                "assets/images/smiling_apple.png",
                height: 130,
                width: 200,
                fit: BoxFit.fill,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "El Banco de Alimentos tendrá un horario especial por el día de las madres",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}