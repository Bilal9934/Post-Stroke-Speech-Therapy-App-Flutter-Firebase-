import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            _name.text = data['name'] ?? '';
            _email.text = data['email'] ?? user.email ?? '';
            _firstName.text = data['firstName'] ?? '';
            _lastName.text = data['lastName'] ?? '';
            _age.text = data['age']?.toString() ?? '';
            _medicalRecord.text = data['medicalRecord'] ?? '';
            _licenseNumber.text = data['licenseNumber'] ?? '';
            _clinic.text = data['clinic'] ?? '';
            _relation.text = data['relation'] ?? '';
            _therapistEmail.text = data['therapistEmail'] ?? '';
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
    }
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _medicalRecord = TextEditingController();
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _clinic = TextEditingController();
  final TextEditingController _relation = TextEditingController();
  final TextEditingController _therapistEmail = TextEditingController();

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _name.text,
          'email': _email.text,
          'firstName': _firstName.text,
          'lastName': _lastName.text,
          'age': int.tryParse(_age.text),
          'medicalRecord': _medicalRecord.text,
          'licenseNumber': _licenseNumber.text,
          'clinic': _clinic.text,
          'relation': _relation.text,
          'therapistEmail': _therapistEmail.text,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully.'),
            backgroundColor: Color(0xFF1E3A5F),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
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

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF4F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F6FA),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1E3A5F)),
        ),
      );
    }

    final content = SingleChildScrollView(
      child: Column(
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 40),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF142635), Color(0xFF1E3A5F)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 45, color: Color(0xFF1E3A5F)),
                ),
                SizedBox(height: 14),
                Text(
                  "User Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Manage personal and medical information",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ===== BASIC INFO =====
                  _ModernCard(
                    title: "Basic Information",
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _name,
                          decoration: _inputStyle("Full Name"),
                          validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _email,
                          decoration: _inputStyle("Email"),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstName,
                                decoration: _inputStyle("First Name"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _lastName,
                                decoration: _inputStyle("Last Name"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _age,
                          keyboardType: TextInputType.number,
                          decoration: _inputStyle("Age"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== MEDICAL INFO =====
                  _ModernCard(
                    title: "Medical Information",
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _medicalRecord,
                          decoration: _inputStyle("Medical Record Number"),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _licenseNumber,
                          decoration: _inputStyle("License Number"),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _clinic,
                          decoration: _inputStyle("Clinic Name"),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _relation,
                          decoration: _inputStyle("Relation to Patient"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== THERAPIST =====
                  _ModernCard(
                    title: "Assigned Therapist",
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _therapistEmail,
                          decoration: _inputStyle("Therapist Email"),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            label: const Text("Add Therapist"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1E3A5F),
                              side: const BorderSide(color: Color(0xFF1E3A5F)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== SAVE BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A5F),
                        foregroundColor:
                        Colors.white, // ✅ This makes text white
                        padding: const EdgeInsets.symmetric(vertical: 18),
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
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white, // ✅ Force white text
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.embedded) return SafeArea(child: content);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(child: content),
    );
  }
}

class _ModernCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ModernCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
