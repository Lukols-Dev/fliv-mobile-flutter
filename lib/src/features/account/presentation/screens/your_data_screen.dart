import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/driver/application/driver_profile_provider.dart';
import 'package:mobile/src/features/driver/data/driver_repository_impl.dart';
import 'package:mobile/src/features/driver/domain/driver_profile.dart';
import 'package:mobile/src/features/driver/domain/update_user_profile_payload.dart';

class YourDataScreen extends ConsumerStatefulWidget {
  const YourDataScreen({super.key});

  @override
  ConsumerState<YourDataScreen> createState() => _YourDataScreenState();
}

class _YourDataScreenState extends ConsumerState<YourDataScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _didSetInitialValues = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _applyProfileOnce(DriverProfile p) {
    if (_didSetInitialValues) return;
    _didSetInitialValues = true;

    _firstNameController.text = p.firstName;
    _lastNameController.text = p.lastName;
    _emailController.text = p.email ?? '';
    _phoneController.text = p.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final profileAsync = ref.watch(driverProfileProvider);

    ref.listen(driverProfileProvider, (_, next) {
      next.whenOrNull(
        data: (p) {
          if (p != null) _applyProfileOnce(p);
        },
      );
    });

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
                    'Nie udało się pobrać profilu.\n$e',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => ref.invalidate(driverProfileProvider),
                    child: const Text('Spróbuj ponownie'),
                  ),
                ],
              ),
            ),
          ),
          data: (profile) {
            if (profile == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Brak danych profilu (offline i brak cache).',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            // Ensure controllers are populated even if listener doesn't fire
            _applyProfileOnce(profile);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),

                    // TITLE
                    Center(
                      child: Text(
                        t.profile_your_data,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // FIRST NAME INPUT FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.auth_first_name_label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF5F5DC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F4D46),
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // LAST NAME INPUT FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.auth_last_name_label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF5F5DC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F4D46),
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // EMAIL INPUT FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.auth_email_label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF5F5DC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F4D46),
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // PHONE INPUT FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.profile_phone_label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF5F5DC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F4D46),
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
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
                                setState(() => _isSaving = true);
                                try {
                                  final repo = ref.read(
                                    driverRepositoryProvider,
                                  );
                                  await repo.updateProfile(
                                    UpdateUserProfilePayload(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      phone: _phoneController.text,
                                    ),
                                  );

                                  ref.invalidate(driverProfileProvider);
                                  if (context.mounted) context.pop();
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Błąd zapisu profilu: $e'),
                                    ),
                                  );
                                } finally {
                                  if (mounted)
                                    setState(() => _isSaving = false);
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
            );
          },
        ),
      ),
    );
  }
}
