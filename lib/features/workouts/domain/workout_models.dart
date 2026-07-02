class Exercise {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final List<String> commonMistakes;
  final String difficulty;
  final List<String> categories;
  final List<String> targetMuscles;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.commonMistakes,
    required this.difficulty,
    required this.categories,
    required this.targetMuscles,
  });

  factory Exercise.fromMap(Map<String, dynamic> map, String id) {
    return Exercise(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      commonMistakes: List<String>.from(map['commonMistakes'] ?? []),
      difficulty: map['difficulty'] ?? 'Beginner',
      categories: List<String>.from(map['categories'] ?? []),
      targetMuscles: List<String>.from(map['targetMuscles'] ?? []),
    );
  }
}

class WorkoutPlan {
  final String id;
  final String name;
  final String description;
  final int durationMinutes;
  final String difficulty;
  final String goal;
  final List<PlanExercise> exercises;

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.difficulty,
    required this.goal,
    required this.exercises,
  });

  factory WorkoutPlan.fromMap(Map<String, dynamic> map, String id) {
    return WorkoutPlan(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 0,
      difficulty: map['difficulty'] ?? 'Beginner',
      goal: map['goal'] ?? 'Get active',
      exercises: (map['exercises'] as List)
          .map((e) => PlanExercise.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PlanExercise {
  final String exerciseId;
  final int sets;
  final int reps;

  PlanExercise({
    required this.exerciseId,
    required this.sets,
    required this.reps,
  });

  factory PlanExercise.fromMap(Map<String, dynamic> map) {
    return PlanExercise(
      exerciseId: map['exerciseId'] ?? '',
      sets: map['sets'] ?? 0,
      reps: map['reps'] ?? 0,
    );
  }
}
