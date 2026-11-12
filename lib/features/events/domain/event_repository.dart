import 'event.dart';

abstract interface class EventRepository {
  Future<List<Event>> getUpcomingEvents();

  Future<Event?> getEventById(String eventId);
}
