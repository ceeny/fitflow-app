import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/core/theme/app_theme.dart';
import 'package:fitflow/features/workouts/presentation/workout_library_controller.dart';
import 'package:fitflow/features/workouts/domain/workout_models.dart';

class WorkoutLibraryScreen extends ConsumerWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(workoutLibraryControllerProvider);
    final controller = ref.read(workoutLibraryControllerProvider.notifier);
    final plansAsync = ref.watch(filteredWorkoutPlansProvider);

    final categories = ['All', 'Full Body', 'Chest', 'Back', 'Legs', 'Abs', 'HIIT'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Library'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Categories Filter
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = libraryState.selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => controller.setCategory(category),
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: AppTheme.surfaceColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              },
            ),
          ),
          
          // Workout Plans List
          Expanded(
            child: plansAsync.when(
              data: (plans) {
                if (plans.isEmpty) {
                  return const Center(child: Text('No workout plans found.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return _WorkoutPlanCard(plan: plan);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutPlanCard extends StatelessWidget {
  final WorkoutPlan plan;

  const _WorkoutPlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to Plan Detail or Player
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for Plan Image
            Container(
              height: 160,
              width: double.infinity,
              color: AppTheme.primaryColor.withOpacity(0.2),
              child: const Icon(Icons.fitness_center, size: 64, color: AppTheme.primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(plan.name, style: Theme.of(context).textTheme.titleLarge),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          plan.difficulty,
                          style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(plan.description, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('${plan.durationMinutes} mins', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 16),
                      const Icon(Icons.repeat, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('${plan.exercises.length} exercises', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
