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

    return PopScope(
      canPop: state is KundaliWelcomeState,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final notifier = ref.read(kundaliFlowControllerProvider.notifier);
        if (state is KundaliInputState) {
          notifier.backToWelcome();
        } else if (state is KundaliSuccessState ||
            state is KundaliErrorState ||
            state is KundaliLoadingState) {
          // Loading usually shouldn't be interruptible, but for UX safety we can allow back to Input
          // Actually, let's map Success/Error -> Input (generate another) logic or similar?
          // The controller has 'generateAnother' which goes to input.
          // Or just standard back logic:
          // If Success -> back to Input?
          // If Error -> back to Input?
          // Let's assume backToWelcome is safe for now or we need a backToInput?
          // Input screen has a "Back" button that goes to Welcome.
          // So if we are in Success, back should probably go to Input (to edit details).
          // Checking the controller...
          // Controller has `editDetails` which goes to Input.
          notifier.editDetails(
            state is KundaliSuccessState
                ? state.details
                : (state is KundaliErrorState ? state.details : null),
          );
        }
      },
      child: switch (state) {
        KundaliWelcomeState() => WelcomeScreen(
          onStart: () =>
              ref.read(kundaliFlowControllerProvider.notifier).start(),
        ),
        KundaliInputState(:final prefill) => KundaliInputScreen(
          prefill: prefill,
        ),
        KundaliLoadingState() => const LoadingScreen(),
        KundaliSuccessState(:final details, :final chart) =>
          KundaliResultScreen(details: details, chart: chart),
        KundaliErrorState(:final failure, :final details) => KundaliErrorScreen(
          failure: failure,
          lastDetails: details,
        ),
      },
    );
  }
}
