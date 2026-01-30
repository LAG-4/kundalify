import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/onboarding/presentation/onboarding_flow.dart';

class KundalifyApp extends StatelessWidget {
  const KundalifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Kundali',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const OnboardingFlow(),
    );
  }
}
