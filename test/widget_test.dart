// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:login_sim/main.dart';

void main() {
  testWidgets('successful login flow displays welcome message',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LoginSimApp());

    await tester.enterText(
      find.byKey(const ValueKey('emailField')),
      'demo@flutter.dev',
    );
    await tester.enterText(
      find.byKey(const ValueKey('passwordField')),
      'FlutterR0cks!',
    );

    await tester.tap(find.byKey(const ValueKey('loginButton')));
    await tester.pump(); // start button animation
    await tester.pump(const Duration(milliseconds: 1000));

    expect(
      find.text('Welcome back, Flutter Friend!'),
      findsOneWidget,
    );
  });
}
