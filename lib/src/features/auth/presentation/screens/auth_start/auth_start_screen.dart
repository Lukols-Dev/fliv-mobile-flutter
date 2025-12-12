import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/l10n/l10n.dart';
import 'package:mobile/src/core/l10n/locale_controller.dart';

class AuthStartScreen extends ConsumerWidget {
  const AuthStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenH = constraints.maxHeight;
              final heroH = (screenH * 0.60).clamp(280.0, 520.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // HERO IMAGE
                  SizedBox(
                    height: heroH,
                    child: DecoratedBox(
                      decoration: const ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/auth-hero-image.jpg'),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                            spreadRadius: -4,
                          ),
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 15,
                            offset: Offset(0, 10),
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // TITLE
                              Text(
                                t.auth_start_title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Figtree',
                                  height: 1.38,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // SUBTITLE
                              Text(
                                t.auth_start_subtitle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Figtree',
                                  fontWeight: FontWeight.w500,
                                  height: 1.36,
                                  letterSpacing: 0.28,
                                ),
                              ),

                              const SizedBox(height: 18),

                              // LOGIN BUTTON
                              SizedBox(
                                height: 56,
                                child: FilledButton(
                                  onPressed: () => context.go(""),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F4D46),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 8,
                                    shadowColor: const Color(0x22000000),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        t.auth_login, // np. "Zaloguj się"
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
                                      t.common_or, // np. "lub"
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

                              // REGISTER BUTTON
                              SizedBox(
                                height: 56,
                                child: FilledButton(
                                  onPressed: () => context.go(""),
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

                              const Spacer(),

                              // LANGUAGE SELECTOR
                              Align(
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
                                              for (final l
                                                  in SupportedLocales.all)
                                                ListTile(
                                                  title: Text(
                                                    SupportedLocales.label(l),
                                                  ),
                                                  trailing:
                                                      l.languageCode ==
                                                          locale.languageCode
                                                      ? const Icon(
                                                          Icons.check_rounded,
                                                        )
                                                      : null,
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                          localeControllerProvider
                                                              .notifier,
                                                        )
                                                        .setLocale(l);
                                                    if (ctx.mounted)
                                                      Navigator.pop(ctx);
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
