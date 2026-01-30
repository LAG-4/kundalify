import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_primary_button.dart';
import '../../../../core/widgets/cosmic_scaffold.dart';
import '../../application/kundali_flow_controller.dart';
import '../../domain/birth_details.dart';
import '../../domain/kundali_failure.dart';

class KundaliErrorScreen extends ConsumerWidget {
  const KundaliErrorScreen({
    super.key,
    required this.failure,
    required this.lastDetails,
  });

  final KundaliFailure failure;
  final BirthDetails? lastDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CosmicScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      failure.title,
                      style: GoogleFonts.cinzel(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      failure.message,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.slate400,
                      ),
                    ),
                    if (kDebugMode && (failure.details ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          failure.details!,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.slate400,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: () => ref
                              .read(kundaliFlowControllerProvider.notifier)
                              .backToWelcome(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: const Text('Back to Welcome'),
                        ),
                        OutlinedButton(
                          onPressed: () => ref
                              .read(kundaliFlowControllerProvider.notifier)
                              .editDetails(lastDetails),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: const Text('Edit Details'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    DefaultTextStyle(
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                        color: Colors.white,
                      ),
                      child: CosmicPrimaryButton(
                        label: 'Try Again',
                        onPressed: () => ref
                            .read(kundaliFlowControllerProvider.notifier)
                            .tryAgain(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
