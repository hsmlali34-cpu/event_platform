import '../domain/event.dart';
import '../domain/event_category.dart';
import '../domain/event_repository.dart';

class SampleEventRepository implements EventRepository {
  SampleEventRepository() : _events = _buildEvents();

  final List<Event> _events;

  @override
  Future<List<Event>> getUpcomingEvents() async => List.unmodifiable(_events);

  @override
  Future<Event?> getEventById(String eventId) async {
    for (final event in _events) {
      if (event.id == eventId) return event;
    }
    return null;
  }

  static List<Event> _buildEvents() {
    final now = DateTime.now();
    return [
      Event(
        id: 'city-lights',
        title: 'City Lights Social',
        organizer: 'Afterhours Collective',
        category: EventCategory.clubs,
        startsAt: DateTime(now.year, now.month, now.day + 3, 19),
        endsAt: DateTime(now.year, now.month, now.day + 3, 23),
        venue: 'The Glasshouse, Downtown',
        summary: 'A rooftop night for good music and better company.',
        description: 'Meet the city after dark. Expect local DJs, a rooftop view, and room to make new connections. Doors open at 7 PM; bring a valid photo ID.',
        capacity: 180,
        priceLabel: 'Free',
      ),
      Event(
        id: 'future-builders',
        title: 'Future Builders Summit',
        organizer: 'Northstar Labs',
        category: EventCategory.conferences,
        startsAt: DateTime(now.year, now.month, now.day + 8, 9),
        endsAt: DateTime(now.year, now.month, now.day + 8, 17),
        venue: 'Foundry Conference Center',
        summary: 'A full day of ideas shaping what comes next.',
        description: 'Hear from founders, designers, and engineers building thoughtful technology. The day includes keynote talks, small-group sessions, and a closing networking hour.',
        capacity: 320,
        priceLabel: '\$24',
      ),
      Event(
        id: 'civic-code',
        title: 'Civic Code Weekend',
        organizer: 'Open City Network',
        category: EventCategory.hackathons,
        startsAt: DateTime(now.year, now.month, now.day + 14, 10),
        endsAt: DateTime(now.year, now.month, now.day + 15, 18),
        venue: 'Central Library, Innovation Floor',
        summary: 'Build practical tools for a more connected city.',
        description: 'Teams will work with community partners on open challenges in mobility, access, and public information. All experience levels are welcome; meals and mentoring are provided.',
        capacity: 120,
        priceLabel: 'Free',
      ),
      Event(
        id: 'print-and-play',
        title: 'Print & Play Studio',
        organizer: 'Common Ground Studio',
        category: EventCategory.workshops,
        startsAt: DateTime(now.year, now.month, now.day + 18, 13),
        endsAt: DateTime(now.year, now.month, now.day + 18, 16),
        venue: 'Common Ground, Studio 4',
        summary: 'Make a tiny zine and leave with a new skill.',
        description: 'A hands-on introduction to folding, layout, and risograph printing. Materials are included, and no previous design experience is needed.',
        capacity: 24,
        priceLabel: '\$12',
      ),
      Event(
        id: 'neighborhood-table',
        title: 'The Neighborhood Table',
        organizer: 'Good Food Project',
        category: EventCategory.community,
        startsAt: DateTime(now.year, now.month, now.day + 22, 17),
        endsAt: DateTime(now.year, now.month, now.day + 22, 20),
        venue: 'Riverside Community Garden',
        summary: 'A shared dinner celebrating local makers.',
        description: 'Bring a dish or simply bring yourself. Meet neighborhood growers, artists, and organizers for an easy evening around one long table.',
        capacity: 70,
        priceLabel: 'Pay what you can',
      ),
    ];
  }
}
