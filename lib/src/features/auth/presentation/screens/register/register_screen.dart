import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/l10n/l10n.dart';
import 'package:mobile/src/core/l10n/locale_controller.dart';
import 'package:mobile/src/features/auth/application/driver_registration_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _companyIdFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _submittedOnce = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _companyIdFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final v = value.trim();
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(v);
  }

  String? _validateRequired(String? value, AppLocalizations t) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return t.common_fill_all_fields;
    return null;
  }

  String? _validateEmail(String? value, AppLocalizations t) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return t.common_fill_all_fields;
    if (!_isValidEmail(v)) return t.auth_invalid_email;
    return null;
  }

  Future<void> _submit(AppLocalizations t) async {
    setState(() => _submittedOnce = true);

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final companyId = _companyIdController.text.trim();

    await ref
        .read(driverRegistrationControllerProvider.notifier)
        .register(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          companyInternalId: companyId,
          isAgreedToTerms: true,
          isAgreedToPrivacyPolicy: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);

    final registrationState = ref.watch(driverRegistrationControllerProvider);
    final isLoading = registrationState.isLoading;

    ref.listen(driverRegistrationControllerProvider, (prev, next) {
      final wasLoading = prev?.isLoading ?? false;
      if (!wasLoading || next.isLoading) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();

      if (next.hasError) {
        messenger.showSnackBar(
          SnackBar(content: Text(t.auth_register_failed)),
        );
        return;
      }

      messenger.showSnackBar(
        SnackBar(content: Text(t.auth_register_success_pending_activation)),
      );
      context.go('/auth/login');
    });

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: isLoading ? null : () => context.pop(),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _submittedOnce
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // TITLE
                              Text(
                                t.auth_register_title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Figtree',
                                  height: 1.38,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // FIRST NAME
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.auth_first_name_label,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Figtree',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _firstNameController,
                                    focusNode: _firstNameFocus,
                                    enabled: !isLoading,
                                    textInputAction: TextInputAction.next,
                                    validator: (v) => _validateRequired(v, t),
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_lastNameFocus);
                                    },
                                    decoration: InputDecoration(
                                      hintText: t.auth_first_name_hint,
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F5DC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      errorStyle: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 12,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // LAST NAME
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.auth_last_name_label,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Figtree',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _lastNameController,
                                    focusNode: _lastNameFocus,
                                    enabled: !isLoading,
                                    textInputAction: TextInputAction.next,
                                    validator: (v) => _validateRequired(v, t),
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_companyIdFocus);
                                    },
                                    decoration: InputDecoration(
                                      hintText: t.auth_last_name_hint,
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F5DC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      errorStyle: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 12,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // COMPANY ID
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.auth_company_id_label,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Figtree',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _companyIdController,
                                    focusNode: _companyIdFocus,
                                    enabled: !isLoading,
                                    textInputAction: TextInputAction.next,
                                    validator: (v) => _validateRequired(v, t),
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_emailFocus);
                                    },
                                    decoration: InputDecoration(
                                      hintText: t.auth_company_id_hint,
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F5DC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      errorStyle: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 12,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // EMAIL
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.auth_email_label,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Figtree',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    enabled: !isLoading,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: (v) => _validateEmail(v, t),
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_passwordFocus);
                                    },
                                    decoration: InputDecoration(
                                      hintText: t.auth_email_hint,
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F5DC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      errorStyle: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 12,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // PASSWORD
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.auth_password_label,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Figtree',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    enabled: !isLoading,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    validator: (v) => _validateRequired(v, t),
                                    onFieldSubmitted: (_) async {
                                      if (!isLoading) await _submit(t);
                                    },
                                    decoration: InputDecoration(
                                      hintText: '........',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 16,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F5DC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF6B7280),
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : () => setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              }),
                                      ),
                                      errorStyle: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 12,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // CREATE ACCOUNT BUTTON
                              SizedBox(
                                height: 56,
                                child: FilledButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _submit(t),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F4D46),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 8,
                                    shadowColor: const Color(0x22000000),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(t.auth_register),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ALREADY HAVE ACCOUNT LINK
                              Center(
                                child: TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context.push('/auth/login'),
                                  child: Text(
                                    t.auth_already_have_account,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // LANGUAGE SELECTOR
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            builder: (ctx) {
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (final l in SupportedLocales.all)
                                      ListTile(
                                        title: Text(SupportedLocales.label(l)),
                                        trailing:
                                            l.languageCode ==
                                                locale.languageCode
                                            ? const Icon(Icons.check_rounded)
                                            : null,
                                        onTap: () {
                                          ref
                                              .read(
                                                localeControllerProvider
                                                    .notifier,
                                              )
                                              .setLocale(l);
                                          if (ctx.mounted) Navigator.pop(ctx);
                                        },
                                      ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                SupportedLocales.label(locale),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4B5563),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Color(0xFF4B5563),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
