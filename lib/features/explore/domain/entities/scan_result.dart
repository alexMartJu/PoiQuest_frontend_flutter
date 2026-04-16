class ScanResult {
  final String uuid;
  final String poiUuid;
  final String poiTitle;
  final String? interestingData;
  final String? modelUrl;
  final DateTime scannedAt;

  const ScanResult({
    required this.uuid,
    required this.poiUuid,
    required this.poiTitle,
    this.interestingData,
    this.modelUrl,
    required this.scannedAt,
  });
}
