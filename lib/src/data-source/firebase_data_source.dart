import 'package:bamx_app/src/model/cart_item.dart';
import 'package:bamx_app/src/model/donation_group.dart';
import 'package:bamx_app/src/model/user_donations.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/model/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDataSource {
  User get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user;
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  ///Get documents from the collection "items" where the field "prioridad" is greater than 1
  Stream<Iterable<ItemDonacion>> getPriorityItems() {
    return firestore
        .collection('items')
        .where('prioridad', isGreaterThan: 0)
        .orderBy('prioridad', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ItemDonacion.fromMap(doc.id, doc.data()))
          .toList(); // Convert to list
    });
  }

  ///Get documents from the collection "items" where the field "prioridad" is equal to 0
  Stream<Iterable<ItemDonacion>> getNormalItems() {
    return firestore
        .collection('items')
        .where('prioridad', isEqualTo: 0)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ItemDonacion.fromMap(doc.id, doc.data()))
          .toList(); // Convert to list
    });
  }

  ///Add item to user's cart
  ///If the item is already in the cart, increase the quantity
  ///If the item is not in the cart, add it
  Future<void> addItemToCart(ItemDonacion item) async {
    final user = currentUser;
    final cart = await firestore.collection('carts').doc(user.uid).get();
    final cartItems = cart.data()?['items'] as List<dynamic>? ?? [];
    final itemIndex =
        cartItems.indexWhere((element) => element['id'] == item.id);
    if (itemIndex == -1) {
      cartItems.add({
        'id': item.id,
        'cantidad': 1,
      });
    } else {
      cartItems[itemIndex]['cantidad']++;
    }
    await firestore.collection('carts').doc(user.uid).set({
      'items': cartItems,
    });
  }

  ///Delete item to user's cart
  ///If the item is already in the cart, decrease the quantity
  ///If the item is not in the cart, subtract it
  Future<void> deleteItemToCart(ItemDonacion item) async {
    final user = currentUser;
    final cart = await firestore.collection('carts').doc(user.uid).get();
    final cartItems = cart.data()?['items'] as List<dynamic>? ?? [];
    final itemIndex = cartItems.indexWhere((element) => element['id'] == item.id);
    if (itemIndex == -1) {
      cartItems.add({
        'id': item.id,
        'cantidad': 1,
      });
    } else if(cartItems[itemIndex]['cantidad'] == 1){
      cartItems[itemIndex]['cantidad'] = 1;
    }else {
      cartItems[itemIndex]['cantidad']--;
    }
    await firestore.collection('carts').doc(user.uid).set({
      'items': cartItems,
    });
  }

  ///Get all items from user's cart
  ///The collection has documents with the user's id and each document has the item's id and quantity
  ///This method gets the item's id and quantity and then gets the item's data from the collection "items"
  ///Returns a stream of CartItem
  Stream<Iterable<CartItem>> getUserCart() {
    return firestore
        .collection('carts')
        .doc(currentUser.uid)
        .snapshots()
        .map((snapshot) {
      final cartItems = snapshot.data()?['items'] as List<dynamic>? ?? [];
      return cartItems.map((item) async {
        final itemData =
            await firestore.collection('items').doc(item['id']).get();
        return CartItem(
          item: ItemDonacion.fromMap(item['id'], itemData.data()!),
          cantidad: item['cantidad'],
        );
      });
    }).asyncMap((event) => Future.wait(event));
  }

  // Get all current user donations in all the categories
  Stream<UserDonations> getUserDonations() {
    return firestore
        .collection('donations')
        .doc(currentUser.uid)
        .snapshots()
        .map((snapshot) {
      final pendientesData =
          snapshot.data()?['pendientes'] as Map<String, dynamic>?;
      final aprobadasData =
          snapshot.data()?['aprobadas'] as Map<String, dynamic>?;
      final rechazadasData =
          snapshot.data()?['rechazadas'] as Map<String, dynamic>?;

      final pendientes =
          pendientesData != null ? DonationGroup.fromMap(pendientesData) : null;
      final aprobadas =
          aprobadasData != null ? DonationGroup.fromMap(aprobadasData) : null;
      final rechazadas =
          rechazadasData != null ? DonationGroup.fromMap(rechazadasData) : null;

      return UserDonations(
        pendientes: pendientes != null ? [pendientes] : [],
        aprobadas: aprobadas != null ? [aprobadas] : [],
        rechazadas: rechazadas != null ? [rechazadas] : [],
      );
    });
  }

  // Get user pending Donations for Home page quick view
  Stream<Iterable<DonationGroup>> getUserPendingDonations() {
    return firestore
        .collection('donations')
        .doc(currentUser.uid)
        .snapshots()
        .map((snapshot) {
      final pendientes = snapshot.data()?['pendientes'] as List<dynamic>? ?? [];
      return pendientes.map((group) => DonationGroup.fromMap(group)).toList();
    });
  }

  ///Remove item from user's cart
  Future<void> removeItemFromCart(String itemId) async {
    final user = currentUser;
    final cart = await firestore.collection('carts').doc(user.uid).get();
    final cartItems = cart.data()?['items'] as List<dynamic>? ?? [];
    final itemIndex =
        cartItems.indexWhere((element) => element['id'] == itemId);
    cartItems.removeAt(itemIndex);
    await firestore.collection('carts').doc(user.uid).set({
      'items': cartItems,
    });
  }






















  ///Get all the news from the collection "news"
  ///Returns a stream of News
  Stream<Iterable<News>> getNews() {
    return firestore.collection('news').snapshots().map((snapshot) {
      return snapshot.docs
        .map((doc) => News.fromMap(doc.id, doc.data()))
        .toList(); // Convert to list
    });
  }
}
