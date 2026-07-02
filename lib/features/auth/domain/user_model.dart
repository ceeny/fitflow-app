import 'package:cloud_firestore/cloud_firestore.dart';

class FitflowUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? goal;
  final String? fitnessLevel;
  final String? gender;
  final int? age;
  final DateTime createdAt;
  final int currentStreak;

  FitflowUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.goal,
    this.fitnessLevel,
    this.gender,
    this.age,
    required this.createdAt,
    this.currentStreak = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'goal': goal,
      'fitnessLevel': fitnessLevel,
      'gender': gender,
      'age': age,
      'createdAt': createdAt,
      'currentStreak': currentStreak,
    };
  }

  factory FitflowUser.fromMap(Map<String, dynamic> map) {
    return FitflowUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      goal: map['goal'],
      fitnessLevel: map['fitnessLevel'],
      gender: map['gender'],
      age: map['age'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      currentStreak: map['currentStreak'] ?? 0,
    );
  }

  FitflowUser copyWith({
    String? goal,
    String? fitnessLevel,
    String? gender,
    int? age,
    String? displayName,
  }) {
    return FitflowUser(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      goal: goal ?? this.goal,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      createdAt: createdAt,
      currentStreak: currentStreak,
    );
  }
}
