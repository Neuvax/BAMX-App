import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class UpdateItemsPage extends StatelessWidget {
  const UpdateItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListaAdminDonaciones()..init(),
      child: BlocBuilder<ListaAdminDonaciones, ListaDonacionesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Donaciones",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Cambia la prioridad de las donaciones haciendo click en los botones de + y -",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const Card(
                          margin: EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                            ),
                            title: SizedBox(
                              width: 100,
                              height: 20,
                            ),
                            subtitle: SizedBox(
                              width: 50,
                              height: 20,
                            ),
                            trailing: SizedBox(
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            );
          } else if (state.listaItemsDonaciones.isEmpty) {
            return const Center(
              child: Text("No hay donaciones"),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomScrollView(slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start  ,
                    children: [
                      Text(
                        "Donaciones",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Cambia la prioridad de las donaciones haciendo click en los botones de + y -",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: state.listaItemsDonaciones.length,
                  (context, index) {
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
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (item.prioridad > 1) {
                              context
                                  .read<ListaAdminDonaciones>()
                                  .changePriority(item, false);
                            }
                          },
                        ),
                        Text(item.prioridad.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (item.prioridad < 5) {
                              context
                                  .read<ListaAdminDonaciones>()
                                  .changePriority(item, true);
                            }
                          },
                        ),
                      ],
                    ));
                  },
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
