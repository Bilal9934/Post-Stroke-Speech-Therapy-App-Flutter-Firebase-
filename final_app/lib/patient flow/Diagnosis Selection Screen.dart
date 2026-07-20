// lib/screens/auth/diagnosis_selection_screen.dart
import 'package:final_app/PATIENT FLOW/Goal Selection Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiagnosisSelectionScreen extends StatefulWidget {
  const DiagnosisSelectionScreen({super.key});

  @override
  State<DiagnosisSelectionScreen> createState() =>
      _DiagnosisSelectionScreenState();
}

class _DiagnosisSelectionScreenState extends State<DiagnosisSelectionScreen> {
  final Set<String> _selected = {};

  // ✅ Removed "Other" to prevent bottom overflow
  final List<String> _options = ['Aphasia', 'Apraxia', 'Dysarthria'];

  bool _isLoading = false;

  Future<void> _handleContinue() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one diagnosis/condition'),
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
          'diagnoses': _selected.toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GoalSelectionScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving diagnosis: $e'),
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
    const primaryColor = Color(0xFF2D6A8E);
    const highlightColor = Color(0xFF4CB8C4);
    const unselectedColorStart = Color(0xFFE0E6ED);
    const unselectedColorEnd = Color(0xFFF5F7FA);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Condition'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                size: 70, // slightly reduced to prevent overflow
                color: primaryColor,
              ),

              const SizedBox(height: 20),

              Text(
                'Select Your Diagnosis/Condition',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              Text(
                'Select all that apply. This helps us personalize your therapy program.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              ..._options.map((diagnosis) {
                final isSelected = _selected.contains(diagnosis);
                return _DiagnosisTile(
                  label: diagnosis,
                  isSelected: isSelected,
                  primaryColor: primaryColor,
                  highlightColor: highlightColor,
                  unselectedGradient: const LinearGradient(
                    colors: [unselectedColorStart, unselectedColorEnd],
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(diagnosis);
                      } else {
                        _selected.add(diagnosis);
                      }
                    });
                  },
                );
              }),

              const Spacer(),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              if (_selected.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Please select at least one option to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Diagnosis Tile ---
class _DiagnosisTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;
  final Color highlightColor;
  final LinearGradient unselectedGradient;

  const _DiagnosisTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    required this.highlightColor,
    required this.unselectedGradient,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(colors: [highlightColor, primaryColor])
            : unselectedGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? highlightColor : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? Colors.white : Colors.grey.shade600,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.done, color: Colors.white)
            : null,
      ),
    );
  }
}
