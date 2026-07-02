import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitflow/features/progress/domain/progress_models.dart';

class ProgressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMeasurement(BodyMeasurement measurement) async {
    await _firestore.collection('user_measurements').add(measurement.toMap());
  }

  Stream<List<BodyMeasurement>> getMeasurements(String userId) {
    return _firestore
        .collection('user_measurements')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BodyMeasurement.fromMap(doc.data(), doc.id))
            .toList());
  }
}
