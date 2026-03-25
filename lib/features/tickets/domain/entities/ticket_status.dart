enum TicketStatus {
  pendingPayment,
  active,
  used,
  expired;

  static TicketStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING_PAYMENT':
        return TicketStatus.pendingPayment;
      case 'ACTIVE':
        return TicketStatus.active;
      case 'USED':
        return TicketStatus.used;
      case 'EXPIRED':
        return TicketStatus.expired;
      default:
        return TicketStatus.active;
    }
  }
}
