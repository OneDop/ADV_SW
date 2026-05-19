import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/auth_provider.dart';
import 'widgets.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _tokenCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    final token = _tokenCtrl.text.trim();
    final newPassword = _passwordCtrl.text;
    final confirmPassword = _confirmPasswordCtrl.text;

    if (token.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => _error = 'All fields are required.');
      return;
    }
    if (newPassword.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }
    if (newPassword != confirmPassword) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    final success = await ref.read(authProvider.notifier).resetPassword(token, newPassword);
    if (!mounted) return;

    if (success) {
      setState(() => _success = true);
    } else {
      setState(() => _error = 'Invalid or expired token. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.6, -1.2),
            radius: 1.4,
            colors: [Color(0xFFE8F2F8), AppColors.bgAlt],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink900),
                  ),
                ),
                const SizedBox(height: 28),
                const AppLogo(size: 52),
                const SizedBox(height: 16),
                const Text('Reset Password',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                const SizedBox(height: 6),
                const Text('Enter the reset token and your new password.',
                  style: TextStyle(fontSize: 13, color: AppColors.ink500)),
                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.lineSoft),
                    boxShadow: AppTheme.shadowLg,
                  ),
                  child: _success ? _buildSuccess() : _buildForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final isLoading = ref.watch(authProvider).isLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthField(
          label: 'RESET TOKEN',
          hint: 'Paste your reset token',
          icon: Icons.key_outlined,
          controller: _tokenCtrl,
        ),
        const SizedBox(height: 20),
        AuthField(
          label: 'NEW PASSWORD',
          hint: 'At least 6 characters',
          icon: Icons.lock_outline_rounded,
          controller: _passwordCtrl,
          isPassword: true,
        ),
        const SizedBox(height: 20),
        AuthField(
          label: 'CONFIRM PASSWORD',
          hint: 'Re-enter your password',
          icon: Icons.lock_outline_rounded,
          controller: _confirmPasswordCtrl,
          isPassword: true,
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600)),
        ],
        const SizedBox(height: 24),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : PrimaryBtn(
                label: 'Reset Password',
                trailing: Icons.check_circle_rounded,
                onPressed: isLoading ? null : _submit,
              ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => context.go('/login'),
            child: const Text('Back to sign in',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.teal700)),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      children: [
        Container(
          width: 64, height: 64,
          decoration: const BoxDecoration(color: AppColors.teal50, shape: BoxShape.circle),
          child: const Icon(Icons.lock_reset_rounded, size: 32, color: AppColors.teal700),
        ),
        const SizedBox(height: 16),
        const Text('Password Reset!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900)),
        const SizedBox(height: 8),
        const Text('Your password has been updated. You can now sign in with your new password.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.ink500, height: 1.5)),
        const SizedBox(height: 24),
        PrimaryBtn(label: 'Sign in', onPressed: () => context.go('/login')),
      ],
    );
  }
}
