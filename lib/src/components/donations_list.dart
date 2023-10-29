import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonationsList extends StatelessWidget {
  final ListaDonacionesState state;
  final String title;

  const DonationsList({Key? key, required this.title, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.listaItemsDonaciones.length,
            itemBuilder: (context, index) {
              final itemDonacion = state.listaItemsDonaciones.elementAt(index);
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Image.network(itemDonacion.imagen),
                  title: Text(itemDonacion.nombre),
                  subtitle: Text("Cantidad: 1 ${itemDonacion.unidad}"),
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
                                child: Text('${itemDonacion.nombre} agregado al carrito', style: const TextStyle(color: Colors.white)),
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
          ),
        ),
      ],
    );
  }
}
