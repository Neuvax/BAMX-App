import 'package:bamx_app/src/model/cart_item.dart';
import 'package:bamx_app/src/model/item_donacion.dart';

abstract class CartRepository {
  Stream<Iterable<CartItem>> getUserCart();
  Future<void> removeItemFromCart(String itemId);
  Future<void> addItemToCart(ItemDonacion item);
  Future<void> deleteItemToCart(ItemDonacion item);
  Future<void> deleteAllItems();
  Future<void> cartoToDonation();
}