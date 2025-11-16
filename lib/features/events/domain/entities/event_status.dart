enum EventStatus {
  active,
  finished;

  static EventStatus fromString(String value) {
    return EventStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => EventStatus.active,
    );
  }
}
