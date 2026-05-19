import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/auth_provider.dart';
import 'widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;
  String? _error;
  String? _message;
  String? _resetToken;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _message = null;
      _resetToken = null;
    });
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Email is required.');
      return;
    }

    final result = await ref.read(authProvider.notifier).forgotPassword(email);
    if (!mounted) return;

    if (result != null) {
      setState(() {
        _sent = true;
        _message = result['message'] as String? ?? 'Password reset token generated. Use it within 15 minutes.';
        _resetToken = result['resetToken'] as String?;
      });
    } else {
      setState(() => _error = 'Failed to send reset link. Please try again.');
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
                const Text('Reset your password',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                const SizedBox(height: 6),
                const Text("Enter your email and we'll send you a reset link.",
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
                  child: _sent ? _buildSuccess() : _buildForm(),
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
          label: 'EMAIL',
          hint: 'you@work.com',
          icon: Icons.mail_outline_rounded,
          controller: _emailCtrl,
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600)),
        ],
        const SizedBox(height: 24),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : PrimaryBtn(
                label: 'Send reset link',
                trailing: Icons.send_rounded,
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
          child: const Icon(Icons.mark_email_read_rounded, size: 32, color: AppColors.teal700),
        ),
        const SizedBox(height: 16),
        const Text('Check your inbox',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink900)),
        const SizedBox(height: 8),
        Text(
          _message ?? "We've sent a password reset link to your email. It expires in 15 minutes.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: AppColors.ink500, height: 1.5),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your reset token:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink500, letterSpacing: 0.5),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _resetToken ?? 'Token will appear here',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink900,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  if (_resetToken != null)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _resetToken!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token copied to clipboard'), duration: Duration(seconds: 2)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.teal50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.copy_rounded, size: 16, color: AppColors.teal700),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        PrimaryBtn(
          label: 'Reset password',
          trailing: Icons.lock_reset_rounded,
          onPressed: () => context.push('/reset-password'),
        ),
        const SizedBox(height: 12),
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
}
