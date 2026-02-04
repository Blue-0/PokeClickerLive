import 'package:hive/hive.dart';

/// Hive TypeAdapter for persisting upgrade levels
class UpgradeLevelAdapter extends TypeAdapter<Map<String, int>> {
  @override
  final int typeId = 4;

  @override
  Map<String, int> read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final Map<String, int> result = {};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readString();
      final value = reader.readInt();
      result[key] = value;
    }
    return result;
  }

  @override
  void write(BinaryWriter writer, Map<String, int> obj) {
    writer.writeByte(obj.length);
    obj.forEach((key, value) {
      writer.writeString(key);
      writer.writeInt(value);
    });
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpgradeLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
