import 'package:bamx_app/src/model/item_donacion.dart';

abstract class ItemDonacionRepository {
  Stream<Iterable<ItemDonacion>> getItems();
}