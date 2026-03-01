import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/inventory.dart';

part 'inventory_controller.g.dart';

@Riverpod(keepAlive: true)
class InventoryController extends _$InventoryController {
  late final Box<Inventory> _box;

  @override
  Inventory build() {
    _box = Hive.box<Inventory>('inventory');
    return _box.get('current', defaultValue: const Inventory())!;
  }

  void addItem(String itemId, {int quantity = 1}) {
    final currentItems = Map<String, int>.from(state.items);
    currentItems[itemId] = (currentItems[itemId] ?? 0) + quantity;

    state = state.copyWith(items: currentItems);
    _box.put('current', state);
  }

  int getItemQuantity(String itemId) {
    return state.items[itemId] ?? 0;
  }

  void resetForPrestige() {
    state = const Inventory();
    _box.put('current', state);
  }
}
