import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    if (role == 'patient') {
      Navigator.pushNamed(context, "/patientInfo");
    } else {
      Navigator.pushReplacementNamed(context, "/therapistDashboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    final patientAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.75, curve: Curves.easeOut),
    );

    final therapistAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white, // Page background white
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),

                /// HEADER
                FadeTransition(
                  opacity: headerAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.4),
                      end: Offset.zero,
                    ).animate(headerAnimation),
                    child: Column(
                      children: const [
                        Text(
                          "Choose Your Role",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F), // Header text dark blue
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select your account type to continue.",
                          style: TextStyle(
                            color: Color(0xFF1E3A5F), // Dark blue
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 70),

                Expanded(
                  child: Column(
                    children: [
                      /// PATIENT CARD
                      _AnimatedRoleCard(
                        animation: patientAnimation,
                        title: "Patient",
                        subtitle:
                        "Access rehabilitation plans and track your recovery.",
                        icon: Icons.favorite,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1E3A5F), // Dark Blue
                            Color(0xFF2D6A8E), // Slightly lighter blue
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () => _selectRole('patient'),
                      ),

                      const SizedBox(height: 30),

                      /// THERAPIST CARD
                      _AnimatedRoleCard(
                        animation: therapistAnimation,
                        title: "Therapist",
                        subtitle: "Design therapy programs and monitor sessions.",
                        icon: Icons.psychology,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2D6A8E),
                            Color(0xFF1E3A5F),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        onTap: () => _selectRole('therapist'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedRoleCard extends StatelessWidget {
  final Animation<double> animation;
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _AnimatedRoleCard({
    required this.animation,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28), // Icon white
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text white
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white, // Subtitle white
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 18), // Arrow white
              ],
            ),
          ),
        ),
      ),
    );
  }
}