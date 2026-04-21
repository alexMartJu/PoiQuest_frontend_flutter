import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_progress.dart';

abstract class GamificationRepository {
  Future<GamificationProgress> getMyProgress();
}
