import 'package:advsw/screens/home/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBRabBYyJRS2c3_pSR5Lmzv4vppGXLPmmcEU5KAWDDzifg5-qrhz1wxHwyYEzIb1AT7xNzj33LiBP_ScQnIPxW7K9HIUV3MEZZjJb0YEy69a4Q0sO2blm7XSzbzK4Gb1hj7JatzMKIvCkXMWv9EKqPTn5f3EYKYXbm6ill4QfrAaFvCFe75MAgEMlyAZM44u9DtGIvV_gMhrTB0Otj9rW0P96RoaR1_hVRecbSQeyNkNhZTtFtn7OVZJa2xOliGWU_GE-B_LptZ0Ho'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'The Quiet Engine',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Color(0xFF004253),
                        ),
                      ),
                    ],
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
              const SizedBox(height: 32),

              // Hero Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF004253), Color(0xFF005B71)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, Julian.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Focus on the Aris Rebrand today.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // My Projects Section
              SectionHeader(
                title: 'My Projects',
                onViewAll: () {},
              ),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const ProjectCard(
                      name: 'Aris Brand Identity',
                      progress: 0.65,
                      status: 'In Progress',
                      icon: Icons.architecture,
                    ),
                    ProjectCard(
                      name: 'E-Commerce Portal',
                      progress: 0.12,
                      status: 'Planning',
                      icon: Icons.web_asset,
                      iconBgColor: const Color(0xFF004253).withOpacity(0.1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Add New Project Button
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: const Color(0xFFBFC8CC).withOpacity(0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Color(0xFF40484C)),
                    SizedBox(width: 8),
                    Text('Add New Project', style: TextStyle(color: Color(0xFF40484C))),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // My Tasks Section
              SectionHeader(
                title: 'My Tasks',
                onViewAll: () {},
              ),
              const TaskCard(
                name: 'Final PDF Export',
                description: 'Tomorrow • Aris Brand',
                icon: Icons.description,
              ),
              const TaskCard(
                name: 'Wireframe Feedback',
                description: 'Oct 24 • E-Commerce',
                icon: Icons.draw,
                iconBgColor: Color(0xFFECEEEF),
              ),
              const TaskCard(
                name: 'Internal Review',
                description: 'Oct 28 • Unannounced',
                icon: Icons.rate_review,
                iconBgColor: Color(0xFFECEEEF),
              ),
              const SizedBox(height: 24),

              // Productivity Card
              const ProductivityCard(),
              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF004253),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
