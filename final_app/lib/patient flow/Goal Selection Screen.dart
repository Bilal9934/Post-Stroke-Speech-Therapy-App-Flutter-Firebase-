import 'package:flutter/material.dart';
import 'package:final_app/PATIENT%20FLOW/patient%20dashboard%20screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class GoalOption {
  final String id, title, description;
  final IconData icon;
  final List<Color> gradientColors;

  GoalOption({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.description,
  });
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  final Set<String> _selected = {};

  final List<GoalOption> _goalOptions = [
    GoalOption(
      id: 'listening',
      title: 'Listening',
      icon: Icons.hearing_outlined,
      gradientColors: [Color(0xFF1E3A5F), Color(0xFF2D6A8E)],
      description: 'Improve ability to understand spoken language',
    ),
    GoalOption(
      id: 'understanding',
      title: 'Understanding',
      icon: Icons.lightbulb_outline,
      gradientColors: [Color(0xFF1E3A5F), Color(0xFF2D6A8E)],
      description: 'Better comprehension of context',
    ),
    GoalOption(
      id: 'reading',
      title: 'Reading',
      icon: Icons.menu_book_outlined,
      gradientColors: [Color(0xFF1E3A5F), Color(0xFF2D6A8E)],
      description: 'Enhance reading skills',
    ),
    GoalOption(
      id: 'speaking',
      title: 'Speaking',
      icon: Icons.record_voice_over_outlined,
      gradientColors: [Color(0xFF1E3A5F), Color(0xFF2D6A8E)],
      description: 'Practice verbal communication',
    ),
  ];

  bool _isLoading = false;

  Future<void> _handleContinue() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one goal to continue'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'goals': _selected.toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving goals: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Page background white
      appBar: AppBar(
        title: const Text('Your Goals'),
        backgroundColor: Color(0xFF1E3A5F), // Dark blue AppBar
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const Icon(
                        Icons.flag_outlined,
                        size: 80,
                        color: Color(0xFF1E3A5F),
                      ), // Dark blue icon
                      const SizedBox(height: 16),
                      Text(
                        'Choose Your Therapy Focus',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A5F), // Dark blue
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select one or more areas to personalize your program.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: List.generate(_goalOptions.length, (index) {
                          final goal = _goalOptions[index];
                          final isSelected = _selected.contains(goal.id);
                          final leftSide = index % 2 == 0;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: leftSide
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: _IndustrialGoalCard(
                                    goal: goal,
                                    isSelected: isSelected,
                                    leftSide: leftSide,
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selected.remove(goal.id);
                                        } else {
                                          _selected.add(goal.id);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E3A5F), // Dark blue button
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 8,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Continue to Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              if (_selected.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Select at least one goal to personalize your therapy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndustrialGoalCard extends StatefulWidget {
  final GoalOption goal;
  final bool isSelected;
  final bool leftSide;
  final VoidCallback onTap;

  const _IndustrialGoalCard({
    required this.goal,
    required this.isSelected,
    required this.leftSide,
    required this.onTap,
  });

  @override
  State<_IndustrialGoalCard> createState() => _IndustrialGoalCardState();
}

class _IndustrialGoalCardState extends State<_IndustrialGoalCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.goal.gradientColors; // Dark blue always

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.isSelected ? Colors.white : Colors.transparent,
                  width: widget.isSelected ? 2 : 0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      widget.isSelected ? 0.25 : 0.15,
                    ),
                    blurRadius: widget.isSelected ? 14 : 8,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              // --- Inside _IndustrialGoalCard build ---
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32),
                  Text(
                    widget.goal.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // ✅ Goal title white
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.goal.description,
                    style: const TextStyle(
                      color: Colors.white70, // ✅ Goal description white
                      fontSize: 13,
                    ),
                  ),
                  if (widget.isSelected)
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: -20,
              left: widget.leftSide ? 16 : null,
              right: widget.leftSide ? null : 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.goal.icon,
                  size: 32,
                  color: Colors.white, // Icon white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
