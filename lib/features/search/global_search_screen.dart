import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/search_provider.dart';
import 'package:advsw/providers/skill_provider.dart';
import 'package:advsw/screens/home/widgets.dart';
import 'package:advsw/screens/user_profile/user_profile_screen.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  final List<int> _selectedSkillIds = [];

  void _onSearch() {
    ref.read(userSearchProvider.notifier).search(
      name: _searchController.text,
      skillIds: _selectedSkillIds.isEmpty ? null : _selectedSkillIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(userSearchProvider);
    final allSkills = ref.watch(allSkillsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Find Talent', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: Column(
        children: [
          AnimatedPadding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 200),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _onSearch(),
                  decoration: InputDecoration(
                    hintText: 'Search by name...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.ink400),
                    filled: true,
                    fillColor: AppColors.bg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Filter by Skills', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink700)),
                const SizedBox(height: 8),
                allSkills.when(
                  data: (skills) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: skills.map((skill) {
                        final isSelected = _selectedSkillIds.contains(skill.id);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(skill.name),
                            selected: isSelected,
                            onSelected: (val) {
                              setState(() {
                                val ? _selectedSkillIds.add(skill.id) : _selectedSkillIds.remove(skill.id);
                              });
                              _onSearch();
                            },
                            selectedColor: AppColors.teal700.withOpacity(0.1),
                            checkmarkColor: AppColors.teal700,
                            labelStyle: GoogleFonts.inter(fontSize: 12, color: isSelected ? AppColors.teal700 : AppColors.ink700),
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            shape: StadiumBorder(side: BorderSide(color: isSelected ? AppColors.teal700 : AppColors.line)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
          ),
          Expanded(
            child: searchResults.when(
              data: (users) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(userId: user.id),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.lineSoft), boxShadow: AppTheme.shadowSm,
                      ),
                      child: Row(
                        children: [
                          UserAvatar(name: '${user.firstName} ${user.lastName}', imageUrl: user.profilePictureUrl, size: 48),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('${user.firstName} ${user.lastName}', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.ink900)),
                            Text(user.email, style: GoogleFonts.inter(fontSize: 12, color: AppColors.ink500)),
                          ])),
                          const Icon(Icons.chevron_right, color: AppColors.ink300),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
