import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';

class DriverDataScreen extends ConsumerStatefulWidget {
  const DriverDataScreen({super.key});

  @override
  ConsumerState<DriverDataScreen> createState() => _DriverDataScreenState();
}

class _DriverDataScreenState extends ConsumerState<DriverDataScreen> {
  final _visaDeadlineController = TextEditingController();
  final _licenseDeadlineController = TextEditingController();
  final _workPermitDeadlineController = TextEditingController();
  final _medicalExamDeadlineController = TextEditingController();
  final _psychologicalExamDeadlineController = TextEditingController();
  final _driverCardDeadlineController = TextEditingController();
  final _residenceCardDeadlineController = TextEditingController();
  final _driverCertificateDeadlineController = TextEditingController();

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  onTap: () => _selectDate(context, _visaDeadlineController),
                ),

                const SizedBox(height: 20),

                // LICENSE DEADLINE
                _DateInputField(
                  label: t.driver_data_license_deadline,
                  controller: _licenseDeadlineController,
                  onTap: () => _selectDate(context, _licenseDeadlineController),
                ),

                const SizedBox(height: 20),

                // WORK PERMIT DEADLINE
                _DateInputField(
                  label: t.driver_data_work_permit_deadline,
                  controller: _workPermitDeadlineController,
                  onTap: () =>
                      _selectDate(context, _workPermitDeadlineController),
                ),

                const SizedBox(height: 20),

                // MEDICAL EXAM DEADLINE
                _DateInputField(
                  label: t.driver_data_medical_exam_deadline,
                  controller: _medicalExamDeadlineController,
                  onTap: () =>
                      _selectDate(context, _medicalExamDeadlineController),
                ),

                const SizedBox(height: 20),

                // PSYCHOLOGICAL EXAM DEADLINE
                _DateInputField(
                  label: t.driver_data_psychological_exam_deadline,
                  controller: _psychologicalExamDeadlineController,
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
                  onTap: () =>
                      _selectDate(context, _driverCardDeadlineController),
                ),

                const SizedBox(height: 20),

                // RESIDENCE CARD DEADLINE
                _DateInputField(
                  label: t.driver_data_residence_card_deadline,
                  controller: _residenceCardDeadlineController,
                  onTap: () =>
                      _selectDate(context, _residenceCardDeadlineController),
                ),

                const SizedBox(height: 20),

                // DRIVER CERTIFICATE DEADLINE
                _DateInputField(
                  label: t.driver_data_driver_certificate_deadline,
                  controller: _driverCertificateDeadlineController,
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
                    onPressed: () {
                      // TODO: Implement save logic
                      context.pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F4D46),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
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
      ),
    );
  }
}

class _DateInputField extends StatelessWidget {
  const _DateInputField({
    required this.label,
    required this.controller,
    required this.onTap,
  });

  final String label;
  final TextEditingController controller;
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
        TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
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
