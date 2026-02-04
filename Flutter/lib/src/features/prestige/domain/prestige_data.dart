import 'package:freezed_annotation/freezed_annotation.dart';

part 'prestige_data.freezed.dart';
part 'prestige_data.g.dart';

@freezed
abstract class PrestigeData with _$PrestigeData {
  const factory PrestigeData({
    @Default(0) int prestigeLevel,
    @Default(0) int badgesAmount,
  }) = _PrestigeData;

  factory PrestigeData.fromJson(Map<String, dynamic> json) =>
      _$PrestigeDataFromJson(json);

  const PrestigeData._();

  double get permanentBonus {
    return 1.0 + (prestigeLevel * 0.1);
  }
}
