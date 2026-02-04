import 'package:hive/hive.dart';
import '../domain/inventory.dart';

class InventoryAdapter extends TypeAdapter<Inventory> {
  @override
  final int typeId = 3;

  @override
  Inventory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    final itemMap = fields[0] as Map? ?? {};
    return Inventory(items: Map<String, int>.from(itemMap));
  }

  @override
  void write(BinaryWriter writer, Inventory obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
