import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/presentation/loading/loading_screen.dart';
import '../../onboarding/presentation/welcome/welcome_screen.dart';
import '../application/kundali_flow_controller.dart';
import 'error/kundali_error_screen.dart';
import 'input/kundali_input_screen.dart';
import 'result/kundali_result_screen.dart';

class KundaliFlow extends ConsumerWidget {
  const KundaliFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(kundaliFlowControllerProvider);

    return switch (state) {
      KundaliWelcomeState() => WelcomeScreen(
        onStart: () => ref.read(kundaliFlowControllerProvider.notifier).start(),
      ),
      KundaliInputState(:final prefill) => KundaliInputScreen(prefill: prefill),
      KundaliLoadingState() => const LoadingScreen(),
      KundaliSuccessState(:final details, :final chart) => KundaliResultScreen(
        details: details,
        chart: chart,
      ),
      KundaliErrorState(:final failure, :final details) => KundaliErrorScreen(
        failure: failure,
        lastDetails: details,
      ),
    };
  }
}
