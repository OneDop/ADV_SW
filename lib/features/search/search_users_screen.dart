import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/providers/search_provider.dart';
import 'package:advsw/providers/skill_provider.dart';
import 'package:advsw/models/search_model.dart';
import 'package:advsw/screens/home/widgets.dart';

class SearchUsersScreen extends ConsumerStatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  ConsumerState<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends ConsumerState<SearchUsersScreen> {
  final _searchController = TextEditingController();
  final List<int> _selectedSkillIds = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    ref.read(userSearchProvider.notifier).search(
      name: _searchController.text,
      skillIds: _selectedSkillIds.isEmpty ? null : _selectedSkillIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userSearchAsync = ref.watch(userSearchProvider);
    final allSkillsAsync = ref.watch(allSkillsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Find Talent', 
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.ink900)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar & Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _onSearch(),
                  decoration: InputDecoration(
                    hintText: 'Search users by name...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.ink400),
                    filled: true,
                    fillColor: AppColors.bg,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.teal700),
                      onPressed: _onSearch,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Filter by Skills', 
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink700)),
                const SizedBox(height: 8),
                allSkillsAsync.when(
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
                                if (val) {
                                  _selectedSkillIds.add(skill.id);
                                } else {
                                  _selectedSkillIds.remove(skill.id);
                                }
                              });
                              _onSearch();
                            },
                            selectedColor: AppColors.teal700.withOpacity(0.1),
                            checkmarkColor: AppColors.teal700,
                            labelStyle: GoogleFonts.inter(
                              fontSize: 12,
                              color: isSelected ? AppColors.teal700 : AppColors.ink700,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                            backgroundColor: Colors.white,
                            shape: StadiumBorder(side: BorderSide(
                              color: isSelected ? AppColors.teal700 : AppColors.line,
                            )),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  loading: () => const SizedBox(height: 40, child: Center(child: LinearProgressIndicator())),
                  error: (_, __) => const Text('Error loading skills'),
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: userSearchAsync.when(
              data: (users) {
                if (users.isEmpty && _searchController.text.isEmpty && _selectedSkillIds.isEmpty) {
                  return _buildEmptyState('Start searching for collaborators');
                }
                if (users.isEmpty) return _buildEmptyState('No users found matching your search');

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) => _UserSearchCard(user: users[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: AppColors.ink300),
          const SizedBox(height: 12),
          Text(msg, style: GoogleFonts.inter(color: AppColors.ink500)),
        ],
      ),
    );
  }
}

class _UserSearchCard extends StatelessWidget {
  final SearchUserResult user;
  const _UserSearchCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          UserAvatar(
            name: '${user.firstName} ${user.lastName}',
            imageUrl: user.profilePictureUrl,
            size: 52,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${user.firstName} ${user.lastName}', 
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.ink900, fontSize: 15)),
                Text(user.email, 
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.ink500)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: user.skills.take(3).map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.teal50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(s.skillName, 
                      style: GoogleFonts.inter(fontSize: 10, color: AppColors.teal700, fontWeight: FontWeight.w600)),
                  )).toList(),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.ink300),
        ],
      ),
    );
  }
}
