import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/core/theme/app_theme.dart';
import 'package:fitflow/features/daily_planner/domain/planner_models.dart';
import 'package:intl/intl.dart';

class DailyPlannerScreen extends ConsumerWidget {
  const DailyPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, we'd fetch these from the repository via a stream provider
    final dummyLogs = [
      WorkoutLog(
        id: '1',
        userId: 'u1',
        workoutPlanId: 'p1',
        workoutPlanName: 'Full Body Blast',
        date: DateTime.now(),
        durationMinutes: 25,
        mood: 'Energized',
        exerciseLogs: [],
      ),
      WorkoutLog(
        id: '2',
        userId: 'u1',
        workoutPlanId: 'p2',
        workoutPlanName: 'Core Strength',
        date: DateTime.now().subtract(const Duration(days: 1)),
        durationMinutes: 15,
        mood: 'Tired but good',
        exerciseLogs: [],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekly Calendar Strip Placeholder
          Container(
            padding: const EdgeInsets.all(16),
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index - 3));
                final isToday = index == 3;
                return Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isToday ? AppTheme.primaryColor : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(color: isToday ? Colors.black : Colors.white70),
                      ),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: isToday ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Recent History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyLogs.length,
              itemBuilder: (context, index) {
                final log = dummyLogs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(log.workoutPlanName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${DateFormat('MMM d, yyyy').format(log.date)} • ${log.durationMinutes} mins'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.sentiment_satisfied_alt, color: AppTheme.primaryColor),
                        Text(log.mood, style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
