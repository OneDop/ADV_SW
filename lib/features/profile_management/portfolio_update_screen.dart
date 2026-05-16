import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/providers/user_provider.dart';

/// PortfolioUpdateScreen - Screen to update portfolio information
/// Allows users to add past projects and specify experience level (FR11, FR12)
class PortfolioUpdateScreen extends ConsumerStatefulWidget {
  const PortfolioUpdateScreen({super.key});

  @override
  ConsumerState<PortfolioUpdateScreen> createState() =>
      _PortfolioUpdateScreenState();
}

class _PortfolioUpdateScreenState extends ConsumerState<PortfolioUpdateScreen> {
  ExperienceLevel _experienceLevel = ExperienceLevel.BEGINNER;
  final List<PastProjectResponse> _pastProjects = [];
  final _projectNameController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _projectLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  void _loadExistingData() {
    final profile = ref.read(userProfileProvider).value;
    if (profile != null) {
      setState(() {
        _experienceLevel = profile.experienceLevel ?? ExperienceLevel.BEGINNER;
        _pastProjects.clear();
        _pastProjects.addAll(profile.pastProjects);
      });
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectDescriptionController.dispose();
    _projectLinkController.dispose();
    super.dispose();
  }

  void _addProject() {
    if (_projectNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a project name')),
      );
      return;
    }

    setState(() {
      _pastProjects.add(
        PastProjectResponse(
          name: _projectNameController.text,
          description: _projectDescriptionController.text,
          projectLink: _projectLinkController.text.isNotEmpty
              ? _projectLinkController.text
              : null,
        ),
      );
    });

    _projectNameController.clear();
    _projectDescriptionController.clear();
    _projectLinkController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project added to list')),
    );
  }

  void _removeProject(int index) {
    setState(() => _pastProjects.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project removed')),
    );
  }

  void _savePortfolio() async {
    try {
      final request = UpdatePortfolioRequest(
        experienceLevel: _experienceLevel,
        pastProjects: _pastProjects.map((p) => p.toJson()).toList(),
      );
      
      await ref.read(userProfileProvider.notifier).updatePortfolio(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Portfolio updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Update Portfolio',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: AppColors.ink900)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink900),
        actions: [
          TextButton(
            onPressed: _savePortfolio,
            child: Text('Save',
                style: GoogleFonts.inter(
                  color: AppColors.teal700,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Experience Level Section (FR12)
            _buildSectionCard(
              title: 'Experience Level',
              subtitle: 'Specify your professional experience',
              child: Column(
                children: [
                  DropdownButtonFormField<ExperienceLevel>(
                    value: _experienceLevel,
                    items: ExperienceLevel.values.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Row(
                          children: [
                            Icon(_getIconForLevel(level), size: 18, color: AppColors.teal700),
                            const SizedBox(width: 8),
                            Text(level.name[0] + level.name.substring(1).toLowerCase()),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _experienceLevel = val);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
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
                  const SizedBox(height: 12),
                  _buildExperienceLevelDescription(_experienceLevel),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Past Projects Section (FR11)
            _buildSectionCard(
              title: 'Past Projects',
              subtitle: 'Add projects you have worked on',
              child: Column(
                children: [
                  // Add Project Form
                  _buildProjectFormField(
                    controller: _projectNameController,
                    label: 'Project Name',
                    hint: 'e.g., Mobile App Development',
                    icon: Icons.folder_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildProjectFormField(
                    controller: _projectDescriptionController,
                    label: 'Description',
                    hint: 'What did you build?',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _buildProjectFormField(
                    controller: _projectLinkController,
                    label: 'Project Link (Optional)',
                    hint: 'e.g., github.com/your-project',
                    icon: Icons.link_outlined,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addProject,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Project'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal700,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (_pastProjects.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Divider(color: AppColors.lineSoft),
                    const SizedBox(height: 16),
                    Text(
                      'Your Projects (${_pastProjects.length})',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _pastProjects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildProjectCard(index),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.teal50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.teal100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.teal700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your portfolio helps other users understand your experience and past work.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.teal700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Bottom padding for scroll
          ],
        ),
      ),
    );
  }

  IconData _getIconForLevel(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.BEGINNER: return Icons.star_outline;
      case ExperienceLevel.INTERMEDIATE: return Icons.star_half;
      case ExperienceLevel.ADVANCED: return Icons.star;
      case ExperienceLevel.EXPERT: return Icons.workspace_premium;
    }
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.ink900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.ink500,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildProjectFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.teal700, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.teal700),
        ),
      ),
    );
  }

  Widget _buildProjectCard(int index) {
    final project = _pastProjects[index];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink900,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.ink400, size: 20),
                onPressed: () => _removeProject(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (project.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              project.description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.ink500,
              ),
            ),
          ],
          if (project.projectLink != null &&
              project.projectLink!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.link, size: 14, color: AppColors.teal700),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    project.projectLink!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.teal700,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExperienceLevelDescription(ExperienceLevel level) {
    String description;
    switch (level) {
      case ExperienceLevel.BEGINNER:
        description = 'New to the field, learning and building foundations';
        break;
      case ExperienceLevel.INTERMEDIATE:
        description = 'Some experience, can handle most tasks independently';
        break;
      case ExperienceLevel.ADVANCED:
        description = 'Extensive experience, can mentor and lead projects';
        break;
      case ExperienceLevel.EXPERT:
        description = 'Mastery level, industry knowledge and best practices';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.teal100),
      ),
      child: Text(
        description,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: AppColors.teal700,
          height: 1.4,
        ),
      ),
    );
  }
}
