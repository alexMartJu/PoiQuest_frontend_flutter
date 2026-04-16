class RouteNavigation {
  final String uuid;
  final String name;
  final List<NavigationPoi> pois;

  const RouteNavigation({
    required this.uuid,
    required this.name,
    required this.pois,
  });
}

class NavigationPoi {
  final String uuid;
  final String title;
  final double? coordX;
  final double? coordY;
  final int sortOrder;
  final bool scanned;
  final String qrCode;

  const NavigationPoi({
    required this.uuid,
    required this.title,
    this.coordX,
    this.coordY,
    required this.sortOrder,
    required this.scanned,
    required this.qrCode,
  });
}
