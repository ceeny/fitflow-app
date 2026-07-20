import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/core/theme/app_theme.dart';
import 'package:fitflow/features/auth/presentation/goal_selection_screen.dart';
import 'package:fitflow/features/workouts/presentation/workout_library_screen.dart';
import 'package:fitflow/features/daily_planner/presentation/daily_planner_screen.dart';
import 'package:fitflow/features/progress/presentation/progress_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization would happen here in a real environment
  
  runApp(
    const ProviderScope(
      child: FitflowApp(),
    ),
  );
}

class FitflowApp extends StatelessWidget {
  const FitflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitflow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Using a simple home for now, in a real app this would be a GoRouter
      home: const MainNavigationHandler(),
    );
  }
}

class MainNavigationHandler extends StatefulWidget {
  const MainNavigationHandler({super.key});

  @override
  State<MainNavigationHandler> createState() => _MainNavigationHandlerState();
}

class _MainNavigationHandlerState extends State<MainNavigationHandler> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    GoalSelectionScreen(),
    WorkoutLibraryScreen(),
    DailyPlannerScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
