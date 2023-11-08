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
                        return ListItem(
                          item: cartItemsList[index].item,
                          quantity:
                              ValueNotifier<int>(cartItemsList[index].cantidad),
                        );
                      },
                    ),
                  );
                }
              },
            )));
  }
}

class ListItem extends StatefulWidget {
  final ItemDonacion item;
  final ValueNotifier<int> quantity;

  const ListItem({super.key, required this.item, required this.quantity});

  @override
  _ListItemState createState() => _ListItemState();
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
              IconButton(
                onPressed: () {
                  context.read<CartCubit>().deleteItemToCart(widget.item);
                },
                icon: const Icon(Icons.remove, color: MyColors.primary),
              ),
              ValueListenableBuilder<int>(
                valueListenable: widget.quantity,
                builder: (context, value, child) {
                  return Text(value.toString());
                },
              ),
              IconButton(
                onPressed: () {
                  context.read<CartCubit>().addItemToCart(widget.item);
                },
                icon: const Icon(Icons.add, color: MyColors.yellow),
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
