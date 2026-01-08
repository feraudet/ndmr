import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ndmr/app.dart';

void main() {
  testWidgets('App loads and shows welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NdmrApp(),
      ),
    );

    expect(find.text('Welcome to Ndmr'), findsOneWidget);
    expect(find.text('New Codeplug'), findsOneWidget);
  });
}
