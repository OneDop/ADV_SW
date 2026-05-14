import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController(text: 'alex.rivera@quietengine.io');
  final _passwordCtrl = TextEditingController(text: 'demo1234');
  bool _remember = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
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
              children: [
                const SizedBox(height: 16),
                // Logo + branding
                const AppLogo(size: 60),
                const SizedBox(height: 14),
                const Text(
                  'ProjectPal',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink900,
                    letterSpacing: -0.02 * 30,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pair up, ship together.',
                  style: TextStyle(fontSize: 13, color: AppColors.ink500),
                ),
                const SizedBox(height: 28),

                // Card
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
                      AuthField(
                        label: 'EMAIL',
                        hint: 'you@work.com',
                        icon: Icons.mail_outline_rounded,
                        controller: _emailCtrl,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PASSWORD',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('Forgot?', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.teal700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AuthField(
                        label: '',
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        controller: _passwordCtrl,
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),

                      // Remember me
                      GestureDetector(
                        onTap: () => setState(() => _remember = !_remember),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 18, height: 18,
                              decoration: BoxDecoration(
                                color: _remember ? AppColors.teal700 : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: _remember ? AppColors.teal700 : AppColors.ink300, width: 1.5),
                              ),
                              child: _remember
                                  ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            const Text('Keep me signed in', style: TextStyle(fontSize: 12, color: AppColors.ink700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      PrimaryBtn(
                        label: 'Sign in',
                        trailing: Icons.arrow_forward_rounded,
                        onPressed: () => context.go('/home'),
                      ),
                      const SizedBox(height: 20),

                      // OR divider
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.line)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('OR CONTINUE WITH', style: TextStyle(fontSize: 10, color: AppColors.ink400, letterSpacing: 0.8)),
                          ),
                          const Expanded(child: Divider(color: AppColors.line)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(child: SocialBtn(label: 'Google', icon: Icons.g_mobiledata_rounded, onPressed: () => context.go('/home'))),
                          const SizedBox(width: 10),
                          Expanded(child: SocialBtn(label: 'Apple', icon: Icons.apple_rounded, onPressed: () => context.go('/home'))),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New to ProjectPal? ', style: TextStyle(fontSize: 13, color: AppColors.ink500)),
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: const Text('Create an account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.teal700)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
