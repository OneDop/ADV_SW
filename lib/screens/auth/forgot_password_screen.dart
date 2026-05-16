import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() { _loading = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgAlt,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthField(
          label: 'EMAIL',
          hint: 'you@work.com',
          icon: Icons.mail_outline_rounded,
          controller: _emailCtrl,
        ),
        const SizedBox(height: 24),
        _loading
            ? const Center(child: CircularProgressIndicator())
            : PrimaryBtn(
                label: 'Send reset link',
                trailing: Icons.send_rounded,
                onPressed: _submit,
              ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => context.pop(),
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
        const Text("We've sent a password reset link to your email. It expires in 15 minutes.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.ink500, height: 1.5)),
        const SizedBox(height: 24),
        PrimaryBtn(label: 'Back to sign in', onPressed: () => context.go('/login')),
      ],
    );
  }
}
