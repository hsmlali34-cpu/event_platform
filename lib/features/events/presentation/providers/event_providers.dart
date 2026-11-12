import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sample_event_repository.dart';
import '../../domain/event.dart';
import '../../domain/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => SampleEventRepository(),
);

final upcomingEventsProvider = FutureProvider<List<Event>>(
  (ref) => ref.watch(eventRepositoryProvider).getUpcomingEvents(),
);

final eventDetailsProvider = FutureProvider.family<Event?, String>(
  (ref, eventId) => ref.watch(eventRepositoryProvider).getEventById(eventId),
);
