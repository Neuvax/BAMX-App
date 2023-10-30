import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/cubits/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: BlocProvider(
        create: (context) => CartCubit()..init(),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            //If the state is loading, show a progress indicator
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //If there are no items, show a message
            else if (state.cartItems.isEmpty) {
              return const Center(
                child: Text("No hay donaciones disponibles"),
              );
            } else {
              final cartItemsList = state.cartItems.toList();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: cartItemsList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(cartItemsList[index].item.nombre),
                        subtitle: Text("Cantidad: ${cartItemsList[index].cantidad} ${cartItemsList[index].item.unidad}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<CartCubit>().removeItem(cartItemsList[index].item.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        )
      )
    );
  }
}