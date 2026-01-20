import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/l10n/l10n.dart';
import 'package:mobile/src/core/l10n/locale_controller.dart';
import 'package:mobile/src/features/auth/application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _submittedOnce = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final v = value.trim();
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(v);
  }

  String? _validateEmail(String? value, AppLocalizations t) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return t.common_fill_all_fields;
    if (!_isValidEmail(v)) return t.auth_invalid_email;
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations t) {
    final v = value ?? '';
    if (v.isEmpty) return t.common_fill_all_fields;
    return null;
  }

  Future<void> _submit(AppLocalizations t) async {
    setState(() => _submittedOnce = true);

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await ref
        .read(authControllerProvider.notifier)
        .signIn(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen(authControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        },
      );
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
                                t.auth_login_title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Figtree',
                                  height: 1.38,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 32),

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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      TextButton(
                                        onPressed: isLoading
                                            ? null
                                            : () => context.push(
                                                '/auth/forgot-password',
                                              ),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          t.auth_forgot_password,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF4A90E2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    enabled: !isLoading,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    validator: (v) => _validatePassword(v, t),
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

                              // LOGIN BUTTON
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
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              t.auth_login,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // OR DIVIDER
                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      t.common_or,
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // CREATE ACCOUNT BUTTON
                              SizedBox(
                                height: 56,
                                child: FilledButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context.push('/auth/register'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF7FA87C),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    t.auth_register,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // TERMS
                              Text(
                                t.auth_terms_text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                  height: 1.4,
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
