import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _step = 1;

  // Step 1
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();

  // Step 2
  String _role = 'Designer';
  String _experience = 'Mid-level';
  final List<String> _skills = ['Figma'];

  static const _suggestedSkills = [
    'Figma', 'Flutter', 'Spring Boot', 'React', 'TypeScript',
    'Product Design', 'UX', 'Kotlin', 'PostgreSQL', 'Java',
  ];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgAlt,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + step header
              Row(
                children: [
                  _BackBtn(onTap: () {
                    if (_step > 1) setState(() => _step--);
                    else context.go('/login');
                  }),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STEP $_step OF 2',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: AppColors.ink500),
                        ),
                        Text(
                          _step == 1 ? 'Create your account' : 'Tell us about you',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.lineSoft),
                  boxShadow: AppTheme.shadowLg,
                ),
                child: _step == 1 ? _buildStep1() : _buildStep2(),
              ),

              if (_step == 1) ...[
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
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
        const SizedBox(height: 24),
        PrimaryBtn(label: 'Continue', trailing: Icons.arrow_forward_rounded, onPressed: () => setState(() => _step = 2)),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthField(label: 'HEADLINE / ROLE', hint: 'e.g. Flutter Developer', icon: Icons.badge_outlined, controller: TextEditingController(text: _role)),
        const SizedBox(height: 20),

        const FieldLabel('EXPERIENCE LEVEL'),
        Row(
          children: ['Junior', 'Mid-level', 'Senior'].map((x) {
            final sel = _experience == x;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _experience = x),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.teal50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: sel ? AppColors.teal700 : AppColors.line),
                  ),
                  child: Text(x, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? AppColors.teal700 : AppColors.ink700)),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        const FieldLabel('SKILLS'),
        const SizedBox(height: 4),
        const Text('Tap to add — these power Discover', style: TextStyle(fontSize: 11, color: AppColors.ink500)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6, runSpacing: 8,
          children: _suggestedSkills.map((s) {
            final sel = _skills.contains(s);
            return _SkillChip(
              label: s,
              selected: sel,
              onTap: () => setState(() {
                if (sel) _skills.remove(s); else _skills.add(s);
              }),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),
        PrimaryBtn(label: 'Create account', trailing: Icons.check_rounded, onPressed: () => context.go('/home')),
      ],
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

class _SkillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SkillChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.teal700 : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.teal700 : AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? Icons.check_rounded : Icons.add_rounded, size: 13, color: selected ? Colors.white : AppColors.ink700),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.ink700)),
          ],
        ),
      ),
    );
  }
}
