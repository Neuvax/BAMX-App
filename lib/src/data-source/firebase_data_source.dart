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
    final itemIndex =
        cartItems.indexWhere((element) => element['id'] == item.id);
    if (itemIndex == -1) {
      cartItems.add({
        'id': item.id,
        'cantidad': 1,
      });
    } else if (cartItems[itemIndex]['cantidad'] == 1) {
      cartItems[itemIndex]['cantidad'] = 1;
    } else {
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
    return Stream.fromFuture(Future.wait([
      firestore
          .collection('userDonations')
          .doc(currentUser.uid)
          .collection('pendientes')
          .get(),
      firestore
          .collection('userDonations')
          .doc(currentUser.uid)
          .collection('aprobadas')
          .get(),
      firestore
          .collection('userDonations')
          .doc(currentUser.uid)
          .collection('rechazadas')
          .get(),
    ]).then((results) {
      final pendientes = results[0]
          .docs
          .map((doc) => DonationGroup.fromMap(doc.id, "Pending", doc.data()))
          // .where((donation) => donation != null)
          .cast<DonationGroup>()
          .toList();
      final aprobadas = results[1]
          .docs
          .map((doc) => DonationGroup.fromMap(doc.id, "Approved", doc.data()))
          // .where((donation) => donation != null)
          .cast<DonationGroup>()
          .toList();
      final rechazadas = results[2]
          .docs
          .map((doc) => DonationGroup.fromMap(doc.id, "Rejected", doc.data()))
          // .where((donation) => donation != null)
          .cast<DonationGroup>()
          .toList();

      return UserDonations(
        pendientes: pendientes,
        aprobadas: aprobadas,
        rechazadas: rechazadas,
      );
    }));
  }

  // Get user pending Donations for Home page quick view
  Stream<Iterable<DonationGroup>> getUserPendingDonations() {
    return firestore
        .collection('userDonations')
        .doc(currentUser.uid)
        .collection('pendientes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DonationGroup.fromMap(doc.id, "Pending", doc.data()))
          .toList();
    });
  }

  Future<(DonationGroup, String)?> getPublicDonation(String donationId) async {
    try {
      // Fetch donation data from the 'donations' collection
      var donationSnapshot =
          await firestore.collection('donations').doc(donationId).get();

      if (!donationSnapshot.exists) {
        return null; // No donation found with the given ID
      }

      // Extracting userId and status, with null checks
      String? userId = donationSnapshot.data()?['userId'];
      String? status = donationSnapshot.data()?['status'];

      if (userId == null || status == null) {
        return null; // userId or status is not available
      }

      // Fetching donation group data from the 'userDonations' collection
      var donationGroupSnapshot = await firestore
          .collection('userDonations')
          .doc(userId)
          .collection(status)
          .doc(donationId)
          .get();

      if (donationGroupSnapshot.exists &&
          donationGroupSnapshot.data() != null) {
        // Parse data if available
        return (
          DonationGroup.fromMap(
              donationId, status, donationGroupSnapshot.data()!),
          userId
        );
      } else {
        return null; // No donation group data found or data is null
      }
    } catch (e) {
      // Handle any exceptions
      return null;
    }
  }

  ///Verify donation
  ///If the donation is approved, the donation group is moved to the collection "aprobadas"
  ///If the donation is rejected, the donation group is moved to the collection "rechazadas"
  ///The user's points are updated
  Future<void> verifyDonation(
      DonationGroup donationGroup, String userId, bool isApproved) async {
    try {
      // Update donation status
      await firestore
          .collection('donations')
          .doc(donationGroup.donationId)
          .update({
        'status': isApproved ? 'aprobadas' : 'rechazadas',
      });

      // Move donation group to the corresponding collection
      await firestore
          .collection('userDonations')
          .doc(userId)
          .collection(isApproved ? 'aprobadas' : 'rechazadas')
          .doc(donationGroup.donationId)
          .set({
        'donationDate': donationGroup.donationDate.toIso8601String(),
        'totalPoints': donationGroup.totalPoints,
        'donationsItems': donationGroup.donationItems
            .map((item) => {
                  'name': item.name,
                  'cantidad': item.cantidad,
                  'points': item.puntos,
                })
            .toList(),
      });

      // Delete donation group from the 'pendientes' collection
      await firestore
          .collection('userDonations')
          .doc(userId)
          .collection('pendientes')
          .doc(donationGroup.donationId)
          .delete();

      // Update user points
      await firestore.collection('users').doc(userId).set({
        'puntos': FieldValue.increment(donationGroup.totalPoints),
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
      return;
    }
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

  ///Get if user is admin
  Future<bool> getIsAdmin() async {
    final user = currentUser;
    final admin = await firestore.collection('admins').doc(user.uid).get();
    return admin.exists;
  }
}
