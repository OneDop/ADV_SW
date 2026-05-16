import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';

class RootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const RootScreen({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Navigation items mapping exactly to app_router.dart StatefulShellBranch indices
    const items = [
      (Icons.home_rounded,          Icons.home_outlined,          'Home'),
      (Icons.explore_rounded,       Icons.explore_outlined,       'Discover'),
      (Icons.search_rounded,        Icons.search_outlined,        'Search'),
      (Icons.person_rounded,        Icons.person_outline_rounded, 'Profile'),
      (Icons.notifications_rounded, Icons.notifications_none_rounded, 'Inbox'),
    ];

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(top: BorderSide(color: AppColors.teal700.withValues(alpha: 0.08))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final active = currentIndex == i;
                return _NavItem(
                  iconFilled:   items[i].$1,
                  iconOutlined: items[i].$2,
                  label:        items[i].$3,
                  active:       active,
                  onTap:        () => onTap(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData iconFilled;
  final IconData iconOutlined;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.iconFilled,
    required this.iconOutlined,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: active ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.teal700 : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: active
              ? [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? iconFilled : iconOutlined,
              size: 22,
              color: active ? Colors.white : AppColors.ink400,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: active
                  ? Row(children: [
                      const SizedBox(width: 6),
                      Text(label,
                        style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white,
                        )),
                    ])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
