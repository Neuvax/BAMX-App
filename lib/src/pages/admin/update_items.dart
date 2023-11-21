import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateItemsPage extends StatelessWidget {
  const UpdateItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListaAdminDonaciones()..init(),
      child: BlocBuilder<ListaAdminDonaciones, ListaDonacionesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Lista de donaciones'),
            ),
            body: ListView.builder(
              itemCount: state.listaItemsDonaciones.length,
              itemBuilder: (context, index) {
                final item = state.listaItemsDonaciones.elementAt(index);
                return Card(
                    child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Image.network(item.imagen),
                        title: Text(item.nombre),
                        subtitle: Text(item.unidad),
                      ),
                    ),
                    //Add and substract priority
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (item.prioridad > 0) {
                           context.read<ListaAdminDonaciones>().changePriority(item, false);
                        }
                      },
                    ),
                    //Show priority
                    Text(item.prioridad.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (item.prioridad < 5) {
                          context.read<ListaAdminDonaciones>().changePriority(item, true);
                        }
                      },
                    ),
                  ],
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
