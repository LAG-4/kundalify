import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_primary_button.dart';
import '../../../../core/widgets/cosmic_scaffold.dart';
import '../../application/kundali_flow_controller.dart';
import '../../domain/birth_details.dart';
import '../../domain/kundali_chart.dart';
import 'north_indian_kundali_chart.dart';

class KundaliResultScreen extends ConsumerStatefulWidget {
  const KundaliResultScreen({
    super.key,
    required this.details,
    required this.chart,
  });

  final BirthDetails details;
  final KundaliChartData chart;

  @override
  ConsumerState<KundaliResultScreen> createState() =>
      _KundaliResultScreenState();
}

class _KundaliResultScreenState extends ConsumerState<KundaliResultScreen> {
  final GlobalKey _chartKey = GlobalKey();
  bool _exporting = false;

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  Future<Uint8List> _capturePngBytes() async {
    final boundary =
        _chartKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw StateError('Chart boundary not found');
    }

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw StateError('Failed to encode PNG');
    }

    return byteData.buffer.asUint8List();
  }

  Future<File> _writeTempFile(
    Uint8List bytes, {
    required String fileName,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    return file.writeAsBytes(bytes, flush: true);
  }

  Future<File> _writeDocFile(
    Uint8List bytes, {
    required String fileName,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    return file.writeAsBytes(bytes, flush: true);
  }

  Future<void> _withExporting(Future<void> Function() task) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      await task();
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Export failed: $e\n$st');
      }
      _showSnack('Could not export chart. Please try again.');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _shareChart() async {
    await _withExporting(() async {
      final bytes = await _capturePngBytes();
      final file = await _writeTempFile(
        bytes,
        fileName: 'kundali_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await SharePlus.instance.share(
        ShareParams(
          text: 'My Kundali (North Indian chart)',
          files: <XFile>[XFile(file.path)],
        ),
      );
    });
  }

  Future<void> _saveChart() async {
    await _withExporting(() async {
      final bytes = await _capturePngBytes();
      final file = await _writeDocFile(
        bytes,
        fileName: 'kundali_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      _showSnack('Saved to ${file.path}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.details;
    final chart = widget.chart;

    return CosmicScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () => ref
                              .read(kundaliFlowControllerProvider.notifier)
                              .editDetails(details),
                          icon: const Icon(Icons.edit),
                          color: AppColors.slate300,
                          tooltip: 'Edit details',
                        ),
                        const Spacer(),
                        Text(
                          'Lagna: ${chart.ascendant.displayName}',
                          style: GoogleFonts.inter(
                            color: AppColors.slate300,
                            fontSize: 13,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Kundali',
                      style: GoogleFonts.cinzel(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'DOB ${_formatDate(details.date)}  •  TOB ${details.time.format24h()}  •  Lat ${details.latitude.toStringAsFixed(4)}  •  Lon ${details.longitude.toStringAsFixed(4)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.slate400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          RepaintBoundary(
                            key: _chartKey,
                            child: NorthIndianKundaliChart(data: chart),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              OutlinedButton.icon(
                                onPressed: _exporting ? null : _shareChart,
                                icon: const Icon(Icons.share),
                                label: const Text('Share'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: _exporting ? null : _saveChart,
                                icon: const Icon(Icons.save_alt),
                                label: const Text('Save'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          DefaultTextStyle(
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                              color: Colors.white,
                            ),
                            child: CosmicPrimaryButton(
                              label: _exporting
                                  ? 'Please wait...'
                                  : 'Generate Another',
                              onPressed: _exporting
                                  ? () {}
                                  : () => ref
                                        .read(
                                          kundaliFlowControllerProvider
                                              .notifier,
                                        )
                                        .generateAnother(details),
                              trailing: _exporting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          if (kDebugMode)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Tip: Use --dart-define to configure your API keys for accurate results.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.slate400,
                                ),
                              ),
                            ),
                        ],
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
