import 'package:flutter/material.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifs;

  @override
  void initState() {
    super.initState();
    _notifs = List.from(SeedData.notifications);
  }

  void _dismiss(String id) => setState(() => _notifs.removeWhere((n) => n.id == id));
  void _clearAll() => setState(() => _notifs.clear());

  List<AppNotification> get _today => _notifs
      .where((n) => n.meta.contains('ago') || n.meta.contains('m ago') || n.meta.contains('h ago'))
      .toList();

  List<AppNotification> get _earlier => _notifs
      .where((n) => !n.meta.contains('ago') || n.meta.contains('Yesterday'))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Updates', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.4)),
                  Text('${_notifs.length} new', style: const TextStyle(fontSize: 11, color: AppColors.ink500)),
                ])),
                GestureDetector(
                  onTap: _clearAll,
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.line), boxShadow: AppTheme.shadowSm,
                    ),
                    child: const Icon(Icons.done_all_rounded, size: 20, color: AppColors.ink700),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _notifs.isEmpty
                ? _EmptyState()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                    children: [
                      if (_today.isNotEmpty) ...[
                        _GroupLabel('Today'),
                        ..._today.map((n) => _NotifItem(n: n, onDismiss: () => _dismiss(n.id), onAction: () => _dismiss(n.id))),
                      ],
                      if (_earlier.isNotEmpty) ...[
                        _GroupLabel('Earlier'),
                        ..._earlier.map((n) => _NotifItem(n: n, onDismiss: () => _dismiss(n.id), onAction: () => _dismiss(n.id))),
                      ],
                    ],
                  ),
          ),
        ]),
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  final String label;
  const _GroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(label.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500)),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final AppNotification n;
  final VoidCallback onDismiss;
  final VoidCallback onAction;

  const _NotifItem({required this.n, required this.onDismiss, required this.onAction});

  ({Color bg, Color fg}) get _tone {
    switch (n.type) {
      case 'deadline': return (bg: AppColors.warm100,    fg: AppColors.warm700);
      case 'task':     return (bg: AppColors.teal50,     fg: AppColors.teal700);
      case 'message':  return (bg: const Color(0xFFE8F4FA), fg: const Color(0xFF0E5B85));
      default:         return (bg: const Color(0xFFF1ECFB), fg: const Color(0xFF5A399E));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = _tone;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: t.bg, borderRadius: BorderRadius.circular(12)),
          child: Icon(n.icon, size: 18, color: t.fg),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(n.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink900)),
          const SizedBox(height: 2),
          Text(n.body, style: const TextStyle(fontSize: 12, color: AppColors.ink700, height: 1.4)),
          const SizedBox(height: 6),
          Text(n.meta, style: const TextStyle(fontSize: 10, color: AppColors.ink500)),
          if (n.actionable) ...[
            const SizedBox(height: 10),
            Row(children: [
              _ActionBtn(label: 'Accept', onTap: onAction),
              const SizedBox(width: 8),
              _ActionBtn(label: 'Decline', onTap: onDismiss, secondary: true),
            ]),
          ],
        ])),
        GestureDetector(
          onTap: onDismiss,
          child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.close_rounded, size: 16, color: AppColors.ink400)),
        ),
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool secondary;
  const _ActionBtn({required this.label, required this.onTap, this.secondary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondary ? Colors.white : AppColors.teal700,
          border: secondary ? Border.all(color: AppColors.line) : null,
          gradient: secondary ? null : AppTheme.primaryGradient,
          boxShadow: secondary ? null : [BoxShadow(color: AppColors.teal700.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: secondary ? AppColors.ink700 : Colors.white)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 56, height: 56,
          decoration: const BoxDecoration(color: AppColors.teal50, shape: BoxShape.circle),
          child: const Icon(Icons.notifications_off_outlined, size: 28, color: AppColors.teal700),
        ),
        const SizedBox(height: 12),
        const Text('All caught up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink900)),
        const SizedBox(height: 6),
        const Text("You'll see new assignments,\nmentions and deadlines here.",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.ink500)),
      ]),
    );
  }
}
