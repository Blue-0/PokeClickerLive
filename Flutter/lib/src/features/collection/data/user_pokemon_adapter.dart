import 'package:hive/hive.dart';
import 'package:pokeclickerlive/src/features/collection/domain/user_pokemon.dart';

class UserPokemonAdapter extends TypeAdapter<UserPokemon> {
  @override
  final int typeId = 2; // Must match the HiveType(typeId: 2) if we kept it, but here we define it manually

  @override
  UserPokemon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPokemon(
      id: fields[0] as String,
      pokemonId: fields[1] as int,
      acquiredAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserPokemon obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pokemonId)
      ..writeByte(2)
      ..write(obj.acquiredAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPokemonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
