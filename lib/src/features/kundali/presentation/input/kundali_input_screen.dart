import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_primary_button.dart';
import '../../../../core/widgets/cosmic_scaffold.dart';
import '../../application/kundali_flow_controller.dart';
import '../../domain/birth_details.dart';

class KundaliInputScreen extends ConsumerStatefulWidget {
  const KundaliInputScreen({super.key, this.prefill});

  final BirthDetails? prefill;

  @override
  ConsumerState<KundaliInputScreen> createState() => _KundaliInputScreenState();
}

class _KundaliInputScreenState extends ConsumerState<KundaliInputScreen> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _date;
  late TimeOfDay _time;

  late final TextEditingController _latController;
  late final TextEditingController _lonController;
  late final TextEditingController _tzController;

  @override
  void initState() {
    super.initState();

    final prefill = widget.prefill;
    final now = DateTime.now();

    _date = prefill?.date ?? DateTime(now.year, now.month, now.day);
    _time = prefill == null
        ? TimeOfDay(hour: now.hour, minute: now.minute)
        : TimeOfDay(hour: prefill.time.hour, minute: prefill.time.minute);

    _latController = TextEditingController(
      text: prefill == null ? '' : prefill.latitude.toStringAsFixed(6),
    );
    _lonController = TextEditingController(
      text: prefill == null ? '' : prefill.longitude.toStringAsFixed(6),
    );

    final defaultTz =
        prefill?.timezone ?? (now.timeZoneOffset.inMinutes / 60.0);
    _tzController = TextEditingController(text: _formatTz(defaultTz));
  }

  @override
  void dispose() {
    _latController.dispose();
    _lonController.dispose();
    _tzController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatTz(double tz) {
    final str = tz.toStringAsFixed(tz * 2 == (tz * 2).roundToDouble() ? 1 : 2);
    return str;
  }

  double? _parseDoubleField(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return null;
    return double.tryParse(v);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked == null) return;
    setState(() => _date = DateTime(picked.year, picked.month, picked.day));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked == null) return;
    setState(() => _time = picked);
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    final lat = _parseDoubleField(_latController.text)!;
    final lon = _parseDoubleField(_lonController.text)!;
    final tz =
        _parseDoubleField(_tzController.text) ??
        (DateTime.now().timeZoneOffset.inMinutes / 60.0);

    final details = BirthDetails(
      date: _date,
      time: BirthTime(hour: _time.hour, minute: _time.minute),
      latitude: lat,
      longitude: lon,
      timezone: tz,
    );

    ref.read(kundaliFlowControllerProvider.notifier).submit(details);
  }

  @override
  Widget build(BuildContext context) {
    return CosmicScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => ref
                            .read(kundaliFlowControllerProvider.notifier)
                            .backToWelcome(),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.slate300,
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Birth Details',
                      style: GoogleFonts.cinzel(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Enter the details below to generate your North Indian kundali.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            _PickerField(
                              label: 'Date of Birth',
                              value: _formatDate(_date),
                              onTap: _pickDate,
                            ),
                            const SizedBox(height: 16),
                            _PickerField(
                              label: 'Time of Birth (24h)',
                              value: _formatTime(_time),
                              onTap: _pickTime,
                            ),
                            const SizedBox(height: 16),
                            _NumberField(
                              label: 'Latitude',
                              hintText: 'e.g. 19.0760',
                              controller: _latController,
                              validator: (v) {
                                final parsed = _parseDoubleField(v ?? '');
                                if (parsed == null) {
                                  return 'Latitude is required';
                                }
                                if (parsed < -90 || parsed > 90) {
                                  return 'Latitude must be between -90 and 90';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _NumberField(
                              label: 'Longitude',
                              hintText: 'e.g. 72.8777',
                              controller: _lonController,
                              validator: (v) {
                                final parsed = _parseDoubleField(v ?? '');
                                if (parsed == null) {
                                  return 'Longitude is required';
                                }
                                if (parsed < -180 || parsed > 180) {
                                  return 'Longitude must be between -180 and 180';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _NumberField(
                              label: 'Time Zone (UTC offset)',
                              hintText: 'e.g. 5.5 for IST',
                              controller: _tzController,
                              validator: (v) {
                                final parsed = _parseDoubleField(v ?? '');
                                if (parsed == null) {
                                  return 'Time zone is required';
                                }
                                if (parsed < -12 || parsed > 14) {
                                  return 'Time zone must be between -12 and +14';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            DefaultTextStyle(
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                                color: Colors.white,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: CosmicPrimaryButton(
                                  label: 'Generate',
                                  onPressed: _submit,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'We do not store your data. API keys are provided via --dart-define.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                height: 1.4,
                                color: AppColors.slate400,
                              ),
                            ),
                          ],
                        ),
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

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: AppColors.slate400),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.mysticPurple.withValues(alpha: 0.60),
            ),
          ),
        ),
        child: Text(value, style: GoogleFonts.inter(color: Colors.white)),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.validator,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.inter(color: Colors.white),
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: AppColors.slate400),
        labelStyle: GoogleFonts.inter(color: AppColors.slate400),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.mysticPurple.withValues(alpha: 0.60),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.60),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.80),
          ),
        ),
      ),
      validator: validator,
    );
  }
}
