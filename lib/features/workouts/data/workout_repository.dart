import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitflow/features/workouts/domain/workout_models.dart';

class WorkoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Exercise>> fetchExercises() async {
    final snapshot = await _firestore.collection('exercises').get();
    return snapshot.docs
        .map((doc) => Exercise.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<WorkoutPlan>> fetchWorkoutPlans({String? category, String? difficulty}) async {
    Query query = _firestore.collection('workout_plans');
    
    if (category != null) {
      query = query.where('categories', arrayContains: category);
    }
    if (difficulty != null) {
      query = query.where('difficulty', isEqualTo: difficulty);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => WorkoutPlan.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
