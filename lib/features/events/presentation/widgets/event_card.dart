import 'package:flutter/material.dart';

import '../../domain/event.dart';
import '../../domain/event_category.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event, required this.onTap, super.key});

  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = MaterialLocalizations.of(context)
        .formatShortDate(event.startsAt);
    final time = TimeOfDay.fromDateTime(event.startsAt).format(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 8,
                children: [
                  _CategoryLabel(category: event.category),
                  Text(
                    event.priceLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                event.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFF596760)),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _MetaItem(
                    icon: Icons.calendar_today_outlined,
                    label: '$date · $time',
                  ),
                  _MetaItem(
                    icon: Icons.place_outlined,
                    label: event.venue,
                    maxWidth: 220,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  const _CategoryLabel({required this.category});

  final EventCategory category;

  @override
  Widget build(BuildContext context) {
    final accent = switch (category) {
      EventCategory.clubs => const Color(0xFFE76F51),
      EventCategory.conferences => const Color(0xFF4779A8),
      EventCategory.hackathons => const Color(0xFF146B57),
      EventCategory.workshops => const Color(0xFF9A6B16),
      EventCategory.community => const Color(0xFF795C8D),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          category.label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: accent, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    this.maxWidth = 180,
  });

  final IconData icon;
  final String label;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF68766F)),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth - 24),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: const Color(0xFF596760)),
            ),
          ),
        ],
      ),
    );
  }
}
