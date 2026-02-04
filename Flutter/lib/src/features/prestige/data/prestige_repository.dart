import 'package:hive/hive.dart';
import 'package:pokeclickerlive/src/features/prestige/domain/prestige_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prestige_repository.g.dart';

class PrestigeRepository {
  PrestigeRepository(this._box);
  final Box<Map<dynamic, dynamic>> _box;

  static const String _key = 'prestige_state';

  PrestigeData getPrestige() {
    final data = _box.get(_key);
    if (data == null) {
      return const PrestigeData();
    }
    return PrestigeData.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> savePrestige(PrestigeData state) async {
    await _box.put(_key, state.toJson());
  }
}

@Riverpod(keepAlive: true)
PrestigeRepository prestigeRepository(Ref ref) {
  throw UnimplementedError(
    'PrestigeRepository must be overridden in ProviderScope',
  );
}
