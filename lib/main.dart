import 'package:flutter/material.dart';

void main() {
  runApp(const LoginSimApp());
}

class LoginSimApp extends StatelessWidget {
  const LoginSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Simulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: FakeAuthService.demoEmail);
  final _passwordController =
      TextEditingController(text: FakeAuthService.demoPassword);

  final FakeAuthService _authService = FakeAuthService();

  bool _isSubmitting = false;
  bool _wasSuccessful = false;
  String? _statusMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isSubmitting = true;
      _statusMessage = 'Checking credentials...';
      _wasSuccessful = false;
    });

    try {
      final welcome = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      setState(() {
        _wasSuccessful = true;
        _statusMessage = welcome;
      });
    } on AuthFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _wasSuccessful = false;
        _statusMessage = e.message;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter your email address';
    }
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Provide a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    }
    if (value.length < 8) {
      return 'Must be at least 8 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Simulator'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Practice email/password authentication UI without a backend.',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Submit with the provided demo credentials to trigger a success '
                  'state or tweak them to explore validation and error handling.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            key: const ValueKey('emailField'),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                            validator: _validateEmail,
                            enabled: !_isSubmitting,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            key: const ValueKey('passwordField'),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            obscureText: true,
                            validator: _validatePassword,
                            enabled: !_isSubmitting,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            key: const ValueKey('loginButton'),
                            onPressed: _isSubmitting ? null : _submit,
                            icon: _isSubmitting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.arrow_forward),
                            label: Text(
                              _isSubmitting ? 'Signing in...' : 'Sign in',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                StatusMessage(
                  message: _statusMessage,
                  wasSuccessful: _wasSuccessful,
                ),
                const SizedBox(height: 16),
                DemoCredentialsCard(
                  email: FakeAuthService.demoEmail,
                  password: FakeAuthService.demoPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusMessage extends StatelessWidget {
  const StatusMessage({
    super.key,
    required this.message,
    required this.wasSuccessful,
  });

  final String? message;
  final bool wasSuccessful;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: message == null
          ? const SizedBox.shrink()
          : Container(
              key: const ValueKey('statusMessage'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: wasSuccessful
                    ? theme.colorScheme.secondaryContainer
                    : theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: wasSuccessful
                      ? theme.colorScheme.onSecondaryContainer
                      : theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
    );
  }
}

class DemoCredentialsCard extends StatelessWidget {
  const DemoCredentialsCard({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demo Credentials',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _CredentialRow(
              label: 'Email',
              value: email,
            ),
            const SizedBox(height: 6),
            _CredentialRow(
              label: 'Password',
              value: password,
            ),
            const SizedBox(height: 12),
            Text(
              'Change either field to explore validation errors or failed login states.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  const _CredentialRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: theme.textTheme.labelMedium,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class FakeAuthService {
  static const demoEmail = 'demo@flutter.dev';
  static const demoPassword = 'FlutterR0cks!';

  Future<String> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      throw const AuthFailure('Please fill in both fields.');
    }
    if (!trimmedEmail.contains('@') || !trimmedEmail.contains('.')) {
      throw const AuthFailure('Enter a valid email address.');
    }

    if (trimmedEmail.toLowerCase() == demoEmail &&
        password == demoPassword) {
      return 'Welcome back, Flutter Friend!';
    }

    throw const AuthFailure(
      'Those credentials do not match our demo user.',
    );
  }
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;
}
