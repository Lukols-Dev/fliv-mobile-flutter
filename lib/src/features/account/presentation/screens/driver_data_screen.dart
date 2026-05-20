import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/driver/application/driver_profile_provider.dart';
import 'package:mobile/src/features/driver/data/driver_repository_impl.dart';
import 'package:mobile/src/features/driver/domain/driver_profile.dart';
import 'package:mobile/src/features/driver/domain/update_driver_documents_payload.dart';

class DriverDataScreen extends ConsumerStatefulWidget {
  const DriverDataScreen({super.key});

  @override
  ConsumerState<DriverDataScreen> createState() => _DriverDataScreenState();
}

class _DriverDataScreenState extends ConsumerState<DriverDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final _visaDeadlineController = TextEditingController();
  final _licenseDeadlineController = TextEditingController();
  final _workPermitDeadlineController = TextEditingController();
  final _medicalExamDeadlineController = TextEditingController();
  final _psychologicalExamDeadlineController = TextEditingController();
  final _driverCardDeadlineController = TextEditingController();
  final _residenceCardDeadlineController = TextEditingController();
  final _driverCertificateDeadlineController = TextEditingController();
  bool _didSetInitialValues = false;
  bool _isSaving = false;
  bool _submittedOnce = false;

  @override
  void dispose() {
    _visaDeadlineController.dispose();
    _licenseDeadlineController.dispose();
    _workPermitDeadlineController.dispose();
    _medicalExamDeadlineController.dispose();
    _psychologicalExamDeadlineController.dispose();
    _driverCardDeadlineController.dispose();
    _residenceCardDeadlineController.dispose();
    _driverCertificateDeadlineController.dispose();
    super.dispose();
  }

  void _applyProfileOnce(DriverProfile p) {
    if (_didSetInitialValues) return;
    _didSetInitialValues = true;

    _visaDeadlineController.text = _formatDate(p.visaExpiresAt);
    _licenseDeadlineController.text = _formatDate(p.drivingLicenseExpiresAt);
    _workPermitDeadlineController.text = _formatDate(p.workPermitExpiresAt);
    _medicalExamDeadlineController.text = _formatDate(p.medicalCheckExpiresAt);
    _psychologicalExamDeadlineController.text = _formatDate(
      p.psychCheckExpiresAt,
    );
    _driverCardDeadlineController.text = _formatDate(p.driverCardExpiresAt);
    _residenceCardDeadlineController.text = _formatDate(
      p.residenceCardExpiresAt,
    );
    _driverCertificateDeadlineController.text = _formatDate(
      p.driverCertificateExpiresAt,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final d = date.toLocal();
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  DateTime? _parseDate(String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    final parts = v.split('.');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    final dt = DateTime.utc(year, month, day);
    // Ensure the date wasn't auto-normalized (e.g. 32.01.2026 -> 01.02.2026)
    if (dt.year != year || dt.month != month || dt.day != day) return null;
    return dt;
  }

  String? _validateOptionalDate(String? value, AppLocalizations t) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return null;
    final dt = _parseDate(v);
    if (dt == null) return t.driver_data_invalid_date;
    return null;
  }

  String? _toIsoOrNull(TextEditingController c) {
    final dt = _parseDate(c.text);
    return dt?.toIso8601String();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F4D46),
              onPrimary: Colors.white,
              onSurface: Color(0xFF111827),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate =
          '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
      controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(driverProfileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F4D46)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${t.driver_data_fetch_failed}\n$e',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => ref.invalidate(driverProfileProvider),
                    child: Text(t.common_retry),
                  ),
                ],
              ),
            ),
          ),
          data: (profile) {
            // set initial values once
            _applyProfileOnce(profile);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _submittedOnce
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),

                      // TITLE
                      Center(
                        child: Text(
                          t.profile_driver_data,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // VISA DEADLINE
                      _DateInputField(
                        label: t.driver_data_visa_deadline,
                        controller: _visaDeadlineController,
                        enabled: !_isSaving,
                        validator: (v) => _validateOptionalDate(v, t),
                        onTap: () =>
                            _selectDate(context, _visaDeadlineController),
                      ),

                      const SizedBox(height: 20),

                      // LICENSE DEADLINE
                      _DateInputField(
                        label: t.driver_data_license_deadline,
                        controller: _licenseDeadlineController,
                        enabled: !_isSaving,
                        validator: (v) => _validateOptionalDate(v, t),
                        onTap: () =>
                            _selectDate(context, _licenseDeadlineController),
                      ),

                      const SizedBox(height: 20),

                      // WORK PERMIT DEADLINE
                      _DateInputField(
                        label: t.driver_data_work_permit_deadline,
                        controller: _workPermitDeadlineController,
                        enabled: !_isSaving,
                        validator: (v) => _validateOptionalDate(v, t),
                        onTap: () =>
                            _selectDate(context, _workPermitDeadlineController),
                      ),

                      const SizedBox(height: 20),

                      // MEDICAL EXAM DEADLINE
                      _DateInputField(
                        label: t.driver_data_medical_exam_deadline,
                        controller: _medicalExamDeadlineController,
                        enabled: !_isSaving,
                        validator: (v) => _validateOptionalDate(v, t),
                        onTap: () => _selectDate(
                          context,
                          _medicalExamDeadlineController,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // PSYCHOLOGICAL EXAM DEADLINE
                      _DateInputField(
                        label: t.driver_data_psychological_exam_deadline,
                        controller: _psychologicalExamDeadlineController,
                        enabled: !_isSaving,
                        validator: (v) => _validateOptionalDate(v, t),
                        onTap: () => _selectDate(
                          context,
                          _psychologicalExamDeadlineController,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DRIVER CARD DEADLINE
                      _DateInputField(
                        label: t.driver_data_driver_card_deadline,
                        controller: _driverCardDeadlineController,
                        enabled: !_isSaving,
                        validator: (v) => _validateOptionalDate(v, t),
                        onTap: () =>
                            _selectDate(context, _driverCardDeadlineController),
                      ),

                      const SizedBox(height: 20),

                      // RESIDENCE CARD DEADLINE
                      _DateInputField(
                        label: t.driver_data_residence_card_deadline,
                        controller: _residenceCardDeadlineController,
                        enabled: !_isSaving,
                        validator: (v) => _validateOptionalDate(v, t),
                        onTap: () => _selectDate(
                          context,
                          _residenceCardDeadlineController,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DRIVER CERTIFICATE DEADLINE
                      _DateInputField(
                        label: t.driver_data_driver_certificate_deadline,
                        controller: _driverCertificateDeadlineController,
                        enabled: !_isSaving,
                        validator: (v) => _validateOptionalDate(v, t),
                        onTap: () => _selectDate(
                          context,
                          _driverCertificateDeadlineController,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _isSaving
                              ? null
                              : () async {
                                  setState(() => _submittedOnce = true);
                                  final ok =
                                      _formKey.currentState?.validate() ??
                                      false;
                                  if (!ok) return;

                                  setState(() => _isSaving = true);
                                  try {
                                    final repo = ref.read(
                                      driverRepositoryProvider,
                                    );
                                    await repo.updateDocuments(
                                      UpdateDriverDocumentsPayload(
                                        // companyInternalId: null for now (UI doesn't expose it)
                                        visaExpiresAt: _toIsoOrNull(
                                          _visaDeadlineController,
                                        ),
                                        drivingLicenseExpiresAt: _toIsoOrNull(
                                          _licenseDeadlineController,
                                        ),
                                        workPermitExpiresAt: _toIsoOrNull(
                                          _workPermitDeadlineController,
                                        ),
                                        medicalCheckExpiresAt: _toIsoOrNull(
                                          _medicalExamDeadlineController,
                                        ),
                                        psychCheckExpiresAt: _toIsoOrNull(
                                          _psychologicalExamDeadlineController,
                                        ),
                                        driverCardExpiresAt: _toIsoOrNull(
                                          _driverCardDeadlineController,
                                        ),
                                        residenceCardExpiresAt: _toIsoOrNull(
                                          _residenceCardDeadlineController,
                                        ),
                                        driverCertificateExpiresAt: _toIsoOrNull(
                                          _driverCertificateDeadlineController,
                                        ),
                                      ),
                                    );

                                    ref.invalidate(driverProfileProvider);
                                    if (context.mounted) context.pop();
                                  } catch (_) {
                                    if (!context.mounted) return;
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );
                                    messenger.clearSnackBars();
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          t.driver_data_save_failed,
                                        ),
                                      ),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isSaving = false);
                                    }
                                  }
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0F4D46),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  t.common_save,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DateInputField extends StatelessWidget {
  const _DateInputField({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.validator,
    required this.onTap,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?) validator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          enabled: enabled,
          validator: validator,
          onTap: enabled ? onTap : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F5DC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0F4D46), width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            errorStyle: const TextStyle(fontSize: 12, height: 1.2),
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF6B7280),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
