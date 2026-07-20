// main.dart
import 'package:final_app/Signup Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ================= COMMON SCREENS (DIRECTLY IN LIB) =================
import 'package:final_app/splash screen.dart';
import 'package:final_app/login screen.dart';

// ================= ROLE SELECTION =================
import 'package:final_app/role selection screen.dart';

// ================= PATIENT FLOW =================
import 'package:final_app/PATIENT FLOW/patient information screen.dart';
import 'package:final_app/PATIENT FLOW/diagnosis selection screen.dart';
import 'package:final_app/PATIENT FLOW/goal selection screen.dart';
import 'package:final_app/PATIENT FLOW/self-guided mode screen.dart';
import 'package:final_app/PATIENT FLOW/exercise category screen.dart';
import 'package:final_app/PATIENT FLOW/Detail Screen.dart';
import 'package:final_app/PATIENT FLOW/patient profile screen.dart';

// ================= THERAPIST FLOW =================
import 'package:final_app/THERAPIST FLOW/therapist dashboard screen.dart';
import 'package:final_app/THERAPIST FLOW/Create Therapy Session Screen.dart';
import 'package:final_app/THERAPIST FLOW/daily summary screen.dart';
import 'package:final_app/THERAPIST FLOW/progress report.dart';
import 'package:final_app/THERAPIST FLOW/send to therapist screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: PostStrokeApp()));
}

class PostStrokeApp extends StatelessWidget {
  const PostStrokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Stroke Speech Therapy',

      theme: ThemeData(
        primaryColor: const Color(0xFF4A90E2),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),

      initialRoute: "/",

      routes: {
        // ================= COMMON FLOW =================
        "/": (context) => const SplashScreen(),
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/roleSelection": (context) => const RoleSelectionScreen(),

        // ================= PATIENT FLOW =================
        "/patientInfo": (context) => const WhoWillDoTherapyScreen(),
        "/diagnosis": (context) => const DiagnosisSelectionScreen(),
        "/goalSelection": (context) => const GoalSelectionScreen(),
        "/patientDashboardScreen": (context) =>
        const TherapistDashboardScreen(),
        "/selfGuided": (context) => const SelfGuidedModeScreen(),
        "/exerciseCategory": (context) => const ExerciseCategoryScreen(),
        "/exerciseSession": (context) => const ExerciseSessionScreen(),
        "/patientProfile": (context) => const ProfileScreen(),

        // ================= THERAPIST FLOW =================
        "/therapistDashboard": (context) => const TherapistDashboardScreen(),
        "/createSession": (context) => const CreateTherapySessionScreen(),
        "/dailySummary": (context) => const DailySummaryScreen(),
        "/sendReport": (context) => const ProgressReportsScreen(),

        "/sendToTherapist": (context) =>
            SendToTherapistScreen(selectedDate: DateTime.now()),
      },
    );
  }
}
