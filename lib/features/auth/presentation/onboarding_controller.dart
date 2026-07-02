import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitflow/features/auth/domain/user_model.dart';

class OnboardingState {
  final String? goal;
  final String? fitnessLevel;
  final String? gender;
  final int? age;
  final bool isLoading;

  OnboardingState({
    this.goal,
    this.fitnessLevel,
    this.gender,
    this.age,
    this.isLoading = false,
  });

  OnboardingState copyWith({
    String? goal,
    String? fitnessLevel,
    String? gender,
    int? age,
    bool? isLoading,
  }) {
    return OnboardingState(
      goal: goal ?? this.goal,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(OnboardingState());

  void setGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void setFitnessLevel(String level) {
    state = state.copyWith(fitnessLevel: level);
  }

  void setProfileDetails({String? gender, int? age}) {
    state = state.copyWith(gender: gender, age: age);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true);
    // Here we would call the repository to save user data to Firestore
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    state = state.copyWith(isLoading: false);
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController();
});
