import 'package:flutter/material.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String title;
  final String? badgeText;

  const NotificationSectionHeader({
    super.key,
    required this.title,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: const Color(0xFF40484C).withOpacity(0.7),
            ),
          ),
          if (badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF005B71).withOpacity(0.1),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                badgeText!,
                style: const TextStyle(
                  color: Color(0xFF004253),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final Widget content;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final bool isUnread;
  final Widget? action;
  final Color? borderColor;
  final Color backgroundColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.content,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    this.isUnread = false,
    this.action,
    this.borderColor,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null
            ? Border(left: BorderSide(color: borderColor!, width: 4))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C1D),
                        fontFamily: 'Manrope',
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF40484C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                content,
                if (action != null) ...[
                  const SizedBox(height: 12),
                  action!,
                ],
              ],
            ),
          ),
          if (isUnread) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: borderColor ?? const Color(0xFF004253),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
