import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/models/project_model.dart';
import 'package:advsw/providers/project_provider.dart';
import 'package:advsw/services/api_client.dart';

class ProjectMembersScreen extends ConsumerWidget {
  final int projectId;

  const ProjectMembersScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(projectMembersProvider(projectId));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Project Members', 
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.ink900)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink900),
        actions: [
          IconButton(
            onPressed: () => ref.read(projectMembersProvider(projectId).notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: membersAsync.when(
        data: (members) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: members.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final member = members[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lineSoft),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.teal100,
                    backgroundImage: ApiClient.buildImageUrl(member.profilePictureUrl) != null ? NetworkImage(ApiClient.buildImageUrl(member.profilePictureUrl)!) : null,
                    child: member.profilePictureUrl == null 
                      ? Text(member.firstName.isNotEmpty ? member.firstName[0] : '?', 
                          style: const TextStyle(color: AppColors.teal700, fontWeight: FontWeight.bold))
                      : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${member.firstName} ${member.lastName}', 
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.ink900)),
                        Text(member.memberRole.name, 
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.ink500)),
                      ],
                    ),
                  ),
                  // Project Owners can manage others (FR20, FR21)
                  // In a real app, we'd check the current user's role in the project.
                  // For now, we allow management if not the owner being managed.
                  if (member.memberRole != MemberRole.OWNER)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: AppColors.ink400),
                      onSelected: (value) {
                        if (value == 'change_role') {
                          _showChangeRoleDialog(context, ref, member);
                        } else if (value == 'remove') {
                          _showRemoveConfirmation(context, ref, member);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'change_role', child: Text('Change Role')),
                        const PopupMenuItem(value: 'remove', child: Text('Remove Member', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showChangeRoleDialog(BuildContext context, WidgetRef ref, ProjectMemberResponse member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Role'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: MemberRole.values.map((role) {
            return ListTile(
              title: Text(role.name),
              trailing: member.memberRole == role ? const Icon(Icons.check, color: AppColors.teal700) : null,
              onTap: () async {
                await ref.read(projectMembersProvider(projectId).notifier).updateMemberRole(
                  member.userId, 
                  UpdateMemberRoleRequest(memberRole: role)
                );
                if (context.mounted) Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context, WidgetRef ref, ProjectMemberResponse member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove ${member.firstName} from the project?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(projectMembersProvider(projectId).notifier).removeMember(member.userId);
              if (context.mounted) Navigator.pop(context);
            }, 
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
