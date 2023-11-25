import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/cart_item.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/repository/cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository = getIt();
  StreamSubscription? _cartSubscription;

  CartCubit() : super(const CartState());

  Future<void> init() async {
    _cartSubscription = _cartRepository.getUserCart().listen(cartListener);
  }

  void cartListener(Iterable<CartItem> cartItems) {
    emit(CartState(
      isLoading: false,
      cartItems: cartItems,
    ));
  }

  Future<void> removeItem(String itemId) async {
    await _cartRepository.removeItemFromCart(itemId);
  }

  Future<void> addItemToCart(ItemDonacion item) async {
    await _cartRepository.addItemToCart(item);
  }

  Future<void> deleteItemToCart(ItemDonacion item) async {
    await _cartRepository.deleteItemToCart(item);
  }

  Future<void> deleteAllItems() async {
    await _cartRepository.deleteAllItems();
  }
  Future<List<dynamic>> cartoToDonation() async {
    return await _cartRepository.cartoToDonation();
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}

class CartState extends Equatable {
  final bool isLoading;
  final Iterable<CartItem> cartItems;

  const CartState({
    this.isLoading = true,
    this.cartItems = const [],
  });

  @override
  List<Object> get props => [isLoading, cartItems];

  CartState copyWith({
    bool? isLoading,
    Iterable<CartItem>? cartItems,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      cartItems: cartItems ?? this.cartItems,
    );
  }
}
