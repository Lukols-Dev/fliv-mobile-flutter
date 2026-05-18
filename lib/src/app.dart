import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/l10n/l10n.dart';
import 'package:mobile/src/core/l10n/locale_controller.dart';
import 'package:mobile/src/core/network/connectivity_provider.dart';
import 'package:mobile/src/core/routing/app_router.dart';
import 'package:mobile/src/features/auth/application/auth_controller.dart';
import 'package:mobile/src/features/driver/application/driver_profile_provider.dart';
import 'package:mobile/src/core/here/sdk_engine_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  late final ProviderSubscription _offlineSub;
  late final ProviderSubscription _hereLifecycleSub;

  DateTime? _lastResumeRefresh;

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

    _offlineSub = ref.listenManual(isOfflineProvider, (prev, next) {
      final wasOffline = prev ?? false;
      final isOffline = next;

      if (!wasOffline && isOffline) {
        _messengerKey.currentState
          ?..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Jesteś offline')));
      }

      if (wasOffline && !isOffline) {
        _messengerKey.currentState
          ?..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Znowu online')));
      }
    });

    _hereLifecycleSub = ref.listenManual(
      hereSdkLifecycleProvider,
      (prev, next) {},
    );

    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _offlineSub.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    // debounce: nie odświeżaj 5 razy jak system "mieli" lifecycle
    final now = DateTime.now();
    if (_lastResumeRefresh != null &&
        now.difference(_lastResumeRefresh!) < const Duration(seconds: 2)) {
      return;
    }
    _lastResumeRefresh = now;

    // tylko jeśli ONLINE
    final offline = ref.read(isOfflineProvider);
    if (offline) return;

    // tylko jeśli zalogowany
    final session = ref.read(authControllerProvider).asData?.value;
    if (session == null) return;

    // odśwież profil (provider sam zapisze do cache jeśli tak masz)
    ref.invalidate(driverProfileProvider);
  }

  Future<void> _init() async {
    await ref.read(authControllerProvider.future);
    await ref.read(hereSdkInitProvider.future);

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      scaffoldMessengerKey: _messengerKey,
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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
