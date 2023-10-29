import 'package:bamx_app/src/model/cart_item.dart';

abstract class CartRepository {
  Stream<Iterable<CartItem>> getUserCart();
}