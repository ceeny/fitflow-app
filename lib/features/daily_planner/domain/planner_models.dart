import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutLog {
  final String id;
  final String userId;
  final String workoutPlanId;
  final String workoutPlanName;
  final DateTime date;
  final int durationMinutes;
  final String mood;
  final String? notes;
  final List<ExerciseLog> exerciseLogs;

  WorkoutLog({
    required this.id,
    required this.userId,
    required this.workoutPlanId,
    required this.workoutPlanName,
    required this.date,
    required this.durationMinutes,
    required this.mood,
    this.notes,
    required this.exerciseLogs,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'workoutPlanId': workoutPlanId,
      'workoutPlanName': workoutPlanName,
      'date': Timestamp.fromDate(date),
      'durationMinutes': durationMinutes,
      'mood': mood,
      'notes': notes,
      'exerciseLogs': exerciseLogs.map((e) => e.toMap()).toList(),
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map, String id) {
    return WorkoutLog(
      id: id,
      userId: map['userId'] ?? '',
      workoutPlanId: map['workoutPlanId'] ?? '',
      workoutPlanName: map['workoutPlanName'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      durationMinutes: map['durationMinutes'] ?? 0,
      mood: map['mood'] ?? 'Okay',
      notes: map['notes'],
      exerciseLogs: (map['exerciseLogs'] as List)
          .map((e) => ExerciseLog.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExerciseLog {
  final String exerciseId;
  final String exerciseName;
  final int sets;
  final int reps;

  ExerciseLog({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'sets': sets,
      'reps': reps,
    };
  }

  factory ExerciseLog.fromMap(Map<String, dynamic> map) {
    return ExerciseLog(
      exerciseId: map['exerciseId'] ?? '',
      exerciseName: map['exerciseName'] ?? '',
      sets: map['sets'] ?? 0,
      reps: map['reps'] ?? 0,
    );
  }
}
