import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../events/domain/event.dart';
import '../../../events/presentation/pages/event_detail_page.dart';
import '../../../events/presentation/providers/event_providers.dart';
import '../../../events/presentation/widgets/event_card.dart';
import '../../../registration/presentation/providers/registration_providers.dart';

class MyEventsPage extends ConsumerWidget {
  const MyEventsPage({required this.onExplore, super.key});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrations = ref.watch(registeredEventIdsProvider);
    final events = ref.watch(upcomingEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        actions: [
          IconButton(
            tooltip: 'Refresh registrations',
            onPressed: () => ref.invalidate(registeredEventIdsProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: registrations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _LoadFailure(
          message: 'Your registrations could not be loaded.',
          onRetry: () => ref.invalidate(registeredEventIdsProvider),
        ),
        data: (ids) => events.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _LoadFailure(
            message: 'Events could not be loaded.',
            onRetry: () => ref.invalidate(upcomingEventsProvider),
          ),
          data: (allEvents) {
            final registered = allEvents
                .where((event) => ids.contains(event.id))
                .toList();
            if (registered.isEmpty) {
              return _NoRegistrations(onExplore: onExplore);
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR PLANS',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Good things\non your calendar.',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.confirmation_number_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${registered.length} ${registered.length == 1 ? 'event saved' : 'events saved'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'Upcoming registrations',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.crossAxisExtent < 680) {
                            return SliverList.separated(
                              itemCount: registered.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) =>
                                  _eventCard(context, registered[index]),
                            );
                          }
                          return SliverGrid.builder(
                            itemCount: registered.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 480,
                                  mainAxisExtent: 220,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                ),
                            itemBuilder: (context, index) =>
                                _eventCard(context, registered[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _eventCard(BuildContext context, Event event) {
    return EventCard(
      event: event,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => EventDetailPage(eventId: event.id),
        ),
      ),
    );
  }
}

class _NoRegistrations extends StatelessWidget {
  const _NoRegistrations({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.confirmation_number_outlined,
                  size: 38,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Your plans start here',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 7),
              const Text(
                'Register for an event and it will be waiting for you here.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onExplore,
                icon: const Icon(Icons.explore_outlined),
                label: const Text('Explore events'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
