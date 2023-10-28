import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/data-source/firebase_data_source.dart';
import 'package:bamx_app/src/model/item_donacion.dart';
import 'package:bamx_app/src/repository/item_donacion_repository.dart';

class ItemDonacionRepositoryImp extends ItemDonacionRepository {

  final FirebaseDataSource _firebaseDataSource = getIt();

  @override
  Stream<Iterable<ItemDonacion>> getItems() {
    return _firebaseDataSource.getItems();
  }
}