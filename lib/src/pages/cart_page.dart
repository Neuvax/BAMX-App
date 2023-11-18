import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/cubits/cart_cubit.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/utils/colors.dart';
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
            // If the state is loading, show a progress indicator
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // If there are no items, show a message
            else if (state.cartItems.isEmpty) {
              return const Center(
                child: Text("No hay donaciones disponibles"),
              );
            } else {
              final cartItemsList = state.cartItems.toList();
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: cartItemsList.length,
                        itemBuilder: (context, index) {
                          return ListItem(
                            item: cartItemsList[index].item,
                            quantity:
                                ValueNotifier<int>(cartItemsList[index].cantidad),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Add logic for submitting the cart
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final ItemDonacion item;
  final ValueNotifier<int> quantity;

  const ListItem({super.key, required this.item, required this.quantity});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.item.nombre),
          Row(
            children: [
              RawMaterialButton(
                onPressed: () {
                  context.read<CartCubit>().deleteItemToCart(widget.item);
                },
                shape: const CircleBorder(),
                fillColor: MyColors.primary,
                child: const Icon(Icons.remove, color: Colors.white),
              ),
              ValueListenableBuilder<int>(
                valueListenable: widget.quantity,
                builder: (context, value, child) {
                  return Text(value.toString());
                },
              ),
              RawMaterialButton(
                onPressed: () {
                  context.read<CartCubit>().addItemToCart(widget.item);
                },
                shape: const CircleBorder(),
                fillColor: MyColors.yellow,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  context.read<CartCubit>().removeItem(widget.item.id);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
      subtitle: Text("Unidad: ${widget.item.unidad}"),
    );
  }
}
