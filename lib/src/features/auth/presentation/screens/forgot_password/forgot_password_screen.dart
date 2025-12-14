import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/l10n/l10n.dart';
import 'package:mobile/src/core/l10n/locale_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F4D46)),
          onPressed: () => context.pop(),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // TITLE
                            Text(
                              t.auth_forgot_password_title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Figtree',
                                height: 1.38,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // DESCRIPTION
                            Text(
                              t.auth_forgot_password_description,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Figtree',
                                height: 1.5,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // EMAIL INPUT FIELD
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
                                TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // SEND LINK BUTTON
                            SizedBox(
                              height: 56,
                              child: FilledButton(
                                onPressed: () {
                                  // TODO: Implement send link logic
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F4D46),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 8,
                                  shadowColor: const Color(0x22000000),
                                ),
                                child: Text(
                                  t.auth_send_link,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
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
