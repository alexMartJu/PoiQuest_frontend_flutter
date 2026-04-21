import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_progress.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:poiquest_frontend_flutter/features/gamification/data/datasources/gamification_remote_data_source.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationRemoteDataSource _remoteDataSource;

  GamificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<GamificationProgress> getMyProgress() async {
    final model = await _remoteDataSource.getMyProgress();
    return model.toEntity();
  }
}
