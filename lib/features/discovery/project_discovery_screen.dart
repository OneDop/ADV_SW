import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/search_provider.dart';
import 'package:advsw/providers/invitation_provider.dart';
import 'package:advsw/models/search_model.dart';

class ProjectDiscoveryScreen extends ConsumerWidget {
  const ProjectDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Projects',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: Column(
        children: [
          AnimatedPadding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
              onChanged: (val) => ref.read(projectSearchProvider.notifier).searchProjects(name: val),
              decoration: InputDecoration(
                hintText: 'Search for projects...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.line),
                ),
              ),
            ),
          ),
          ),
          Expanded(
            child: projectsAsync.when(
              data: (projects) => projects.isEmpty 
                ? const Center(child: Text('No projects found'))
                : RefreshIndicator(
                    onRefresh: () => ref.read(projectSearchProvider.notifier).clear(),
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).padding.bottom + 16),
                      itemCount: projects.length,
                      itemBuilder: (context, index) => ProjectDiscoveryCard(project: projects[index]),
                    ),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectDiscoveryCard extends ConsumerWidget {
  final SearchProjectResult project;
  const ProjectDiscoveryCard({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(project.name, 
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink900)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(project.status, 
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(project.description, 
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink500)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(userInvitationsProvider.notifier).sendJoinRequest(project.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Join request sent to ${project.name}')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to send request: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal700,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Request to Join'),
            ),
          ),
        ],
      ),
    );
  }
}
