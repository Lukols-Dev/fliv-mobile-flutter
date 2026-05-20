import 'dart:async';

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
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';

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
    WidgetsBinding.instance.addObserver(this);

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

    _offlineSub = ref.listenManual(
      isOfflineProvider,
      (prev, next) {
        if (prev == null) {
          if (next) _showConnectivitySnackBar(isOffline: true);
          return;
        }
        if (prev == next) return;

        if (next) {
          _showConnectivitySnackBar(isOffline: true);
          return;
        }

        ref.invalidate(driverProfileProvider);
        ref.invalidate(currentDriverOrderProvider);
        _showConnectivitySnackBar(isOffline: false);
      },
      fireImmediately: true,
    );

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
    _hereLifecycleSub.close();
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

    // tylko jeśli zalogowany
    final session = ref.read(authControllerProvider).asData?.value;
    if (session == null) return;

    unawaited(_refreshAfterResume());
  }

  Future<void> _refreshAfterResume() async {
    final isOnline = await ref
        .read(networkStatusControllerProvider.notifier)
        .checkNow(force: true);
    if (!mounted || !isOnline) return;

    ref.invalidate(driverProfileProvider);
    ref.invalidate(currentDriverOrderProvider);
  }

  Future<void> _init() async {
    await ref.read(authControllerProvider.future);
    await ref.read(hereSdkInitProvider.future);

    FlutterNativeSplash.remove();
  }

  AppLocalizations? _currentLocalizations() {
    final currentContext = _messengerKey.currentContext;
    if (currentContext == null) return null;
    return AppLocalizations.of(currentContext);
  }

  void _showConnectivitySnackBar({required bool isOffline}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final t = _currentLocalizations();
      final message = isOffline
          ? (t?.app_offline ?? 'Jesteś offline')
          : (t?.app_online ?? 'Znowu online');
      final messenger = _messengerKey.currentState;
      if (messenger == null) return;

      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
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
