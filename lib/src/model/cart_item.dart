import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final ItemDonacion item;
  final int cantidad;

  const CartItem({
    required this.item,
    required this.cantidad,
  });

  @override
  List<Object> get props => [item, cantidad];

  CartItem copyWith({
    ItemDonacion? item,
    int? cantidad,
  }) {
    return CartItem(
      item: item ?? this.item,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': item.id,
      'cantidad': cantidad,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      item: ItemDonacion.fromMap(map['id'], map),
      cantidad: map['cantidad'],
    );
  }
}