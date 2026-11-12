// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:event_platform/app/event_platform_app.dart';
import 'package:event_platform/features/profile/presentation/pages/profile_page.dart';
import 'package:event_platform/features/registration/presentation/pages/registration_page.dart';

void main() {
  testWidgets('shows upcoming events and category filters', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EventPlatformApp()));
    await tester.pumpAndSettle();

    expect(find.text('City Lights Social'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Conferences'));
    await tester.pumpAndSettle();

    expect(find.text('City Lights Social'), findsNothing);
    expect(find.text('Future Builders Summit'), findsOneWidget);
  });

  testWidgets('Home adapts to phone and tablet widths', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [320.0, 390.0, 800.0]) {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const ProviderScope(child: EventPlatformApp()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'Width: $width');
    }
  });

  testWidgets('details and registration fit a compact phone', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(const ProviderScope(child: EventPlatformApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('City Lights Social'));
    await tester.pumpAndSettle();

    expect(find.text('About this event'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Register now'));
    await tester.pumpAndSettle();
    expect(find.text('Registration'), findsOneWidget);
    await tester.drag(
      find.descendant(
        of: find.byType(RegistrationPage),
        matching: find.byType(ListView),
      ),
      const Offset(0, -480),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('registration is listed in My Events', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EventPlatformApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('City Lights Social'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register now'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.descendant(
        of: find.byType(RegistrationPage),
        matching: find.byType(ListView),
      ),
      const Offset(0, -480),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Taylor Reed');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'taylor@example.com',
    );
    await tester.tap(find.text('Confirm registration'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.confirmation_number_outlined));
    await tester.pumpAndSettle();

    expect(find.text('City Lights Social'), findsOneWidget);
  });

  testWidgets('profile changes can be saved', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EventPlatformApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Taylor Reed');
    await tester.drag(
      find.descendant(
        of: find.byType(ProfilePage),
        matching: find.byType(ListView),
      ),
      const Offset(0, -360),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Profile saved'), findsOneWidget);
  });
}
