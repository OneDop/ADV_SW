import 'package:flutter/material.dart';
import 'package:advsw/theme/app_theme.dart';

// ── App logo ─────────────────────────────────────────────────────────────────
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.teal700.withValues(alpha: 0.25),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(Icons.hub_rounded, size: size * 0.55, color: Colors.white),
    );
  }
}

// ── Field label ───────────────────────────────────────────────────────────────
class FieldLabel extends StatelessWidget {
  final String label;
  const FieldLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.12 * 10,
          color: AppColors.ink500,
        ),
      ),
    );
  }
}

// ── Auth text field ───────────────────────────────────────────────────────────
class AuthField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? trailing;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.trailing,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _obscure = true;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(widget.label),
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _focused ? AppColors.teal700 : AppColors.line,
              ),
              boxShadow: _focused
                  ? [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.08), blurRadius: 0, spreadRadius: 4)]
                  : AppTheme.shadowSm,
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword && _obscure,
              validator: widget.validator,
              style: const TextStyle(fontSize: 14, color: AppColors.ink900),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(color: AppColors.ink400, fontSize: 14),
                prefixIcon: Icon(widget.icon, size: 18, color: AppColors.ink400),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.ink400,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      )
                    : widget.trailing,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Primary button ─────────────────────────────────────────────────────────────
class PrimaryBtn extends StatelessWidget {
  final String label;
  final IconData? trailing;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryBtn({
    super.key,
    required this.label,
    this.trailing,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.teal700.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: loading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      Icon(trailing, size: 18),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Social button (Google / Apple) ─────────────────────────────────────────────
class SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const SocialBtn({super.key, required this.label, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: AppColors.ink700),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink900)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
