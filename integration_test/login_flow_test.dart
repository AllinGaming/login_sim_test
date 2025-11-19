import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:login_sim/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user can log in with the demo credentials',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LoginSimApp());

    final emailField = find.byKey(const ValueKey('emailField'));
    final passwordField = find.byKey(const ValueKey('passwordField'));
    final loginButton = find.byKey(const ValueKey('loginButton'));

    await tester.enterText(emailField, 'demo@flutter.dev');
    await tester.enterText(passwordField, 'FlutterR0cks!');

    await tester.tap(loginButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));

    expect(
      find.text('Welcome back, Flutter Friend!'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('statusMessage')), findsOneWidget);
  });

  testWidgets('invalid credentials surface an error message',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LoginSimApp());

    await tester.enterText(
      find.byKey(const ValueKey('emailField')),
      'wrong@flutter.dev',
    );
    await tester.enterText(
      find.byKey(const ValueKey('passwordField')),
      'password123',
    );

    await tester.tap(find.byKey(const ValueKey('loginButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));

    expect(
      find.text('Those credentials do not match our demo user.'),
      findsOneWidget,
    );
  });
}
