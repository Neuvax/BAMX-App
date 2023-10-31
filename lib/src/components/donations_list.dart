import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonationList extends StatelessWidget {
  final ListaDonacionesState state;

  const DonationList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state.listaItemsDonaciones.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('No hay donaciones disponibles'),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final itemDonacion = state.listaItemsDonaciones.elementAt(index);
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Image.network(itemDonacion.imagen),
                title: Text(itemDonacion.nombre),
                subtitle: Text("Unidad: ${itemDonacion.unidad}"),
                trailing: IconButton(
                  onPressed: () {
                    BlocProvider.of<ListaDonacionesCubit>(context)
                        .addItemToCart(itemDonacion);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: <Widget>[
                            const Icon(Icons.check, color: Colors.white),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                  '${itemDonacion.nombre} agregado al carrito',
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  color: Colors.green,
                ),
              ),
            );
          },
          childCount: state.listaItemsDonaciones.length,
        ),
      );
    }
  }
}
