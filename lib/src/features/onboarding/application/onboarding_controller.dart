import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OnboardingStep { welcome, loading }

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingStep>(
      OnboardingController.new,
    );

class OnboardingController extends Notifier<OnboardingStep> {
  @override
  OnboardingStep build() => OnboardingStep.welcome;

  void start() => state = OnboardingStep.loading;

  void reset() => state = OnboardingStep.welcome;
}
