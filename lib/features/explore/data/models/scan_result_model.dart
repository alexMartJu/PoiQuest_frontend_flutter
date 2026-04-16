import 'package:poiquest_frontend_flutter/features/explore/domain/entities/scan_result.dart';

class ScanResultModel {
  final String uuid;
  final String poiUuid;
  final String poiTitle;
  final String? interestingData;
  final String? modelUrl;
  final DateTime scannedAt;

  const ScanResultModel({
    required this.uuid,
    required this.poiUuid,
    required this.poiTitle,
    this.interestingData,
    this.modelUrl,
    required this.scannedAt,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      uuid: json['uuid'] as String,
      poiUuid: json['poiUuid'] as String,
      poiTitle: json['poiTitle'] as String,
      interestingData: json['interestingData'] as String?,
      modelUrl: json['modelUrl'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );
  }

  ScanResult toEntity() {
    return ScanResult(
      uuid: uuid,
      poiUuid: poiUuid,
      poiTitle: poiTitle,
      interestingData: interestingData,
      modelUrl: modelUrl,
      scannedAt: scannedAt,
    );
  }
}
