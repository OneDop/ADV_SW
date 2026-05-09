import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String name;
  final String status;
  final double progress;
  final IconData icon;
  final Color iconBgColor;

  const ProjectCard({
    super.key,
    required this.name,
    this.status = "In Progress",
    this.progress = 0.65,
    this.icon = Icons.architecture,
    this.iconBgColor = const Color(0xFFD0E6F3),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF004253), size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status == "In Progress" ? const Color(0xFF854000) : const Color(0xFFD0E6F3),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: status == "In Progress" ? Colors.white : const Color(0xFF004253),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Manrope',
              color: Color(0xFF004253),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF40484C),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF40484C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFE7E8E9),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF004253)),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String name;
  final String? description;
  final IconData icon;
  final Color iconBgColor;

  const TaskCard({
    super.key,
    required this.name,
    this.description,
    this.icon = Icons.description,
    this.iconBgColor = const Color(0xFFFFDCC6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF622E00),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Manrope',
                    color: Color(0xFF004253),
                  ),
                ),
                if (description != null)
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF40484C),
                    ),
                  ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFFBFC8CC),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: const Color(0xFF004253), size: 24),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                  color: Color(0xFF004253),
                ),
              ),
            ],
          ),
          if (onViewAll != null)
            InkWell(
              onTap: onViewAll,
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF40484C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (actionLabel != null)
            TextButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add, size: 16),
              label: Text(actionLabel!),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF004253),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class TitleCard extends StatelessWidget {
  final String Title;
  const TitleCard({super.key, required this.Title});

  @override
  Widget build(BuildContext context) {
    return SectionHeader(title: Title);
  }
}

class ProductivityCard extends StatelessWidget {
  const ProductivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF004253),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Productivity',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                ),
              ),
              SizedBox(height: 4),
              Text(
                '80% tasks completed this week',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  value: 0.8,
                  strokeWidth: 4,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8DD0E9)),
                ),
              ),
              const Text(
                '80%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
