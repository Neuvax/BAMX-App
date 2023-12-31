import 'package:bamx_app/src/model/cart_item.dart';
import 'package:bamx_app/src/model/donacion_item.dart';
import 'package:bamx_app/src/model/donation_group.dart';
import 'package:bamx_app/src/model/reward.dart';
import 'package:bamx_app/src/model/user_donations.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/model/news.dart';
import 'package:bamx_app/src/model/user_points.dart';
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
        .where('prioridad', isGreaterThan: 1)
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
        .where('prioridad', isEqualTo: 1)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ItemDonacion.fromMap(doc.id, doc.data()))
          .toList(); // Convert to list
    });
  }

  ///Get all items from the collection "items"
  ///Returns a stream of ItemDonacion
  Stream<Iterable<ItemDonacion>> getAllItems() {
    return firestore.collection('items').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ItemDonacion.fromMap(doc.id, doc.data()))
          .toList(); // Convert to list
    });
  }

  ///Change the priority of an item by adding 1 or subtracting 1
  Future<void> changePriority(ItemDonacion item, bool isIncrement) async {
    final itemPriority = item.prioridad;
    await firestore.collection('items').doc(item.id).update({
      'prioridad': isIncrement ? itemPriority + 1 : itemPriority - 1,
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
          .map((doc) => DonationGroup.fromMap(doc.id, "pendientes", doc.data()))
          // .where((donation) => donation != null)
          .cast<DonationGroup>()
          .toList();
      final aprobadas = results[1]
          .docs
          .map((doc) => DonationGroup.fromMap(doc.id, "aprobadas", doc.data()))
          // .where((donation) => donation != null)
          .cast<DonationGroup>()
          .toList();
      final rechazadas = results[2]
          .docs
          .map((doc) => DonationGroup.fromMap(doc.id, "rechazadas", doc.data()))
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

  // Get user rewards for rewwards page view
  Stream<Iterable<Reward>> getRewards() {
    return firestore
        .collection('userRewards')
        .doc(currentUser.uid)
        .collection('rewards')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Reward.fromMap(doc.data())).toList();
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
      return null;
    }
  }

  ///Verify donation
  ///If the donation is approved, the donation group is moved to the collection "aprobadas"
  ///If the donation is rejected, the donation group is moved to the collection "rechazadas"
  ///The user's points are updated and the user's rewards are updated
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

      // Delete donation group from the 'pendientes' collection
      await firestore
          .collection('userDonations')
          .doc(userId)
          .collection(donationGroup.donationStatus)
          .doc(donationGroup.donationId)
          .delete();

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
                  'puntos': item.puntos,
                })
            .toList(),
      });

      // Update user points if donation is approved
      if (isApproved && donationGroup.donationStatus != 'aprobadas') {
        await firestore.collection('puntos').doc(userId).set({
          'puntos': FieldValue.increment(donationGroup.totalPoints),
        }, SetOptions(merge: true));

        //Update user's rewards based on points
        final userPoints = await firestore
            .collection('puntos')
            .doc(userId)
            .get()
            .then((value) => value.data()?['puntos']);
        final userRewardsSnapshot = await firestore
            .collection('userRewards')
            .doc(userId)
            .collection('rewards')
            .get();
        final userRewardIds =
            userRewardsSnapshot.docs.map((doc) => doc.id).toSet();

        final rewardsByPointsSnapshot = await firestore
            .collection('rewards')
            .where('minPuntos', isLessThanOrEqualTo: userPoints)
            .get();
        final rewardsByPoints = rewardsByPointsSnapshot.docs
            .where((doc) => !userRewardIds.contains(doc.id))
            .toList();

        for (var reward in rewardsByPoints) {
          await firestore
              .collection('userRewards')
              .doc(userId)
              .collection('rewards')
              .doc(reward.id)
              .set({
            'image': reward.data()['image'],
            'rewardName': reward.data()['rewardName'],
            'rewardDate': DateTime.now().toIso8601String(),
          });
        }

        //Update user's rewards based on number of donations
        final userDonationsSnapshot = await firestore
            .collection('userDonations')
            .doc(userId)
            .collection('aprobadas')
            .get();
        final userDonations =
            userDonationsSnapshot.docs.map((doc) => doc.id).toSet();
        final rewardsByDonationsSnapshot = await firestore
            .collection('rewards')
            .where('minDonaciones', isLessThanOrEqualTo: userDonations.length)
            .get();
        final rewardsByDonations = rewardsByDonationsSnapshot.docs
            .where((doc) => !userRewardIds.contains(doc.id))
            .toList();

        for (var reward in rewardsByDonations) {
          await firestore
              .collection('userRewards')
              .doc(userId)
              .collection('rewards')
              .doc(reward.id)
              .set({
            'image': reward.data()['image'],
            'rewardName': reward.data()['rewardName'],
            'rewardDate': DateTime.now().toIso8601String(),
          });
        }
      } else if (!isApproved && donationGroup.donationStatus == 'aprobadas') {
        await firestore.collection('puntos').doc(userId).set({
          'puntos': FieldValue.increment(-donationGroup.totalPoints),
        }, SetOptions(merge: true));

        //Update user's rewards based on points
        final userPoints = await firestore
            .collection('puntos')
            .doc(userId)
            .get()
            .then((value) => value.data()?['puntos']);
        final userRewardsSnapshot = await firestore
            .collection('userRewards')
            .doc(userId)
            .collection('rewards')
            .get();
        final userRewardIds =
            userRewardsSnapshot.docs.map((doc) => doc.id).toSet();
        //Remove rewards that the user can't afford anymore
        final rewardsByPointsSnapshot = await firestore
            .collection('rewards')
            .where('minPuntos', isGreaterThan: userPoints)
            .get();
        final rewardsByPoints = rewardsByPointsSnapshot.docs
            .where((doc) => userRewardIds.contains(doc.id))
            .toList();
        for (var reward in rewardsByPoints) {
          await firestore
              .collection('userRewards')
              .doc(userId)
              .collection('rewards')
              .doc(reward.id)
              .delete();
        }

        //Update user's rewards based on number of donations
        final userDonationsSnapshot = await firestore
            .collection('userDonations')
            .doc(userId)
            .collection('aprobadas')
            .get();
        final userDonations =
            userDonationsSnapshot.docs.map((doc) => doc.id).toSet();
        final rewardsByDonationsSnapshot = await firestore
            .collection('rewards')
            .where('minDonaciones', isGreaterThan: userDonations.length)
            .get();
        final rewardsByDonations = rewardsByDonationsSnapshot.docs
            .where((doc) => userRewardIds.contains(doc.id))
            .toList();
        for (var reward in rewardsByDonations) {
          await firestore
              .collection('userRewards')
              .doc(userId)
              .collection('rewards')
              .doc(reward.id)
              .delete();
        }
      }
    } catch (e) {
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

  ///Get all the user points from the points collection
  Stream<UserPoints> getPoints() {
    final user = currentUser;
    return firestore
        .collection('puntos')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      return UserPoints.fromMap(snapshot.data()!);
    });
  }

  ///Get if user is admin
  Future<bool> getIsAdmin() async {
    final user = currentUser;
    final admin = await firestore.collection('admins').doc(user.uid).get();
    return admin.exists;
  }

  //function that erases all the items in the cart
  Future<void> clearCart() async {
    final user = currentUser;
    await firestore.collection('carts').doc(user.uid).set({
      'items': [],
    });
  }

  //function that converts a cart item into a DonacionItem
  //then converts the DonacionItem into a donation group
  Future<List<dynamic>> createDonationGroup() async {
    final cartItems = await getUserCart().first;
    // Convert cart items into donation items
    final donationItems = cartItems
        .map((item) => DonacionItem(
              image: '',
              name: item.item.nombre,
              puntos: item.item.prioridad * item.cantidad,
              cantidad: item.cantidad,
            ))
        .toList();

    var suma = 0;
    for (var i = 0; i < donationItems.length; i++) {
      suma += donationItems[i].puntos;
    }

    int totalPoints = suma;

    final donationGroup = DonationGroup(
      donationId: '',
      donationStatus: 'pendientes',
      totalPoints: totalPoints,
      donationDate: DateTime.now(),
      donationItems: donationItems,
    );

    final donationGroupData = {
      'donationDate': donationGroup.donationDate.toIso8601String(),
      'totalPoints': donationGroup.totalPoints,
      'donationsItems': donationGroup.donationItems
          .map((item) => {
                'name': item.name,
                'cantidad': item.cantidad,
                'puntos': item.puntos,
                'image': item.image,
              })
          .toList(),
    };

    final donationGroupRef = await firestore
        .collection('userDonations')
        .doc(currentUser.uid)
        .collection('pendientes')
        .add(donationGroupData);

    await firestore
        .collection('donations')
        .doc(donationGroupRef.id)
        .set({'userId': currentUser.uid, 'status': 'pendientes'});
    await clearCart();

    // Devuelve una lista con los elementos que necesitas
    return [currentUser.uid, totalPoints, donationItems.length];
  }
}
