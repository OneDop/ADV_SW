import 'package:flutter/material.dart';
import 'package:advsw/features/project_management/project_members_screen.dart';

/// MemberManagementScreen - Screen for project owners to manage members (FR20, FR21)
/// Allows changing member roles and removing members from projects.
class MemberManagementScreen extends StatelessWidget {
  final int projectId;
  final String projectName;

  const MemberManagementScreen({
    super.key,
    required this.projectId,
    this.projectName = 'Project Members',
  });

  @override
  Widget build(BuildContext context) {
    return ProjectMembersScreen(projectId: projectId);
  }
}
