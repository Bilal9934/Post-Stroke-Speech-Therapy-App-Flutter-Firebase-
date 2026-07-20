// lib/screens/create_therapy_session_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateTherapySessionScreen extends StatefulWidget {
  const CreateTherapySessionScreen({super.key});

  @override
  State<CreateTherapySessionScreen> createState() =>
      _CreateTherapySessionScreenState();
}

class _CreateTherapySessionScreenState
    extends State<CreateTherapySessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientController = TextEditingController();

  int _currentStep = 0;
  String _status = 'ongoing';
  bool _submitting = false;

  final List<String> _selectedExercises = [];
  final List<String> _mockExercises = [
    "Pronunciation Practice",
    "Sentence Repetition",
    "Speech Articulation",
  ];

  @override
  void dispose() {
    _patientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient AppBar
      appBar: AppBar(
        title: const Text("Create Therapy Session"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CB8C4), Color(0xFF2D6A8E), Color(0xFF4CB8C4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.vertical,
        onStepContinue: () async {
          if (_currentStep == 0) {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _currentStep = 1);
            }
          } else {
            setState(() => _submitting = true);

            try {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance.collection('sessions').add({
                  'therapistId': user.uid,
                  'patientEmail': _patientController.text.trim(),
                  'status': _status,
                  'exercises': _selectedExercises,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              }

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Session Created in Firebase!")),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to create session: $e")),
                );
              }
            }

            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() => _submitting = false);
                Navigator.pop(context);
              }
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          final isLast = _currentStep == 1;

          return Row(
            children: [
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text("Back"),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: details.onStepContinue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isLast
                            ? [Color(0xFF4CB8C4), Color(0xFF2D6A8E)]
                            : [Color(0xFF1E3A5F), Color(0xFF2D6A8E)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isLast
                          ? (_submitting ? "Saving..." : "Save Session")
                          : "Next",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        steps: [
          // STEP 1
          Step(
            title: GradientText(
              "Session Details",
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A5F), Color(0xFF4CB8C4)],
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _patientController,
                    decoration: InputDecoration(
                      labelText: "Patient Email",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: InputDecoration(
                      labelText: "Status",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "ongoing",
                        child: Text("Ongoing"),
                      ),
                      DropdownMenuItem(
                        value: "completed",
                        child: Text("Completed"),
                      ),
                      DropdownMenuItem(
                        value: "canceled",
                        child: Text("Canceled"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _status = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // STEP 2
          Step(
            title: GradientText(
              "Attach Exercises",
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A5F), Color(0xFF4CB8C4)],
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select exercises to include. Tap to toggle selection.",
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _mockExercises
                      .map(
                        (exercise) => FilterChip(
                      label: Text(exercise),
                      avatar: Icon(
                        Icons.mic,
                        size: 18,
                        color: _selectedExercises.contains(exercise)
                            ? Colors.white
                            : Colors.blue,
                      ),
                      selected: _selectedExercises.contains(exercise),
                      selectedColor: const Color(0xFF2D6A8E),
                      checkmarkColor: Colors.white,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedExercises.add(exercise);
                          } else {
                            _selectedExercises.remove(exercise);
                          }
                        });
                      },
                    ),
                  )
                      .toList(),
                ),
                if (_selectedExercises.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "No exercises selected yet.",
                      style: TextStyle(color: Colors.orange.shade700),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================== GRADIENT TEXT WIDGET =====================
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(
      this.text, {
        super.key,
        this.style,
        required this.gradient,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style:
        style?.copyWith(color: Colors.white) ??
            const TextStyle(color: Colors.white),
      ),
    );
  }
}
