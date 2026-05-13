import 'package:flutter/material.dart';
import 'widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Manrope',
                      color: Color(0xFF004253),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Stay updated with your latest team activity.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF40484C),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const NotificationSectionHeader(
                    title: 'Today',
                    badgeText: '3 NEW',
                  ),
                  NotificationCard(
                    title: 'Deadline Reminder',
                    time: '2h ago',
                    icon: Icons.event_busy,
                    iconBgColor: const Color(0xFFFFDCC6),
                    iconColor: const Color(0xFF622E00),
                    borderColor: const Color(0xFF622E00),
                    isUnread: true,
                    backgroundColor: Colors.white,
                    content: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Color(0xFF536772)),
                        children: [
                          TextSpan(
                            text: 'Final PDF Export',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004253),
                            ),
                          ),
                          TextSpan(text: ' is due today. Review requirements before submission.'),
                        ],
                      ),
                    ),
                    action: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF622E00),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        'Review Task',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  NotificationCard(
                    title: 'Team Activity',
                    time: '4h ago',
                    icon: Icons.group_add,
                    iconBgColor: const Color(0xFFD0E6F3),
                    iconColor: const Color(0xFF4D616C),
                    isUnread: true,
                    backgroundColor: Colors.white,
                    content: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Color(0xFF536772)),
                        children: [
                          TextSpan(
                            text: 'Marcus V.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004253),
                            ),
                          ),
                          TextSpan(text: ' joined '),
                          TextSpan(
                            text: 'Aris Brand Identity',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          TextSpan(text: ' project.'),
                        ],
                      ),
                    ),
                  ),
                  NotificationCard(
                    title: 'Project Update',
                    time: '5h ago',
                    icon: Icons.chat_bubble,
                    iconBgColor: const Color(0xFFB7EAFF).withOpacity(0.2),
                    iconColor: const Color(0xFF004253),
                    isUnread: true,
                    backgroundColor: Colors.white,
                    content: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Color(0xFF536772)),
                        children: [
                          TextSpan(
                            text: 'Sarah Miller',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004253),
                            ),
                          ),
                          TextSpan(text: ' commented on '),
                          TextSpan(
                            text: 'Hero Section v2',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(text: ': "The gradients look much cleaner now!"'),
                        ],
                      ),
                    ),
                  ),
                  const NotificationSectionHeader(title: 'Earlier'),
                  Opacity(
                    opacity: 0.8,
                    child: Column(
                      children: [
                        NotificationCard(
                          title: 'Status Update',
                          time: 'Yesterday',
                          icon: Icons.check_circle,
                          iconBgColor: const Color(0xFFE1E3E4),
                          iconColor: const Color(0xFF40484C),
                          backgroundColor: const Color(0xFFF2F4F5),
                          content: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 14, color: Color(0xFF536772)),
                              children: [
                                const TextSpan(text: 'Project '),
                                const TextSpan(
                                  text: 'Nexus Slate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF004253),
                                  ),
                                ),
                                const TextSpan(text: ' status changed to '),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF004253).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'IN REVIEW',
                                      style: TextStyle(
                                        color: Color(0xFF004253),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                        NotificationCard(
                          title: 'New Assignment',
                          time: '2 days ago',
                          icon: Icons.assignment_turned_in,
                          iconBgColor: const Color(0xFFE1E3E4),
                          iconColor: const Color(0xFF40484C),
                          backgroundColor: const Color(0xFFF2F4F5),
                          content: RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 14, color: Color(0xFF536772)),
                              children: [
                                TextSpan(
                                  text: 'Alex Chen',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF004253),
                                  ),
                                ),
                                TextSpan(text: ' assigned you to '),
                                TextSpan(
                                  text: 'User Testing Feedback',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDepvnSKOFPqWSGmoI2mx6G7PwbXGeYPPJl2YFKkNItIbAutv4IhAbJOB2Zwl-XQkpqVDLzlmqQTqX3bxX6EhCPN1WvoumZNXjsqkdMNqvl7GVFwFGq47fbEZ0AfCuenYCY-ZtWa9u6DXrTK_UD_JoaGOq17QbEOCL1dRvQwqc4dBaG4Z4hOLC_kyWrhknU4JR0iAXfQAZo-Vgm8WVNLCLojJ1t7vsRiaBwIJIhVyoWd7lCwE5ERI_JHOhWxKaMx3F-d2KFYfl-_0Q'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'The Quiet Engine',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
              color: Color(0xFF004253),
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Color(0xFF001F28)),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            hoverColor: Colors.black12,
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF19667D).withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, 'Studio', isSelected: false),
          _buildNavItem(Icons.assignment, 'Tasks', isSelected: false),
          _buildNavItem(Icons.notifications, 'Updates', isSelected: true),
          _buildNavItem(Icons.settings, 'Settings', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFB7EAFF).withOpacity(0.4) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: isSelected ? const Color(0xFF004253) : const Color(0xFF70787D),
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isSelected ? const Color(0xFF004253) : const Color(0xFF70787D),
          ),
        ),
      ],
    );
  }
}
