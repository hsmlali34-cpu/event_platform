class Registration {
  const Registration({
    required this.eventId,
    required this.fullName,
    required this.email,
    required this.createdAt,
  });

  final String eventId;
  final String fullName;
  final String email;
  final DateTime createdAt;
}
