class ImageEntity {
  final int id;
  final String imageUrl;
  final int sortOrder;
  final bool isPrimary;
  final DateTime createdAt;

  const ImageEntity({
    required this.id,
    required this.imageUrl,
    required this.sortOrder,
    required this.isPrimary,
    required this.createdAt,
  });
}
