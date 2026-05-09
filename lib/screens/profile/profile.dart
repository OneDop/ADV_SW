import 'package:advsw/screens/profile/widgets.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'The Quiet Engine',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Color(0xFF004253),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none, color: Color(0xFF004253)),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Profile Header
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE1E3E4), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuABgiKX_FDZaKm2AVVJUIUad7frnKuCuOinVz0WjYTgWLXYSLPsC7UZFPGCX7bpPRieIsXs0MntDZO_deP2YiOV9K7tGhcgZyGGDoza1AE26qlUca7erNUNJ0TV6ZtL3l7HFCvOiU8l2xHQVRpLamUaSgNZTGGwtAxJ5rk1QDxT9Z_L_8N6vUJKDJBT6ZVtBuTHnKGT10wAyL9bNKsL2sAgLbqZDhuMYGAi85EEpF792bg_JHnPTEY3CENccFgayNxfn0PLc4CjFRo'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Icon(Icons.edit, color: Color(0xFF004253), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Alex Rivera',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Manrope',
                  color: Color(0xFF004253),
                ),
              ),
              const Text(
                'alex.rivera@quietengine.io',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF40484C),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF854000),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      'AVAILABLE NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Senior Product Architect',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF40484C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Crafting intentional digital ecosystems through structural precision and editorial design. Specializing in high-performance project infrastructures and scalable design systems.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF40484C),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Skills Section
              ProfileSectionHeader(
                title: 'Skills',
                icon: Icons.verified_outlined,
                actionLabel: 'Add Skill',
                onAction: () {},
              ),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SkillChip(label: 'UI Architecture'),
                  SkillChip(label: 'Design Systems'),
                  SkillChip(label: 'React Architecture'),
                  SkillChip(label: 'Tailwind Expert'),
                  SkillChip(label: 'User Flow Mapping'),
                  SkillChip(label: 'Rapid Prototyping'),
                  SkillChip(label: 'Editorial Layouts'),
                ],
              ),

              // Previous Projects Section
              const ProfileSectionHeader(
                title: 'Previous Projects',
                icon: Icons.grid_view_outlined,
              ),
              const ProfileProjectCard(
                title: 'Nexus Data Core',
                description: 'Complete architectural redesign of a real-time analytics engine processing 40M+ events daily.',
                year: '2023',
                role: 'Lead Designer',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABIoUxH_bPX1SygHwUhANZvvsDKdEnk-NplqMiYamjBW8q74G_YOZNhztx0A_BeQ906vwHyH08WvSvqzanQgx92P2sKDwWtjPOkU_SrFEwNgEzsUe55rwbREADWmdt5wSN2dM2DW5IB3IymeCGj1Mx-7Uw-XH8BFM6Wl9P3WxzB2SIaLkxRhLB8S565-WJ-CSmdK9-5zCsMK_gl90dRFjOXHdvzDNl7c8ta6BKKJvKyIcn_H1NDe2uB7pqdwpbRIpGv66k_Rh95Ow',
              ),
              const ProfileProjectCard(
                title: 'Zenith Fintech Shell',
                description: 'A high-fidelity design system focused on accessibility and cognitive load reduction in high-stakes trading.',
                year: '2022',
                role: 'System Architect',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAc4fwUTSzwr87AqvShPEygUGwGd8O0horuM-gN2iFet6cXzKcBHNWQ1yVz29tCbO7Sievdd7AlevhHan1oOwLJr2TROWNWH5eO1dnrxguMgaUqZZNJKCZvwN5ir77xWZh-Yp68zQFlmDwgnKHtd_bcxfnLHlajWXpB9CDczgY9UmjOJJ8WGxsOJocUgHI9tCVqGJeE0jW6vPGhxmO6TTPvgoQeztTKTuTWq4EMTZQO4mtLRUDHBNa9GFLPtuxAPHYTCuGywYcv4yQ',
              ),

              const SizedBox(height: 48),
              // Log Out Button
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFBA1A1A),
                  side: const BorderSide(color: Color(0xFFBA1A1A), width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 100), // Padding for BottomNav
            ],
          ),
        ),
      ),
    );
  }
}
