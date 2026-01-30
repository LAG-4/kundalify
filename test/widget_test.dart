// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kundalify/src/app/kundalify_app.dart';

void main() {
  testWidgets('welcome -> input flow', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: KundalifyApp()));

    expect(find.text('Cosmic Kundali'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pump();

    expect(find.text('Birth Details'), findsOneWidget);
    expect(find.text('Generate'), findsOneWidget);
  });
}
