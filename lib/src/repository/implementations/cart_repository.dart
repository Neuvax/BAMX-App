import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/data-source/firebase_data_source.dart';
import 'package:bamx_app/src/model/cart_item.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/repository/cart_repository.dart';

class CartRepositoryImp extends CartRepository {
  final FirebaseDataSource _firebaseDataSource = getIt();

  @override
  Stream<Iterable<CartItem>> getUserCart() {
    return _firebaseDataSource.getUserCart();
  }

  @override
  Future<void> removeItemFromCart(String itemId) async {
    await _firebaseDataSource.removeItemFromCart(itemId);
  }

  @override
  Future<void> addItemToCart(ItemDonacion item) {
    return _firebaseDataSource.addItemToCart(item);
  }

  @override
  Future<void> deleteItemToCart(ItemDonacion item) async {
    return _firebaseDataSource.deleteItemToCart(item);
  }

  @override
  Future<void> deleteAllItems() async {
    return _firebaseDataSource.clearCart();
  }

  Future<void> cartoToDonation() async {
    return _firebaseDataSource.createDonationGroup();
  }
}
