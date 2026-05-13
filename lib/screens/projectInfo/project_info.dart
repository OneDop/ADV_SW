import 'package:flutter/material.dart';
import 'widgets.dart';

class ProjectInfoScreen extends StatelessWidget {
  const ProjectInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProjectBreadcrumbs(
                    currentProject: 'Quantum Architecture Redesign',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Quantum Architecture\nRedesign',
                    style: TextStyle(
                      fontSize: 40,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Manrope',
                      color: Color(0xFF004253),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Refactoring the core engine for sub-millisecond latency and implementing the new collaborative canvas protocol.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF40484C),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTeamStack(),
                      _buildAddTaskButton(),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildProgressBento(),
                  const SizedBox(height: 32),
                  _buildKanbanBoard(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuB3J5zV2qvfnH_VCL3Q6PoVrpCXYtisd0pw_bOshKZPz0k2kqeFGgJu5Jf7pAt89cmvI8BMWBG-r7bJ24XeBbI95qnufqvRZhvg2nKbaL09aQWSR9Uz9RCQKYKRW4W7cilCz-YAwJh6_IE5_UopRW4HFhy7yS_IJHCf9rZzfc41sjGL4iG_xPccjmQSI6bzoChNAp6gG8bxPn_z9n9DunZzz30oEWjZgAgUF8VA1Egl718zuGdi_yvEAGi63zQorZKmkwSo_gXW9Fk'),
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
              color: Color(0xFF004253),
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.forum_outlined, color: Color(0xFF70787D)),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Color(0xFF70787D)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTeamStack() {
    final images = [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBqYXr3m5Y3dMQnNgIhAVH7XWl6dhgTrLMIQrYbESuB15_rvJLn4SxYDTJ7GDewcHiHaDmS0E6_Rw8J2T54fvWutFdYL1KwihmnhUrrtzZiyeFzOSfvGkg7PCwQVAdtvS3fl7cxuBuuL83v7G5lCf2kj0sVx-qUt15otRAksiTdfesl0DALelOVhZCjQvuu4OcP9ipop3ncbwrYUZy7wtb9mWFihXrFypdQIG8JiMbA_4BNDzstvjIHVLxxzel1hRNvf67Uj-F8Tx4',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAG_o6UN_gDAzDaUIpdGmVjSBkVjShc9cxrpOqCoUMGgJCASc8-_3R9dBmGy3xN9ekNDG8UK1vrsqPMPYIaAahvS8fttm0luRIuI-ORq4abapQCOTZOmLV1xiJ8RpwQX-J4BknnoMdkaAahK6S9ak1aleoDChtDmVQpDW3ExKNDEqTZQlHe0xXbhz49DYZrsmKETpEcH-AdTunrAQLH_SilgSy6lXsptX1Pk19_r1VmAnAhz6-hrhh41IeL_abl9CqSLfuyyFlG9dc',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuApLExpDAdguJGW9nH2ShnYO6r3pPqzs06UrrgtOGCQ1zsJZ75qBydYSBnU7ge7_SX0x6rHym2w5yjiJH9AXcpUm6hl5Dq3tpNaVkKA6RRxA0vH47x8--Ac1TLlkiOdddWgMm9wGoU4w8hds70OoOUSOIUW6d3xiBvKaDPwLRF1jKCS8Yxkzbz74tdkdN_kKq35-dNUJViqtTly9yM4-dmN6tWqUFBFkjduyFOm752NtuvrH043KLbgpo_o59qh95uhyVonvfDb4uc',
    ];
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 40.0 + (images.length - 1) * 28.0,
          child: Stack(
            children: List.generate(images.length, (index) {
              return Positioned(
                left: index * 28.0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE7E8E9),
            border: Border.all(color: Colors.white, width: 2),
          ),
          alignment: Alignment.center,
          child: const Text(
            '+4',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF40484C)),
          ),
        ),
      ],
    );
  }

  Widget _buildAddTaskButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF004253), Color(0xFF005B71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004253).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildProgressBento() {
    return Column(
      children: [
        const BentoProgressCard(
          title: 'Overall Progress',
          value: '68%',
          progress: 0.68,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: BentoProgressCard(
                title: 'Urgent Deliverables',
                value: '04',
                backgroundColor: Color(0xFFFFF1E6),
                textColor: Color(0xFF622E00),
                bottomWidget: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'tasks due today',
                    style: TextStyle(fontSize: 12, color: Color(0xFF622E00), fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BentoProgressCard(
                title: 'Active Sprints',
                value: 'V2 Core Launch',
                backgroundColor: const Color(0xFFD0E6F3),
                bottomWidget: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: List.generate(3, (index) => Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF004253).withOpacity(0.2 * (index + 1)),
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKanbanBoard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColumnHeader('To Do', '12', Colors.blueGrey),
        const SizedBox(height: 16),
        const KanbanTaskCard(
          category: 'Infrastructure',
          title: 'Define WebSocket heartbeat intervals',
          date: 'Oct 12',
          assignees: ['https://lh3.googleusercontent.com/aida-public/AB6AXuD4nbvF83JjpffLZ8C15DB9RVOsxtX7IOuUaF9t9vZxUMkUrFchOOLp7RFLryRQsQVWdAeREwVToII7Y8FZfsUMKDgX0s1MaGcx5_Aspz3v_mVJto94YVr8D-GFOf5E3hI5PQIyN_6FL4NBALq8MQt7Q27coMRnVkOhZ_FmVWnt645eHzNocwXDAmoFmliQymfdd78nTR5iOxnhLlt5hn0jYJjEq4UM_HycXC8xKgcYyZuJFJasa3dPzgDb1MM2lrxG-mIHymEGCJ8'],
        ),
        const SizedBox(height: 12),
        const KanbanTaskCard(
          category: 'Design System',
          title: 'Finalize dark mode elevation tokens',
          date: 'Oct 14',
          assignees: [
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBid6w4wXHW1fxiM6t9L2kA6kC5OnfQSl2z3wBirfI1DnrqIquP1KtTd1cGGqdlLrUoJl0m7lHwDYSoc38Cytwq7SHl0isQtl0UQfjt96YO7ADHtl8AMyBwTxkjCltO59XxPthXZSb4CYhmu-rCPtWPXldTBVaSUKVOUXfoiqp0_YtTReQeysPngKbRNtMLitX-zuWRzoBq4ZcPHMpc9L85-oI5kzzgP3ndJnbKVbezAfn9CKQTtjIOCN97oIcCHCqYwOla1nDM90I',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCRhJwz6Y2w7eqagfpnDObMNux15xzbDwl6IFf877mQ7jMuJTzlkyd-gq95P2xuKpOrqi4vUd0_Mt4sw799msaI8ZFe2Bju2xfenzP_s7pZvvr4mOGfmgn_iGtJph22TfO--w1WxEbXmjjvJ3HkBNSiZSLvmYS2qY56w52ES_3zBzj-kHLnR4PAM-d-z_l3YVvMa6FL3ETCvJ-Av6p64ctSQgguoGxN5QCm3MJuk4TsdVePHenTHj5lGT7lfbHbL7i2l-rAg03DHHo',
          ],
        ),
        const SizedBox(height: 32),
        _buildColumnHeader('In Progress', '03', const Color(0xFF622E00)),
        const SizedBox(height: 16),
        const KanbanTaskCard(
          category: 'Critical Path',
          title: 'Implement end-to-end encryption for team messages',
          borderColor: Color(0xFF622E00),
          priority: 'High',
          assignees: ['https://lh3.googleusercontent.com/aida-public/AB6AXuDdXaBj69ULyh1ztmKgTaJbogQatcyroJ4isTz-nqsNjAbI7AYVm9uaPMrik1rEGmMx42hkqjONLPe36uNtl0VgXUgNcVCrA0FAkhdJzlMcvD2iqljJ06COjK8MzsUF2OYXdNypJPwlqlV8vvLeTxAc1TCslvok8sHPShky6fHvIGcuJ7iiYNV6U0jfPHz6IMtIf5qUSkAZU1IRDnSwEBrH8846-BKg0OsBd8dsnn_hIlVoVR8VLX1maLBA1s0wmrv-Rh1vvfE8Euk'],
        ),
        const SizedBox(height: 32),
        _buildColumnHeader('Done', '28', const Color(0xFF004253)),
        const SizedBox(height: 16),
        const KanbanTaskCard(
          category: 'Branding',
          title: 'Asset pack export for marketing',
          isCompleted: true,
          assignees: ['https://lh3.googleusercontent.com/aida-public/AB6AXuAEsluGguv-70xrkGVv49vdnXRTubO1_arBDcalsvX2D6kd_QcUsBsBh-A4fQNTIdSluG8rxC-uSeFXN4ArUaEbeXm0aEb-_48LWfyCa8HJ7CdE1ncTK6nndsYgnM3k5NmNYM0jwGHvFyA6Sx8R1S0FXJZaBY207n_6ZLRmoWaDC-sKKG-0nsfRgGVjkRZib5o5Qkzl7c04AZq-NnTpCaN7DhOhZfzZNN4uMYmuYlT7FYikFmcrJe46i_-5C2Akuq9Q2BMdZ0pFeb0'],
        ),
      ],
    );
  }

  Widget _buildColumnHeader(String title, String count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Manrope',
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE7E8E9),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            count,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF40484C),
            ),
          ),
        ),
      ],
    );
  }
}
