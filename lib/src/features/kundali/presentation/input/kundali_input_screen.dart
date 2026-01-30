import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_primary_button.dart';
import '../../../../core/widgets/cosmic_scaffold.dart';
import '../../application/kundali_flow_controller.dart';
import '../../data/location_search_repository.dart';
import '../../domain/birth_details.dart';
import '../../domain/place_suggestion.dart';

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

  late final TextEditingController _cityController;
  late final TextEditingController _latController;
  late final TextEditingController _lonController;
  late final TextEditingController _tzController;

  bool _searchingCity = false;

  @override
  void initState() {
    super.initState();

    final prefill = widget.prefill;
    final now = DateTime.now();

    _date = prefill?.date ?? DateTime(now.year, now.month, now.day);
    _time = prefill == null
        ? TimeOfDay(hour: now.hour, minute: now.minute)
        : TimeOfDay(hour: prefill.time.hour, minute: prefill.time.minute);

    _cityController = TextEditingController();
    _latController = TextEditingController(
      text: prefill == null ? '' : prefill.latitude.toStringAsFixed(6),
    );
    _lonController = TextEditingController(
      text: prefill == null ? '' : prefill.longitude.toStringAsFixed(6),
    );

    final defaultTz = prefill?.timezone ?? 5.5;
    _tzController = TextEditingController(text: _formatTz(defaultTz));
  }

  @override
  void dispose() {
    _cityController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _tzController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<PlaceSuggestion?> _pickPlace(
    List<PlaceSuggestion> options, {
    required String query,
  }) async {
    if (!mounted) return null;

    return showModalBottomSheet<PlaceSuggestion>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.cosmic900.withValues(alpha: 0.98),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Select a place',
                            style: GoogleFonts.cinzel(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Results for "$query"',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.slate400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: AppColors.slate300,
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, index) => Divider(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    itemBuilder: (context, index) {
                      final place = options[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        title: Text(
                          place.label(),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          '${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                          style: GoogleFonts.inter(
                            color: AppColors.slate400,
                            fontSize: 12,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.north_east,
                          size: 18,
                          color: AppColors.slate300,
                        ),
                        onTap: () => Navigator.of(context).pop(place),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _searchCity() async {
    final query = _cityController.text.trim();
    if (query.isEmpty) {
      _showSnack('Enter a city/place to search');
      return;
    }
    if (_searchingCity) return;

    setState(() => _searchingCity = true);
    try {
      final repo = ref.read(locationSearchRepositoryProvider);
      final results = await repo.search(query, limit: 12);
      if (!mounted) return;

      if (results.isEmpty) {
        _showSnack('No results for "$query"');
        return;
      }

      final picked = await _pickPlace(results, query: query);
      if (!mounted || picked == null) return;

      setState(() {
        _cityController.text = picked.label();
        _latController.text = picked.latitude.toStringAsFixed(6);
        _lonController.text = picked.longitude.toStringAsFixed(6);
      });
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('City search failed: $e\n$st');
      }
      _showSnack('Could not search city. Please try again.');
    } finally {
      if (mounted) setState(() => _searchingCity = false);
    }
  }

  void _onCityChanged(String value) {
    final lat = _latController.text.trim();
    final lon = _lonController.text.trim();
    if (lat.isEmpty && lon.isEmpty) return;

    setState(() {
      _latController.clear();
      _lonController.clear();
    });
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
    if (!form.validate()) {
      _showSnack('Please review the form and try again.');
      return;
    }

    final lat = _parseDoubleField(_latController.text);
    final lon = _parseDoubleField(_lonController.text);
    if (lat == null || lon == null) {
      _showSnack('Search and select a city to auto-fill coordinates.');
      return;
    }
    if (lat < -90 || lat > 90) {
      _showSnack('Latitude must be between -90 and 90');
      return;
    }
    if (lon < -180 || lon > 180) {
      _showSnack('Longitude must be between -180 and 180');
      return;
    }

    final tz = _parseDoubleField(_tzController.text) ?? 5.5;
    if (tz < -12 || tz > 14) {
      _showSnack('Time zone must be between -12 and +14');
      return;
    }

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
                            TextFormField(
                              controller: _cityController,
                              style: GoogleFonts.inter(color: Colors.white),
                              textInputAction: TextInputAction.search,
                              onChanged: _onCityChanged,
                              onFieldSubmitted: (_) => _searchCity(),
                              decoration: InputDecoration(
                                labelText: 'City / Place',
                                hintText: 'e.g. Mumbai, India',
                                hintStyle: GoogleFonts.inter(
                                  color: AppColors.slate400,
                                ),
                                labelStyle: GoogleFonts.inter(
                                  color: AppColors.slate400,
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.05),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.10),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: AppColors.mysticPurple.withValues(
                                      alpha: 0.60,
                                    ),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _searchingCity
                                      ? null
                                      : _searchCity,
                                  tooltip: 'Search',
                                  icon: _searchingCity
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.search),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Search to auto-fill latitude & longitude.',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.slate400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ExpansionTile(
                              title: Text(
                                'Advanced Location Details',
                                style: GoogleFonts.inter(
                                  color: AppColors.slate300,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              collapsedIconColor: AppColors.slate400,
                              iconColor: AppColors.mysticPurple,
                              childrenPadding: const EdgeInsets.only(
                                top: 16,
                                bottom: 12,
                              ),
                              children: <Widget>[
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
                              ],
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
