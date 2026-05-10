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
      margin: const EdgeInsets.only(bottom: 16),
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF004253), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Manrope',
                        color: Color(0xFF004253),
                      ),
                    ),
                    const SizedBox(height: 4),
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
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004253),
                    ),
                  ),
                  const Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF40484C),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE7E8E9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF004253)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
