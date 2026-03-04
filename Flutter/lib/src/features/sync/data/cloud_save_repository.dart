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
  Future<Either<String, Map<String, dynamic>>> loadData() async {
    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.get('/api/user/load');

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final cloudData = data['data'] as Map<String, dynamic>?;
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
        return Right(Map<String, dynamic>.from(response.data));
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
