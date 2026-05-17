import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/data/seed_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _bioCtrl;
  late String _status;
  late String _experience;
  late List<String> _skills;
  late List<String> _pastProjects;
  final _skillInputCtrl     = TextEditingController();
  final _pastProjectCtrl    = TextEditingController();

  @override
  void initState() {
    super.initState();
    final u = SeedData.editableUser;
    _firstNameCtrl = TextEditingController(text: u.firstName);
    _lastNameCtrl  = TextEditingController(text: u.lastName);
    _bioCtrl       = TextEditingController(text: u.bio);
    _status        = u.status;
    _experience    = u.experience;
    _skills        = List.from(u.skills);
    _pastProjects  = List.from(u.pastProjects);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _bioCtrl.dispose();
    _skillInputCtrl.dispose();
    _pastProjectCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final u = SeedData.editableUser;
    u.firstName    = _firstNameCtrl.text.trim().isEmpty ? u.firstName : _firstNameCtrl.text.trim();
    u.lastName     = _lastNameCtrl.text.trim().isEmpty  ? u.lastName  : _lastNameCtrl.text.trim();
    u.bio          = _bioCtrl.text.trim();
    u.status       = _status;
    u.experience   = _experience;
    u.skills       = List.from(_skills);
    u.pastProjects = List.from(_pastProjects);

    SeedData.profileNotifier.value++;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated'),
        backgroundColor: AppColors.teal700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    context.pop();
  }

  void _addSkill() {
    final s = _skillInputCtrl.text.trim();
    if (s.isEmpty || _skills.contains(s)) return;
    setState(() => _skills.add(s));
    _skillInputCtrl.clear();
  }

  void _addPastProject() {
    final p = _pastProjectCtrl.text.trim();
    if (p.isEmpty || _pastProjects.contains(p)) return;
    setState(() => _pastProjects.add(p));
    _pastProjectCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgAlt,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                        boxShadow: AppTheme.shadowSm,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.ink900),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Edit Profile',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink900, letterSpacing: -0.3)),
                  ),
                  GestureDetector(
                    onTap: _save,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: AppTheme.primaryGradient,
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                children: [
                  // Profile picture
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 84, height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD0E6F3), Color(0xFF8DD0E9)],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: AppTheme.shadowMd,
                          ),
                          child: const Center(
                            child: Text('AR', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.ink900)),
                          ),
                        ),
                        Positioned(
                          right: 0, bottom: 0,
                          child: GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Photo upload coming soon'),
                                backgroundColor: AppColors.teal700,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            child: Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.teal700, shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Name
                  _SectionLabel('NAME'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _Field(label: 'First name', controller: _firstNameCtrl)),
                      const SizedBox(width: 10),
                      Expanded(child: _Field(label: 'Last name', controller: _lastNameCtrl)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Bio
                  _SectionLabel('BIO'),
                  const SizedBox(height: 8),
                  _Field(label: 'Tell people about yourself…', controller: _bioCtrl, maxLines: 3),
                  const SizedBox(height: 20),

                  // Status
                  _SectionLabel('AVAILABILITY STATUS'),
                  const SizedBox(height: 8),
                  Row(
                    children: ['available', 'busy', 'offline'].map((s) {
                      final sel = _status == s;
                      final color = s == 'available'
                          ? const Color(0xFF3BB273)
                          : s == 'busy'
                              ? AppColors.warm600
                              : AppColors.ink400;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _status = s),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(
                              color: sel ? color.withValues(alpha: 0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: sel ? color : AppColors.line, width: sel ? 1.5 : 1),
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(backgroundColor: color, radius: 4),
                                const SizedBox(height: 4),
                                Text(
                                  s[0].toUpperCase() + s.substring(1),
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                                      color: sel ? color : AppColors.ink500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Experience level
                  _SectionLabel('EXPERIENCE LEVEL'),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Junior', 'Mid-level', 'Senior'].map((x) {
                      final sel = _experience == x;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _experience = x),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.teal50 : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: sel ? AppColors.teal700 : AppColors.line),
                            ),
                            child: Text(x, textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                  color: sel ? AppColors.teal700 : AppColors.ink700)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Skills
                  _SectionLabel('SKILLS'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6, runSpacing: 8,
                    children: _skills.map((s) => _RemovableChip(
                      label: s,
                      onRemove: () => setState(() => _skills.remove(s)),
                    )).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(label: 'Add a skill…', controller: _skillInputCtrl,
                          onSubmitted: (_) => _addSkill()),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _addSkill,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.teal700, borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Past projects
                  _SectionLabel('PAST PROJECTS'),
                  const SizedBox(height: 8),
                  ..._pastProjects.map((p) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.lineSoft),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark_border_rounded, size: 16, color: AppColors.teal700),
                        const SizedBox(width: 10),
                        Expanded(child: Text(p, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink900))),
                        GestureDetector(
                          onTap: () => setState(() => _pastProjects.remove(p)),
                          child: const Icon(Icons.close_rounded, size: 16, color: AppColors.ink400),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(label: 'Add a past project…', controller: _pastProjectCtrl,
                          onSubmitted: (_) => _addPastProject()),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _addPastProject,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.teal700, borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Local widgets ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppColors.ink500));
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;

  const _Field({required this.label, required this.controller, this.maxLines = 1, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
        boxShadow: AppTheme.shadowSm,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onSubmitted: onSubmitted,
        style: const TextStyle(fontSize: 14, color: AppColors.ink900),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: AppColors.ink400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}

class _RemovableChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _RemovableChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.teal100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal700)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, size: 14, color: AppColors.teal700),
          ),
        ],
      ),
    );
  }
}
