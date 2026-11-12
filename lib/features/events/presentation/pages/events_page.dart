import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/event.dart';
import '../../domain/event_category.dart';
import '../../domain/event_filter.dart';
import '../providers/event_providers.dart';
import '../widgets/event_card.dart';
import '../widgets/featured_event_card.dart';
import 'event_detail_page.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final _searchController = TextEditingController();
  EventCategory? _selectedCategory;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(upcomingEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const _Wordmark(),
        actions: [
          IconButton(
            tooltip: 'Refresh events',
            onPressed: () => ref.invalidate(upcomingEventsProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: events.when(
        loading: () => const _LoadingFeed(),
        error: (error, stackTrace) =>
            _LoadError(onRetry: () => ref.invalidate(upcomingEventsProvider)),
        data: (items) => _buildFeed(context, items),
      ),
    );
  }

  Widget _buildFeed(BuildContext context, List<Event> items) {
    final filter = EventFilter(category: _selectedCategory, query: _query);
    final filtered = items.where(filter.matches).toList();
    final featured = filtered.isEmpty ? null : filtered.first;
    final remaining = filtered.length < 2 ? <Event>[] : filtered.sublist(1);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 720;
    final horizontalPadding = isWide ? 32.0 : 20.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1040),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR CITY, IN GOOD COMPANY',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.coral,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find your next\nfavorite thing.',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search events, places, hosts',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear search',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CategoryFilters(
                      selectedCategory: _selectedCategory,
                      onSelected: (category) =>
                          setState(() => _selectedCategory = category),
                    ),
                    const SizedBox(height: 24),
                    _SectionHeading(
                      eyebrow: 'A LITTLE INSPIRATION',
                      title: 'Picked for you',
                    ),
                    if (featured != null) ...[
                      const SizedBox(height: 12),
                      FeaturedEventCard(
                        event: featured,
                        onTap: () => _openEvent(featured),
                      ),
                    ],
                    const SizedBox(height: 26),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _SectionHeading(
                            eyebrow: 'MAKE A PLAN',
                            title: 'Coming up',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            '${filtered.length} ${filtered.length == 1 ? 'event' : 'events'}',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: const Color(0xFF69766F)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (featured == null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyResults(onClear: _clearFilters),
              )
            else if (remaining.isEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 12))
            else if (isWide)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  28,
                ),
                sliver: SliverGrid.builder(
                  itemCount: remaining.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 480,
                    mainAxisExtent: 220,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) => EventCard(
                    event: remaining[index],
                    onTap: () => _openEvent(remaining[index]),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  28,
                ),
                sliver: SliverList.separated(
                  itemCount: remaining.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) => EventCard(
                    event: remaining[index],
                    onTap: () => _openEvent(remaining[index]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedCategory = null;
    });
  }

  void _openEvent(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EventDetailPage(eventId: event.id),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'gather',
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.w800),
        children: [
          TextSpan(
            text: '.',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFF77847D),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.selectedCategory,
    required this.onSelected,
  });

  final EventCategory? selectedCategory;
  final ValueChanged<EventCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selectedCategory == null,
            showCheckmark: false,
            onSelected: (_) => onSelected(null),
          ),
          for (final category in EventCategory.values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(category.label),
              selected: selectedCategory == category,
              showCheckmark: false,
              onSelected: (_) => onSelected(category),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'No events match that search',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 5),
            const Text(
              'Try another category or search term.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onClear, child: const Text('Clear filters')),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Events could not be loaded.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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

class _LoadingFeed extends StatelessWidget {
  const _LoadingFeed();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        Container(
          height: 38,
          width: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFE6ECE7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.line),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 24),
        for (var index = 0; index < 3; index++) ...[
          Container(
            height: 174,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.line),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
