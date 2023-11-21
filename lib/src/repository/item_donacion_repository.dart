import 'package:bamx_app/src/model/item_donacion.dart';

abstract class ItemDonacionRepository {
  Stream<Iterable<ItemDonacion>> getPriorityItems();
  Stream<Iterable<ItemDonacion>> getNormalItems();
  Future<void> addItemToCart(ItemDonacion item);
  Future<void> changePriority(ItemDonacion item, bool isIncrement);
}