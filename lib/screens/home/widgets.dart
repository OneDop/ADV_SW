import 'package:flutter/material.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/models/project_model.dart';
import 'package:advsw/models/task_model.dart';
import 'package:intl/intl.dart';

// ── Avatar (initials fallback) ─────────────────────────────────────────────────
class UserAvatar extends StatelessWidget {
  final String name;
  final double size;
  final String? status; // available | busy | offline | null
  final double ring;
  final String? imageUrl;

  const UserAvatar({
    super.key,
    required this.name,
    this.size = 40,
    this.status,
    this.ring = 0,
    this.imageUrl,
  });

  static const _palettes = [
    [Color(0xFFD0E6F3), Color(0xFF8DD0E9)],
    [Color(0xFFFFDCC6), Color(0xFFF0B68A)],
    [Color(0xFFD6EDDE), Color(0xFF9CCDB0)],
    [Color(0xFFE5D6F3), Color(0xFFB69BD9)],
    [Color(0xFFFCE3E3), Color(0xFFE5A3A3)],
  ];

  int _hash(String s) {
    int h = 0;
    for (final c in s.runes) {
      h = (h * 31 + c) & 0x7FFFFFFF;
    }
    return h;
  }

  Color _statusColor() {
    switch (status?.toLowerCase()) {
      case 'available':
      case 'online':    return const Color(0xFF3BB273);
      case 'busy':      return const Color(0xFFE08D3C);
      default:          return const Color(0xFFA3ADB5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().split(RegExp(r'\s+')).map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase();
    final pal = _palettes[_hash(name) % _palettes.length];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: imageUrl == null ? LinearGradient(colors: pal, begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
            image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
            border: ring > 0 ? Border.all(color: isDark ? AppColors.darkSurface : Colors.white, width: ring) : null,
            boxShadow: ring > 0 ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)] : null,
          ),
          child: imageUrl == null ? Center(
            child: Text(initials.isEmpty ? '?' : initials,
              style: TextStyle(
                fontSize: size * 0.36,
                fontWeight: FontWeight.w700,
                color: AppColors.ink900,
                letterSpacing: -0.02 * size * 0.36,
              )),
          ) : null,
        ),
        if (status != null)
          Positioned(
            right: -1, bottom: -1,
            child: Container(
              width: size * 0.28, height: size * 0.28,
              decoration: BoxDecoration(
                color: _statusColor(),
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? AppColors.darkSurface : Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Avatar stack ───────────────────────────────────────────────────────────────
class AvatarStack extends StatelessWidget {
  final List<dynamic> members; // Can be ProjectMemberResponse or similar
  final double size;
  final int max;

  const AvatarStack({super.key, required this.members, this.size = 28, this.max = 4});

  @override
  Widget build(BuildContext context) {
    final shown = members.take(max).toList();
    final extra = members.length - shown.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: size,
      width: size + (shown.length - 1) * size * 0.7 + (extra > 0 ? size * 0.7 : 0),
      child: Stack(
        children: [
          ...shown.asMap().entries.map((e) {
            String name = 'User';
            String? url;
            if (e.value is ProjectMemberResponse) {
              name = '${e.value.firstName} ${e.value.lastName}';
              url = e.value.profilePictureUrl;
            } else {
              name = e.value.toString();
            }
            return Positioned(
              left: e.key * size * 0.7,
              child: UserAvatar(name: name, size: size, ring: 2, imageUrl: url),
            );
          }),
          if (extra > 0)
            Positioned(
              left: shown.length * size * 0.7,
              child: Container(
                width: size, height: size,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : AppColors.line,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? AppColors.darkSurface : Colors.white, width: 2),
                ),
                child: Center(
                  child: Text('+$extra', style: TextStyle(fontSize: size * 0.32, fontWeight: FontWeight.w700, color: isDark ? Colors.white70 : AppColors.ink700)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface, letterSpacing: -0.2)),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ),
        ],
      ),
    );
  }
}

// ── Progress bar ───────────────────────────────────────────────────────────────
class ProgressBar extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;

  const ProgressBar({super.key, required this.value, this.color, this.height = 6});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: isDark ? Colors.white12 : AppColors.line,
        valueColor: AlwaysStoppedAnimation(color ?? AppColors.teal700),
      ),
    );
  }
}

// ── Project card (horizontal scroll) ──────────────────────────────────────────
class ProjectCard extends StatelessWidget {
  final ProjectResponse project;
  final VoidCallback? onTap;
  final bool wide;

  const ProjectCard({super.key, required this.project, this.onTap, this.wide = false});

  Color get _statusBg {
    switch (project.status) {
      case ProjectStatus.IN_PROGRESS: return AppColors.warm100;
      case ProjectStatus.COMPLETED:   return AppColors.success100;
      case ProjectStatus.OPEN:        return AppColors.teal50;
      case ProjectStatus.CANCELLED:   return AppColors.ink300;
    }
  }

  Color get _statusFg {
    switch (project.status) {
      case ProjectStatus.IN_PROGRESS: return AppColors.warm700;
      case ProjectStatus.COMPLETED:   return AppColors.success700;
      case ProjectStatus.OPEN:        return AppColors.teal700;
      case ProjectStatus.CANCELLED:   return AppColors.ink700;
    }
  }

  String get _statusText {
    return project.status.name.replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: wide ? null : 220,
        margin: EdgeInsets.only(right: wide ? 0 : 12, bottom: wide ? 12 : 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.lineSoft),
          boxShadow: isDark ? [] : AppTheme.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: isDark ? AppColors.teal900 : AppColors.teal50, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.architecture, size: 20, color: isDark ? AppColors.aqua : AppColors.teal700),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? _statusFg.withValues(alpha: 0.2) : _statusBg, 
                    borderRadius: BorderRadius.circular(999)
                  ),
                  child: Text(_statusText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isDark ? Colors.white : _statusFg)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(project.name,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface, letterSpacing: -0.1)),
            if (wide) ...[
              const SizedBox(height: 4),
              Text(project.description,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Owner', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                Text(project.ownerName,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
              ],
            ),
            const SizedBox(height: 6),
            const ProgressBar(value: 0.5), // Example progress
            if (wide) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(children: [
                    Icon(Icons.check_circle_outline, size: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                    const SizedBox(width: 4),
                    Text('Details',
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                  ]),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Task row ───────────────────────────────────────────────────────────────────
class TaskRow extends StatelessWidget {
  final TaskResponse task;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const TaskRow({super.key, required this.task, this.onToggle, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final done = task.status == TaskStatus.DONE;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.lineSoft),
          boxShadow: isDark ? [] : AppTheme.shadowSm,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.teal700 : Colors.transparent,
                  border: Border.all(color: done ? AppColors.teal700 : (isDark ? Colors.white24 : AppColors.ink300), width: 1.5),
                ),
                child: done ? const Icon(Icons.check_rounded, size: 13, color: Colors.white) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    )),
                  const SizedBox(height: 2),
                  Text('${DateFormat('MMM dd').format(task.deadline)} · ${task.status.name}',
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ),
            if (task.assigneeName != null)
              UserAvatar(name: task.assigneeName!, size: 22),
          ],
        ),
      ),
    );
  }
}

// ── Progress ring ──────────────────────────────────────────────────────────────
class ProgressRing extends StatelessWidget {
  final double value;
  final double size;
  final double stroke;
  final Color color;

  const ProgressRing({
    super.key,
    required this.value,
    this.size = 60,
    this.stroke = 5,
    this.color = AppColors.aqua,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(value: value, stroke: stroke, color: color),
          ),
          Text('${(value * 100).round()}%',
            style: TextStyle(fontSize: size * 0.2, fontWeight: FontWeight.w800, color: Colors.white)),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final double stroke;
  final Color color;

  const _RingPainter({required this.value, required this.stroke, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    canvas.drawArc(rect, 0, 2 * 3.141592653589793, false,
      Paint()..color = Colors.white.withValues(alpha: 0.15)..strokeWidth = stroke..style = PaintingStyle.stroke);

    canvas.drawArc(rect, -3.141592653589793 / 2, 2 * 3.141592653589793 * value, false,
      Paint()..color = color..strokeWidth = stroke..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}
