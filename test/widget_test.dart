import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_calendar_collection/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CalendarApp(),
      ),
    );

    // Verify the app renders the home screen title
    expect(find.textContaining('日历'), findsWidgets);
  });
}
