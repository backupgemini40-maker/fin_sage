import 'package:fin_sage/core/widgets/haptic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HapticButton is disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HapticButton(label: 'Sign in', icon: Icons.login),
        ),
      ),
    );

    final buttonFinder = find.byWidgetPredicate((widget) => widget is ElevatedButton);
    final button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.onPressed, isNull);
  });
}
