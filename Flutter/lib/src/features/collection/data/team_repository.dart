import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_repository.g.dart';

@Riverpod(keepAlive: true)
TeamRepository teamRepository(Ref ref) {
  final box = Hive.box<List<String>>('team');
  return TeamRepository(box);
}

class TeamRepository {
  final Box<List<String>> _box;
  static const _key = 'active_pokemon_ids';

  TeamRepository(this._box);

  Future<void> saveTeam(List<String> ids) async {
    await _box.put(_key, ids);
  }

  List<String> getTeam() {
    return _box.get(_key) ?? <String>[];
  }
}
