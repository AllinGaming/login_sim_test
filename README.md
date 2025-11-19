# Login Sim

Polished UI that mimics an email/password login flow backed by a fake auth
service. Use it to demonstrate form validation, async state handling, and
integration tests without wiring up a backend.

## Highlights

- Material 3 layout with constrained content card so it looks great on mobile
  and desktop widths.
- Built-in demo credentials plus contextual alerts that show success or failure
  copy.
- FakeAuthService simulates async latency and enforces simple rules so you can
  showcase optimistic UI + validation.
- Widget and integration tests drive the happy path and an error scenario.

## Demo credentials

- Email: `demo@flutter.dev`
- Password: `FlutterR0cks!`

## Run the app

```bash
flutter run
```

## Tests

```bash
# Fast widget test
flutter test

# Full integration flow
flutter test integration_test/login_flow_test.dart
```
