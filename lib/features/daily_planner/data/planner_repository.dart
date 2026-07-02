import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitflow/features/daily_planner/domain/planner_models.dart';

class PlannerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveWorkoutLog(WorkoutLog log) async {
    await _firestore.collection('user_workout_logs').add(log.toMap());
    
    // Update user streak logic
    final userRef = _firestore.collection('users').doc(log.userId);
    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      if (userDoc.exists) {
        final lastWorkoutDate = (userDoc.data()?['lastWorkoutDate'] as Timestamp?)?.toDate();
        final today = DateTime.now();
        final currentStreak = userDoc.data()?['currentStreak'] ?? 0;

        if (lastWorkoutDate == null) {
          transaction.update(userRef, {
            'currentStreak': 1,
            'lastWorkoutDate': Timestamp.fromDate(today),
          });
        } else {
          final difference = today.difference(lastWorkoutDate).inDays;
          if (difference == 1) {
            transaction.update(userRef, {
              'currentStreak': currentStreak + 1,
              'lastWorkoutDate': Timestamp.fromDate(today),
            });
          } else if (difference > 1) {
            transaction.update(userRef, {
              'currentStreak': 1,
              'lastWorkoutDate': Timestamp.fromDate(today),
            });
          }
        }
      }
    });
  }

  Stream<List<WorkoutLog>> getWorkoutLogs(String userId) {
    return _firestore
        .collection('user_workout_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkoutLog.fromMap(doc.data(), doc.id))
            .toList());
  }
}
