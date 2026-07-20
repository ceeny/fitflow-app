import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/features/workouts/domain/workout_models.dart';

enum WorkoutStepType { exercise, rest }

class WorkoutStep {
  final WorkoutStepType type;
  final Exercise? exercise;
  final int? durationSeconds;
  final int? sets;
  final int? reps;

  WorkoutStep({
    required this.type,
    this.exercise,
    this.durationSeconds,
    this.sets,
    this.reps,
  });
}

class WorkoutPlayerState {
  final WorkoutPlan plan;
  final List<WorkoutStep> steps;
  final int currentStepIndex;
  final bool isPlaying;
  final int remainingSeconds;

  WorkoutPlayerState({
    required this.plan,
    required this.steps,
    this.currentStepIndex = 0,
    this.isPlaying = false,
    this.remainingSeconds = 0,
  });

  WorkoutStep get currentStep => steps[currentStepIndex];

  WorkoutPlayerState copyWith({
    int? currentStepIndex,
    bool? isPlaying,
    int? remainingSeconds,
  }) {
    return WorkoutPlayerState(
      plan: plan,
      steps: steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}

class WorkoutPlayerController extends StateNotifier<WorkoutPlayerState> {
  Timer? _timer;

  WorkoutPlayerController(WorkoutPlan plan, List<Exercise> allExercises)
      : super(_initializeState(plan, allExercises));

  static WorkoutPlayerState _initializeState(WorkoutPlan plan, List<Exercise> allExercises) {
    final steps = <WorkoutStep>[];
    for (final planEx in plan.exercises) {
      final exercise = allExercises.firstWhere((e) => e.id == planEx.exerciseId);
      steps.add(WorkoutStep(
        type: WorkoutStepType.exercise,
        exercise: exercise,
        sets: planEx.sets,
        reps: planEx.reps,
      ));
      // Add rest after each exercise except the last one
      if (plan.exercises.indexOf(planEx) < plan.exercises.length - 1) {
        steps.add(WorkoutStep(type: WorkoutStepType.rest, durationSeconds: 30));
      }
    }
    return WorkoutPlayerState(
      plan: plan,
      steps: steps,
      remainingSeconds: steps.first.durationSeconds ?? 0,
    );
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      _timer?.cancel();
      state = state.copyWith(isPlaying: false);
    } else {
      state = state.copyWith(isPlaying: true);
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        nextStep();
      }
    });
  }

  void nextStep() {
    if (state.currentStepIndex < state.steps.length - 1) {
      final nextIndex = state.currentStepIndex + 1;
      state = state.copyWith(
        currentStepIndex: nextIndex,
        remainingSeconds: state.steps[nextIndex].durationSeconds ?? 0,
      );
    } else {
      _timer?.cancel();
      state = state.copyWith(isPlaying: false);
      // Workout completed logic
    }
  }

  void previousStep() {
    if (state.currentStepIndex > 0) {
      final prevIndex = state.currentStepIndex - 1;
      state = state.copyWith(
        currentStepIndex: prevIndex,
        remainingSeconds: state.steps[prevIndex].durationSeconds ?? 0,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
