import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/astrology_repository.dart';
import '../domain/birth_details.dart';
import '../domain/kundali_chart.dart';
import '../domain/kundali_failure.dart';

sealed class KundaliFlowState {
  const KundaliFlowState();
}

class KundaliWelcomeState extends KundaliFlowState {
  const KundaliWelcomeState();
}

class KundaliInputState extends KundaliFlowState {
  const KundaliInputState({this.prefill});
  final BirthDetails? prefill;
}

class KundaliLoadingState extends KundaliFlowState {
  const KundaliLoadingState({required this.details});
  final BirthDetails details;
}

class KundaliSuccessState extends KundaliFlowState {
  const KundaliSuccessState({required this.details, required this.chart});

  final BirthDetails details;
  final KundaliChartData chart;
}

class KundaliErrorState extends KundaliFlowState {
  const KundaliErrorState({required this.failure, this.details});

  final KundaliFailure failure;
  final BirthDetails? details;
}

final kundaliFlowControllerProvider =
    NotifierProvider<KundaliFlowController, KundaliFlowState>(
      KundaliFlowController.new,
    );

class KundaliFlowController extends Notifier<KundaliFlowState> {
  int _requestId = 0;

  @override
  KundaliFlowState build() => const KundaliWelcomeState();

  void backToWelcome() {
    state = const KundaliWelcomeState();
  }

  void start() {
    state = const KundaliInputState();
  }

  void editDetails(BirthDetails? prefill) {
    state = KundaliInputState(prefill: prefill);
  }

  void generateAnother(BirthDetails? prefill) {
    state = KundaliInputState(prefill: prefill);
  }

  Future<void> submit(BirthDetails details) async {
    final current = ++_requestId;
    state = KundaliLoadingState(details: details);

    try {
      final repo = ref.read(astrologyRepositoryProvider);
      final chart = await repo.fetchKundali(details);
      if (current != _requestId) return;
      state = KundaliSuccessState(details: details, chart: chart);
    } on KundaliFailure catch (e) {
      if (current != _requestId) return;
      state = KundaliErrorState(failure: e, details: details);
    }
  }

  Future<void> tryAgain() async {
    final currentState = state;
    final details = switch (currentState) {
      KundaliLoadingState(:final details) => details,
      KundaliSuccessState(:final details) => details,
      KundaliErrorState(:final details) => details,
      _ => null,
    };
    if (details == null) return;
    await submit(details);
  }
}
