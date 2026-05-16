import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/providers/user_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _pastProjectController = TextEditingController();
  ExperienceLevel _experienceLevel = ExperienceLevel.BEGINNER;
  final List<String> _pastProjects = [];

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if available
    final profile = ref.read(userProfileProvider).value;
    if (profile != null) {
      _nameController.text = '${profile.firstName} ${profile.lastName}';
      _bioController.text = profile.bio;
      // In a real app, we'd map pastProjects names here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Edit Profile', 
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.ink900)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Save logic
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: AppColors.teal700, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('General Information'),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Experience Level'),
            DropdownButtonFormField<ExperienceLevel>(
              value: _experienceLevel,
              items: const [
                DropdownMenuItem(value: ExperienceLevel.BEGINNER, child: Text('Junior')),
                DropdownMenuItem(value: ExperienceLevel.INTERMEDIATE, child: Text('Mid')),
                DropdownMenuItem(value: ExperienceLevel.ADVANCED, child: Text('Senior')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _experienceLevel = val);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Past Projects'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pastProjectController,
                    decoration: const InputDecoration(hintText: 'Add project link or name'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.teal700),
                  onPressed: () {
                    if (_pastProjectController.text.isNotEmpty) {
                      setState(() {
                        _pastProjects.add(_pastProjectController.text);
                        _pastProjectController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _pastProjects.map((proj) => Chip(
                label: Text(proj, style: const TextStyle(fontSize: 12)),
                onDeleted: () => setState(() => _pastProjects.remove(proj)),
              )).toList(),
            ),
          ],
        ),
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
}
