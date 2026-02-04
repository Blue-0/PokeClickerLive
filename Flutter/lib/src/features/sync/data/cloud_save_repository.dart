import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/data/dio_provider.dart';

part 'cloud_save_repository.g.dart';

@Riverpod(keepAlive: true)
CloudSaveRepository cloudSaveRepository(Ref ref) {
  return CloudSaveRepository(ref);
}

class CloudSaveRepository {
  final Ref _ref;

  CloudSaveRepository(this._ref);

  Future<Either<String, Map<String, dynamic>>> syncData({
    required int lastSync,
    required Map<String, dynamic> localData,
  }) async {
    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.post(
        '/api/user/sync',
        data: {'last_sync': lastSync, 'local_data': localData},
      );

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
