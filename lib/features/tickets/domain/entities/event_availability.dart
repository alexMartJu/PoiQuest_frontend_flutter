class EventAvailability {
  final int? capacity;
  final int sold;
  final int? available;

  const EventAvailability({
    required this.capacity,
    required this.sold,
    required this.available,
  });

  /// Devuelve true si el evento tiene aforo limitado.
  bool get hasCapacity => capacity != null;

  /// Devuelve true si hay entradas disponibles (o si es ilimitado).
  bool get isAvailable => available == null || available! > 0;
}
