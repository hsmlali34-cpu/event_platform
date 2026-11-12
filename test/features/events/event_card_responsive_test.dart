import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_platform/app/theme/app_theme.dart';
import 'package:event_platform/features/events/data/sample_event_repository.dart';
import 'package:event_platform/features/events/presentation/widgets/event_card.dart';

void main() {
  testWidgets('all sample event cards fit a compact phone width', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;

    final events = await SampleEventRepository().getUpcomingEvents();
    for (final event in events) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [EventCard(event: event, onTap: () {})],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: event.id);
    }
  });
}
