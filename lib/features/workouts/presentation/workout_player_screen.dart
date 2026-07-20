import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/core/theme/app_theme.dart';
import 'package:fitflow/features/workouts/presentation/workout_player_controller.dart';
import 'package:fitflow/features/workouts/domain/workout_models.dart';

class WorkoutPlayerScreen extends ConsumerWidget {
  final WorkoutPlan plan;
  final List<Exercise> allExercises;

  const WorkoutPlayerScreen({
    super.key,
    required this.plan,
    required this.allExercises,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We create a provider for this specific session
    final playerProvider = StateNotifierProvider.autoDispose<WorkoutPlayerController, WorkoutPlayerState>((ref) {
      return WorkoutPlayerController(plan, allExercises);
    });

    final playerState = ref.watch(playerProvider);
    final controller = ref.read(playerProvider.notifier);
    final currentStep = playerState.currentStep;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (playerState.currentStepIndex + 1) / playerState.steps.length,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${playerState.currentStepIndex + 1}/${playerState.steps.length}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Exercise Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentStep.type == WorkoutStepType.exercise) ...[
                    // Exercise Video Placeholder
                    Container(
                      height: 300,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.play_circle_fill, size: 80, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      currentStep.exercise?.name ?? '',
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${currentStep.sets} Sets x ${currentStep.reps} Reps',
                      style: const TextStyle(color: AppTheme.primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ] else ...[
                    // Rest View
                    const Icon(Icons.timer, size: 100, color: AppTheme.primaryColor),
                    const SizedBox(height: 32),
                    const Text(
                      'REST',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${playerState.remainingSeconds}s',
                      style: const TextStyle(fontSize: 64, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 48, color: Colors.white),
                    onPressed: controller.previousStep,
                  ),
                  GestureDetector(
                    onTap: controller.togglePlayPause,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 48,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 48, color: Colors.white),
                    onPressed: controller.nextStep,
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
