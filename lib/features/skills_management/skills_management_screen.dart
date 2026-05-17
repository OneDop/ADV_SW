import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/models/skill_model.dart';
import 'package:advsw/providers/user_provider.dart';
import 'package:advsw/providers/skill_provider.dart';

class SkillsManagementScreen extends ConsumerStatefulWidget {
  const SkillsManagementScreen({super.key});

  @override
  ConsumerState<SkillsManagementScreen> createState() => _SkillsManagementScreenState();
}

class _SkillsManagementScreenState extends ConsumerState<SkillsManagementScreen> {
  ExperienceLevel _selectedLevel = ExperienceLevel.BEGINNER;
  int? _selectedSkillId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(allSkillsProvider.future);
    });
  }

  Future<void> _addSkill() async {
    if (_selectedSkillId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a skill.'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final request = AddUserSkillRequest(
        skillId: _selectedSkillId!,
        experienceLevel: _selectedLevel,
      );
      await ref.read(userProfileProvider.notifier).addSkill(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Skill added successfully!')),
        );
        setState(() {
          _selectedSkillId = null;
          _selectedLevel = ExperienceLevel.BEGINNER;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _removeSkill(int skillId, String skillName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Skill'),
        content: Text('Are you sure you want to remove "$skillName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(userProfileProvider.notifier).removeSkill(skillId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$skillName removed.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  String _formatExperienceLevel(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.BEGINNER:
        return 'Beginner';
      case ExperienceLevel.INTERMEDIATE:
        return 'Intermediate';
      case ExperienceLevel.ADVANCED:
        return 'Advanced';
      case ExperienceLevel.PROFESSIONAL:
        return 'Professional';
    }
  }

  Color _getLevelColor(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.BEGINNER:
        return Colors.blue;
      case ExperienceLevel.INTERMEDIATE:
        return Colors.orange;
      case ExperienceLevel.ADVANCED:
        return AppColors.teal700;
      case ExperienceLevel.PROFESSIONAL:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final allSkillsAsync = ref.watch(allSkillsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Manage Skills',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.ink900)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: profileAsync.when(
        data: (profile) {
          final userSkills = profile.skills;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddSkillSection(allSkillsAsync, userSkills),
                const SizedBox(height: 24),
                _buildSectionTitle('Your Skills (${userSkills.length})'),
                if (userSkills.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lineSoft),
                    ),
                    child: const Text(
                      'No skills added yet. Use the form above to add your first skill.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.ink500),
                    ),
                  )
                else
                  ...userSkills.map((s) => _buildSkillCard(s)).toList(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink700)),
    );
  }

  Widget _buildAddSkillSection(AsyncValue<List<SkillResponse>> allSkillsAsync, List<UserSkillResponse> userSkills) {
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
          _buildSectionTitle('Add New Skill'),
          allSkillsAsync.when(
            data: (allSkills) {
              final availableSkills = allSkills
                  .where((s) => !userSkills.any((us) => us.skillId == s.id))
                  .toList();

              return Column(
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: _selectedSkillId,
                    hint: const Text('Select a skill'),
                    items: availableSkills.map((s) {
                      return DropdownMenuItem(
                        value: s.id,
                        child: Text(s.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedSkillId = val;
                      });
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
                  const SizedBox(height: 16),
                  const Text(
                    'Experience Level',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ExperienceLevel.values.map((level) {
                      final isSelected = _selectedLevel == level;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedLevel = level),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? _getLevelColor(level).withValues(alpha: 0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? _getLevelColor(level) : AppColors.line,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            _formatExperienceLevel(level),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? _getLevelColor(level) : AppColors.ink700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addSkill,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Skill'),
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
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Failed to load skills: $e'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(UserSkillResponse skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getLevelColor(skill.experienceLevel).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getLevelIcon(skill.experienceLevel),
              color: _getLevelColor(skill.experienceLevel),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.skillName,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink900),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatExperienceLevel(skill.experienceLevel),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getLevelColor(skill.experienceLevel),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeSkill(skill.skillId, skill.skillName),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLevelIcon(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.BEGINNER:
        return Icons.star_outline;
      case ExperienceLevel.INTERMEDIATE:
        return Icons.star_half;
      case ExperienceLevel.ADVANCED:
        return Icons.star;
      case ExperienceLevel.PROFESSIONAL:
        return Icons.workspace_premium;
    }
  }
}
