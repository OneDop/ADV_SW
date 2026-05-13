import 'package:flutter/material.dart';

class ProjectBreadcrumbs extends StatelessWidget {
  final String currentProject;
  const ProjectBreadcrumbs({super.key, required this.currentProject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Projects',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF40484C),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF40484C)),
        Text(
          currentProject,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF004253),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class BentoProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final double? progress;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? bottomWidget;

  const BentoProgressCard({
    super.key,
    required this.title,
    required this.value,
    this.progress,
    this.backgroundColor,
    this.textColor,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF2F4F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: textColor?.withOpacity(0.7) ?? const Color(0xFF40484C).withOpacity(0.7),
                  ),
                ),
              ),
              if (progress != null)
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF004253),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (progress != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFBFC8CC).withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF004253)),
                minHeight: 8,
              ),
            )
          else ...[
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor ?? const Color(0xFF004253),
              ),
            ),
            if (bottomWidget != null) bottomWidget!,
          ],
        ],
      ),
    );
  }
}

class KanbanTaskCard extends StatelessWidget {
  final String category;
  final String title;
  final String? date;
  final List<String> assignees;
  final bool isCompleted;
  final String? priority;
  final Color? borderColor;

  const KanbanTaskCard({
    super.key,
    required this.category,
    required this.title,
    this.date,
    this.assignees = const [],
    this.isCompleted = false,
    this.priority,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFF2F4F5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBFC8CC).withOpacity(0.1),
        ),
        boxShadow: [
          if (!isCompleted)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Stack(
        children: [
          if (borderColor != null)
            Positioned(
              left: -16,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                color: borderColor,
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isCompleted ? const Color(0xFF40484C).withOpacity(0.6) : const Color(0xFF94A3B8),
                    ),
                  ),
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.more_horiz,
                    size: 18,
                    color: isCompleted ? const Color(0xFF004253) : const Color(0xFFBFC8CC),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? const Color(0xFF191C1D).withOpacity(0.6) : const Color(0xFF191C1D),
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  fontFamily: 'Manrope',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildAssignees(),
                      if (priority != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF622E00).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            priority!,
                            style: const TextStyle(
                              color: Color(0xFF622E00),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (date != null)
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 14, color: Color(0xFFBFC8CC)),
                        const SizedBox(width: 4),
                        Text(
                          date!,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFBFC8CC),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssignees() {
    if (assignees.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 24,
      width: 24.0 + (assignees.length - 1) * 16.0,
      child: Stack(
        children: List.generate(assignees.length, (index) {
          return Positioned(
            left: index * 16.0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: DecorationImage(
                  image: NetworkImage(assignees[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
