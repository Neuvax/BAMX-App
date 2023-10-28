import 'package:bamx_app/src/model/item_donacion.dart';
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

  ///Get all documents from the collection "items"
  Stream<Iterable<ItemDonacion>> getItems() {
    return firestore.collection('items')
      .orderBy('prioridad', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
          .map((doc) => ItemDonacion.fromMap(doc.id, doc.data()))
          .toList(); // Convertir a lista
      });
  }
}
