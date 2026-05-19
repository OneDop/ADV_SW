import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/services/user_service.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/screens/home/widgets.dart';

class UserProfileScreen extends ConsumerWidget {
  final int userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can use a FutureProvider or just a simple FutureBuilder here.
    // For simplicity and immediate fix, using FutureBuilder with UserService.
    final userService = UserService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<UserProfileResponse>(
        future: userService.getProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      UserAvatar(
                        name: '${user.firstName} ${user.lastName}',
                        imageUrl: user.profilePictureUrl,
                        size: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink900,
                        ),
                      ),
                      if (user.bio.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          user.bio,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.ink700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Skills'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.skills
                      .map(
                        (s) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.teal50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${s.skillName} (${s.experienceLevel.name[0]}${s.experienceLevel.name.substring(1).toLowerCase()})',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.teal700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Experience Level'),
                const SizedBox(height: 8),
                Text(
                  user.experienceLevel?.name ?? 'Not specified',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.ink700,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Past Projects'),
                const SizedBox(height: 8),
                if (user.pastProjects.isEmpty)
                  Text(
                    'No past projects added',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.ink500,
                    ),
                  )
                else
                  ...user.pastProjects.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.teal50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          p.name,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.teal700,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 100), // Extra space at bottom
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
      ),
    );
  }
}
