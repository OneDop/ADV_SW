import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/auth_provider.dart';
import 'widgets.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  String? _error;

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    setState(() => _error = null);
    final firstName = _firstNameCtrl.text.trim();
    final lastName  = _lastNameCtrl.text.trim();
    final email     = _emailCtrl.text.trim();
    final password  = _passwordCtrl.text;

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = 'All fields are required.');
      return;
    }
    if (password.length < 8) {
      setState(() => _error = 'Password must be at least 8 characters.');
      return;
    }

    final success = await ref.read(authProvider.notifier).signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      setState(() => _error = 'Signup failed. This email may already be in use.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _BackBtn(onTap: () => context.go('/login')),
                  const SizedBox(width: 12),
                  const Text(
                    'Create your account',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.3),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.lineSoft),
                  boxShadow: AppTheme.shadowLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AuthField(label: 'FIRST NAME', hint: 'Alex',   icon: Icons.person_outline_rounded, controller: _firstNameCtrl)),
                        const SizedBox(width: 10),
                        Expanded(child: AuthField(label: 'LAST NAME',  hint: 'Rivera', icon: Icons.person_outline_rounded, controller: _lastNameCtrl)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AuthField(label: 'EMAIL', hint: 'you@work.com', icon: Icons.mail_outline_rounded, controller: _emailCtrl),
                    const SizedBox(height: 16),
                    AuthField(label: 'PASSWORD', hint: '••••••••', icon: Icons.lock_outline_rounded, controller: _passwordCtrl, isPassword: true),
                    const SizedBox(height: 8),
                    const Text('At least 8 characters', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600)),
                    ],
                    const SizedBox(height: 24),
                    PrimaryBtn(
                      label: 'Create account',
                      trailing: Icons.check_rounded,
                      loading: ref.watch(authProvider).isLoading,
                      onPressed: ref.watch(authProvider).isLoading ? null : _handleSignup,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(fontSize: 13, color: AppColors.ink500)),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: const Text('Sign in', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.teal700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _BackBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
        ),
        child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink900),
      ),
    );
  }
}
