import 'event.dart';
import 'event_category.dart';

class EventFilter {
  const EventFilter({this.category, this.query = ''});

  final EventCategory? category;
  final String query;

  bool matches(Event event) {
    if (category != null && event.category != category) return false;

    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return true;

    return event.title.toLowerCase().contains(normalizedQuery) ||
        event.organizer.toLowerCase().contains(normalizedQuery) ||
        event.venue.toLowerCase().contains(normalizedQuery);
  }
}
