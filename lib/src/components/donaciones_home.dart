import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DonacionesHome extends StatelessWidget {
  final ListaDonacionesState state;

  const DonacionesHome({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 130,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: SizedBox(
                          height: 14,
                          width: 60,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {},
                        color: MyColors.green,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else if (state.listaItemsDonaciones.isEmpty) {
      return const Center(
        child: Text(
            'No hay donaciones prioritarias en este momento. Intenta de nuevo más tarde.'),
      );
    } else {
      final listaDonaciones = state.listaItemsDonaciones.toList();
      return ListView.builder(
        itemCount: state.listaItemsDonaciones.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
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
                    listaDonaciones[index].imagen,
                    height: 60,
                    width: 60,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    listaDonaciones[index].nombre,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () => context
                      .read<ListaDonacionesPrioritariasCubit>()
                      .addItemToCart(listaDonaciones[index]),
                  color: MyColors.green,
                )
              ],
            )),
          );
        },
      );
    }
  }
}
