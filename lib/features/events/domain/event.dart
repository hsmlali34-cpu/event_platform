import 'event_category.dart';

class Event {
  const Event({
    required this.id,
    required this.title,
    required this.organizer,
    required this.category,
    required this.startsAt,
    required this.endsAt,
    required this.venue,
    required this.summary,
    required this.description,
    required this.capacity,
    required this.priceLabel,
  });

  final String id;
  final String title;
  final String organizer;
  final EventCategory category;
  final DateTime startsAt;
  final DateTime endsAt;
  final String venue;
  final String summary;
  final String description;
  final int capacity;
  final String priceLabel;
}
