import 'package:flutter/material.dart';

class SelfGuidedModeScreen extends StatelessWidget {
  const SelfGuidedModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      {
        "title": "Pronunciation Control",
        "description": "Improve clarity and articulation using guided voice drills.",
        "difficulty": "beginner",
      },
      {
        "title": "Sentence Flow Training",
        "description": "Practice smooth transitions between words and sentences.",
        "difficulty": "intermediate",
      },
      {
        "title": "Advanced Speech Precision",
        "description": "Enhance control over complex speech patterns.",
        "difficulty": "advanced",
      },
    ];

    Color difficultyColor(String level) {
      switch (level) {
        case "intermediate":
          return const Color(0xFF6C63FF);
        case "advanced":
          return const Color(0xFFE53935);
        default:
          return const Color(0xFF00A86B);
      }
    }

    IconData difficultyIcon(String level) {
      switch (level) {
        case "intermediate":
          return Icons.trending_up;
        case "advanced":
          return Icons.workspace_premium;
        default:
          return Icons.star_border;
      }
    }

    Widget buildExerciseCard(Map<String, String> exercise) {
      final level = exercise["difficulty"]!;
      final color = difficultyColor(level);

      return Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            // Left Icon Container
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.mic_none_rounded,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise["title"]!,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exercise["description"]!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Difficulty Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          difficultyIcon(level),
                          size: 14,
                          color: color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          level.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Add Button
            CircleAvatar(
              backgroundColor: color,
              radius: 18,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Self-Guided Mode",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ===== Header Section =====
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF142635), Color(0xFF1E3A5F)],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.psychology, size: 70, color: Colors.white),
                          SizedBox(height: 12),
                          Text(
                            "Independent Practice",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Select exercises and start your therapy session anytime.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== Exercise List =====
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: exercises.map((e) => buildExerciseCard(e)).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== Bottom Queue Panel =====
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.assignment_outlined),
                              SizedBox(width: 8),
                              Text(
                                "Assignment Queue (0)",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Icon(Icons.inbox_outlined,
                              size: 60, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          const Text(
                            "No exercises selected",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),

                          // Start Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A5F),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                "Start Practice Session",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}