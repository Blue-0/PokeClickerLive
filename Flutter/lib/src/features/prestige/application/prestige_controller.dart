import 'package:pokeclickerlive/src/features/clicker/application/clicker_controller.dart';
import 'package:pokeclickerlive/src/features/prestige/data/prestige_repository.dart';
import 'package:pokeclickerlive/src/features/prestige/domain/prestige_data.dart';
import 'package:pokeclickerlive/src/features/shop/application/inventory_controller.dart';
import 'package:pokeclickerlive/src/features/world/application/zone_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prestige_controller.g.dart';

@riverpod
class PrestigeController extends _$PrestigeController {
  late final PrestigeRepository _repository;

  @override
  PrestigeData build() {
    _repository = ref.watch(prestigeRepositoryProvider);
    return _repository.getPrestige();
  }

  Future<void> performReset() async {
    // 1. Calculate new state
    final newState = state.copyWith(
      prestigeLevel: state.prestigeLevel + 1,
      badgesAmount: state.badgesAmount + 1,
    );

    // 2. Persist prestige state
    await _repository.savePrestige(newState);
    state = newState;

    // 3. Reset other controllers
    // For ClickerController, we can either reset it or manipulate its state
    // Given the current implementation, we might need a reset() method in ClickerController
    ref.read(clickerControllerProvider.notifier).resetForPrestige();

    // Reset World State
    ref.read(zoneControllerProvider.notifier).resetToStart();

    // Reset Inventory
    ref.read(inventoryControllerProvider.notifier).resetForPrestige();
  }
}
