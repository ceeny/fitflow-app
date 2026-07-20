import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/features/workouts/domain/workout_models.dart';
import 'package:fitflow/features/workouts/data/workout_repository.dart';

final workoutRepositoryProvider = Provider((ref) => WorkoutRepository());

final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.fetchExercises();
});

class WorkoutLibraryState {
  final String selectedCategory;
  final String? selectedDifficulty;

  WorkoutLibraryState({
    this.selectedCategory = 'All',
    this.selectedDifficulty,
  });

  WorkoutLibraryState copyWith({
    String? selectedCategory,
    String? selectedDifficulty,
  }) {
    return WorkoutLibraryState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
    );
  }
}

class WorkoutLibraryController extends StateNotifier<WorkoutLibraryState> {
  WorkoutLibraryController() : super(WorkoutLibraryState());

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setDifficulty(String? difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
  }
}

final workoutLibraryControllerProvider =
    StateNotifierProvider<WorkoutLibraryController, WorkoutLibraryState>((ref) {
  return WorkoutLibraryController();
});

final filteredWorkoutPlansProvider = FutureProvider<List<WorkoutPlan>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  final libraryState = ref.watch(workoutLibraryControllerProvider);
  
  return repository.fetchWorkoutPlans(
    category: libraryState.selectedCategory == 'All' ? null : libraryState.selectedCategory,
    difficulty: libraryState.selectedDifficulty,
  );
});
