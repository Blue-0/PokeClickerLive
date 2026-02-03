import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_service.g.dart';

enum CaptureResult { success, escaped }

@riverpod
class CaptureService extends _$CaptureService {
  final Random _random = Random();

  @override
  void build() {}

  /// Attempts to capture a Pokémon.
  /// Base capture rate is 25%.
  CaptureResult attemptCapture(int speciesId) {
    // In the future, we can look up species rarity here
    const baseRate = 25;

    if (_random.nextInt(100) < baseRate) {
      return CaptureResult.success;
    }
    return CaptureResult.escaped;
  }
}
