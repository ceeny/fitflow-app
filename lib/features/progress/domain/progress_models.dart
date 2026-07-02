import 'package:cloud_firestore/cloud_firestore.dart';

class BodyMeasurement {
  final String id;
  final String userId;
  final DateTime date;
  final double? weightKg;
  final double? waistCm;
  final String? photoUrl;

  BodyMeasurement({
    required this.id,
    required this.userId,
    required this.date,
    this.weightKg,
    this.waistCm,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'weightKg': weightKg,
      'waistCm': waistCm,
      'photoUrl': photoUrl,
    };
  }

  factory BodyMeasurement.fromMap(Map<String, dynamic> map, String id) {
    return BodyMeasurement(
      id: id,
      userId: map['userId'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      weightKg: map['weightKg']?.toDouble(),
      waistCm: map['waistCm']?.toDouble(),
      photoUrl: map['photoUrl'],
    );
  }
}
