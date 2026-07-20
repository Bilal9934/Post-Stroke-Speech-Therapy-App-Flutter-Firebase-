// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:final_app/PATIENT FLOW/Exercise Category Screen.dart';
import 'package:final_app/PATIENT FLOW/Self-Guided Mode Screen.dart';
import 'package:final_app/PATIENT FLOW/patient profile screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _DashboardHomeTab(),
      const ExerciseCategoryScreen(),
      const ProfileScreen(embedded: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ White background
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1E3A5F),
        unselectedItemColor: Colors.grey.shade500,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded), label: 'Exercises'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

/// --- Dashboard Home Tab ---
class _DashboardHomeTab extends StatelessWidget {
  const _DashboardHomeTab();

  @override
  Widget build(BuildContext context) {
    final double bottomPadding =
        MediaQuery.of(context).padding.bottom + 20;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Welcome Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E3A5F),
                  Color(0xFF2D6A8E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Welcome back, Muhammad! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.favorite, color: Colors.white, size: 30),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// Top Actions
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: "Self-Guided Mode",
                  subtitle: "Create session",
                  icon: Icons.play_circle_fill,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E3A5F),
                      Color(0xFF4CB8C4),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SelfGuidedModeScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ActionCard(
                  title: "Daily Summary",
                  subtitle: "Track progress",
                  icon: Icons.calendar_today,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF142635),
                      Color(0xFF2D6A8E),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Stats
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: "Active Sessions",
                  subtitle: "0 Ongoing",
                  icon: Icons.play_arrow,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E3A5F),
                      Color(0xFF2D6A8E),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ActionCard(
                  title: "Achievements",
                  subtitle: "1 Earned",
                  icon: Icons.emoji_events,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2D6A8E),
                      Color(0xFF1E3A5F),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            "Recent Sessions",
            style: TextStyle(
              color: Color(0xFF1E3A5F), // Dark text on white
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EEF5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              "No sessions yet.\nStart a self-guided session to begin.",
              style: TextStyle(
                color: Color(0xFF1E3A5F),
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// --- Action Card ---
class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 115,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 10),
            /// ✅ FIXED: Wrap title to prevent overflow
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}