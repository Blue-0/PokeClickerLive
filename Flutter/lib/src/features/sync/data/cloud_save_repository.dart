import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/data/dio_provider.dart';

part 'cloud_save_repository.g.dart';

@Riverpod(keepAlive: true)
CloudSaveRepository cloudSaveRepository(Ref ref) {
  return CloudSaveRepository(ref);
}

class CloudSaveRepository {
  final Ref _ref;

  CloudSaveRepository(this._ref);

  /// Load cloud save data from the server without modifying server state.
  /// Used on login to restore progress from the cloud.
  ///
  /// Response structure from server:
  ///   { "status": "success", "data": { "cloud_data": { "user": ..., "pokemon": [...], "game_state": {...} } } }
  /// Returns the inner `cloud_data` map so callers can access game_state / pokemon directly.
  Future<Either<String, Map<String, dynamic>>> loadData() async {
    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.get('/api/user/load');

      if (response.statusCode == 200) {
        final responseBody =
            (response.data is Map ? response.data : {}) as Map<String, dynamic>;
        final innerData = responseBody['data'] is Map
            ? responseBody['data'] as Map<String, dynamic>
            : null;
        final cloudData = innerData?['cloud_data'] is Map
            ? innerData!['cloud_data'] as Map<String, dynamic>
            : null;
        return Right(cloudData ?? {});
      } else {
        return Left('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Left(e.message ?? 'Network error');
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Immediately persist a wild capture to the server so the Pokemon is not
  /// lost if the app closes before the next periodic sync.
  /// Fire-and-forget: callers do not need to await the result.
  Future<void> registerCapture(int pokemonId) async {
    try {
      final dio = _ref.read(dioProvider);
      await dio.post('/api/user/capture', data: {'pokemon_id': pokemonId});
    } catch (e) {
      // Best-effort: the periodic sync will recover any missed captures.
      debugPrint('CloudSaveRepository.registerCapture: failed ($e)');
    }
  }

  Future<Either<String, Map<String, dynamic>>> syncData({
    required int lastSync,
    required Map<String, dynamic> localData,
  }) async {
    try {
      // Get current location
      Position? position;
      try {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          var permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }

          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            try {
              position = await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.medium,
                  timeLimit: Duration(seconds: 5),
                ),
              );
            } catch (e) {
              debugPrint(
                'CloudSaveRepository: getCurrentPosition failed, trying last known ($e)',
              );
              position = await Geolocator.getLastKnownPosition();
            }
          }
        }
      } catch (e) {
        // Ignore location errors
        debugPrint('CloudSaveRepository: Location error: $e');
      }

      final dio = _ref.read(dioProvider);
      final data = {'last_sync': lastSync, 'local_data': localData};

      if (position != null) {
        debugPrint(
          'CloudSaveRepository: Sending coordinates: ${position.latitude}, ${position.longitude}',
        );
        data['latitude'] = position.latitude;
        data['longitude'] = position.longitude;
      } else {
        debugPrint('CloudSaveRepository: Sending sync without coordinates');
      }

      final response = await dio.post('/api/user/sync', data: data);

      if (response.statusCode == 200) {
        // Response structure: { "status": "success", "data": { "server_timestamp": ..., "cloud_data": {...} } }
        // Extract inner data so SyncController can access server_timestamp and cloud_data directly.
        final responseBody =
            (response.data is Map ? response.data : {}) as Map<String, dynamic>;
        final innerData = responseBody['data'] is Map
            ? responseBody['data'] as Map<String, dynamic>
            : null;
        return Right(innerData ?? {});
      } else {
        return Left('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Left(e.message ?? 'Network error');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
