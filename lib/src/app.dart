import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/l10n/l10n.dart';
import 'package:mobile/src/core/l10n/locale_controller.dart';
import 'package:mobile/src/core/routing/app_router.dart';
import 'package:mobile/src/features/auth/application/auth_controller.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(authControllerProvider, (prev, next) {
      next.whenData((session) {
        final loc = appRouter.routeInformationProvider.value.uri.path;

        if (session == null) {
          if (loc != '/auth') appRouter.go('/auth');
        } else {
          if (loc.startsWith('/auth')) appRouter.go('/home');
        }
      });
    });

    _init();
  }

  Future<void> _init() async {
    await ref.read(authControllerProvider.future);

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      supportedLocales: SupportedLocales.all,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale == null) return SupportedLocales.pl;

        for (final l in supportedLocales) {
          if (l.languageCode == deviceLocale.languageCode) return l;
        }
        return SupportedLocales.pl;
      },
      themeMode: ThemeMode.light,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
    );
  }
}
