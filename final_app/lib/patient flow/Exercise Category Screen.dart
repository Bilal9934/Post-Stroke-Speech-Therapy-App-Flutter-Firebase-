// lib/PATIENT FLOW/Exercise Category Screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseCategoryScreen extends StatefulWidget {
  const ExerciseCategoryScreen({super.key});

  @override
  State<ExerciseCategoryScreen> createState() => _ExerciseCategoryScreenState();
}

class _ExerciseCategoryScreenState extends State<ExerciseCategoryScreen> {

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'intermediate':
        return const Color(0xFF1E3A5F);
      case 'advanced':
        return const Color(0xFF0D1B3B);
      default:
        return const Color(0xFF1E3A5F);
    }
  }

  IconData _difficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'intermediate':
        return Icons.trending_up;
      case 'advanced':
        return Icons.workspace_premium;
      default:
        return Icons.star;
    }
  }

  void _openCreateExercise() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedDifficulty = 'beginner';

    showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Add Exercise Module'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedDifficulty,
                      items: const [
                        DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                        DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                        DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedDifficulty = val);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    ).then((result) async {
      if (result == true && titleController.text.isNotEmpty) {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance.collection('exercises').add({
              'userId': user.uid,
              'title': titleController.text,
              'description': descriptionController.text,
              'difficulty': selectedDifficulty,
              'createdAt': FieldValue.serverTimestamp(),
            });

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exercise added successfully.'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving exercise: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Therapy Modules",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(.1),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: _openCreateExercise,
              ),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Exercise Categories",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Select a therapy module to begin structured rehabilitation.",
              style: TextStyle(color: Color(0xFF1E3A5F)),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('exercises')
                    .where(
                  'userId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                )
                    .orderBy('createdAt', descending: true)
                    .snapshots(),

                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No exercises carefully added yet. Tap the + icon.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {

                      final ex = docs[index].data() as Map<String, dynamic>;
                      final difficulty = ex["difficulty"] ?? 'beginner';
                      final title = ex["title"] ?? 'Unknown';
                      final desc = ex["description"] ?? '';
                      final diffColor = _difficultyColor(difficulty);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 28),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9EEF5),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: diffColor.withOpacity(.25),
                                    blurRadius: 30,
                                    offset: const Offset(0, 18),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [

                                  Container(
                                    width: 8,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: diffColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          children: [
                                            Icon(
                                              _difficultyIcon(difficulty),
                                              color: diffColor,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              difficulty.toUpperCase(),
                                              style: TextStyle(
                                                color: diffColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 12),

                                        Text(
                                          title,
                                          style: const TextStyle(
                                            color: Color(0xFF1E3A5F),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          desc,
                                          style: const TextStyle(
                                            color: Color(0xFF1E3A5F),
                                            height: 1.5,
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: LinearProgressIndicator(
                                            value: (index + 1) / docs.length,
                                            backgroundColor:
                                            Colors.white.withOpacity(.1),
                                            color: diffColor,
                                            minHeight: 6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: diffColor.withOpacity(.15),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: diffColor,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}