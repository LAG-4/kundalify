import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/onboarding_controller.dart';
import 'loading/loading_screen.dart';
import 'welcome/welcome_screen.dart';

class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(onboardingControllerProvider);

    return switch (step) {
      OnboardingStep.welcome => WelcomeScreen(
          onStart: () => ref.read(onboardingControllerProvider.notifier).start(),
        ),
      OnboardingStep.loading => const LoadingScreen(),
    };
  }
}
