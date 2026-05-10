import 'package:advsw/screens/myprojects/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: const Color(0xFFF8F9FA),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF004253)),
                onPressed: () => context.pop(),
              ),
              title: const Text(
                'All Projects',
                style: TextStyle(
                  color: Color(0xFF004253),
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search projects...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
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
                  const ProjectCard(
                    name: 'Mobile App UX',
                    progress: 0.85,
                    status: 'In Progress',
                    icon: Icons.smartphone,
                    iconBgColor: Color(0xFFE7E8E9),
                  ),
                  const ProjectCard(
                    name: 'Marketing Site',
                    progress: 1.0,
                    status: 'Completed',
                    icon: Icons.language,
                    iconBgColor: Color(0xFFD0E6F3),
                  ),
                  const ProjectCard(
                    name: 'Product Design',
                    progress: 0.45,
                    status: 'In Progress',
                    icon: Icons.inventory_2_outlined,
                  ),
                  ProjectCard(
                    name: 'SEO Strategy',
                    progress: 0.30,
                    status: 'Review',
                    icon: Icons.insights,
                    iconBgColor: const Color(0xFF004253).withOpacity(0.1),
                  ),
                ]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}
