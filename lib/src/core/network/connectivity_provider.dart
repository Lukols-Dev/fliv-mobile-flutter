import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/core/config/env.dart';

enum NetworkStatus { unknown, online, offline }

const _healthPath = '/api/v1/health';
const _offlineRetryInterval = Duration(seconds: 5);
const _onlineCheckInterval = Duration(seconds: 30);
const _minimumCheckInterval = Duration(milliseconds: 800);

final _networkHealthDioProvider = Provider<Dio>((ref) {
  Env.validate();

  final baseUrl = Env.apiBaseUrl.isNotEmpty
      ? Env.apiBaseUrl
      : 'http://10.0.2.2:4000';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 2),
      receiveTimeout: const Duration(seconds: 2),
      sendTimeout: const Duration(seconds: 2),
      headers: const {'Content-Type': 'application/json', 'x-client': 'mobile'},
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});

/// Emits the current OS connectivity state. Combines `connectivity_plus`
/// events with a periodic `checkConnectivity()` poll so missed events
/// (notably on iOS simulator after host Wi-Fi changes) don't leave the
/// app stuck on a stale value.
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  final connectivity = Connectivity();
  final controller = StreamController<List<ConnectivityResult>>();

  List<ConnectivityResult>? last;

  Future<void> emit() async {
    if (controller.isClosed) return;
    try {
      final r = await connectivity.checkConnectivity();
      if (controller.isClosed) return;
      // Only push when actually different — avoid spamming listeners.
      if (last == null ||
          last!.length != r.length ||
          !last!.every(r.contains)) {
        last = r;
        controller.add(r);
      }
    } catch (_) {
      // ignore — we'll retry on the next tick / OS event
    }
  }

  unawaited(emit());

  final sub = connectivity.onConnectivityChanged.listen((_) {
    unawaited(emit());
  });
  // Safety net: catches OS events that fail to fire (iOS simulator quirk).
  final timer = Timer.periodic(const Duration(seconds: 5), (_) {
    unawaited(emit());
  });
  final lifecycleObserver = _ConnectivityLifecycleObserver(emit);
  WidgetsBinding.instance.addObserver(lifecycleObserver);

  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(lifecycleObserver);
    sub.cancel();
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Source of truth for online/offline state.
/// `connectivity_plus` only triggers checks; backend `/health` decides status.
final networkStatusControllerProvider =
    NotifierProvider<NetworkStatusController, NetworkStatus>(
      NetworkStatusController.new,
    );

class NetworkStatusController extends Notifier<NetworkStatus> {
  Timer? _nextCheckTimer;
  DateTime? _lastCheckAt;
  Future<bool>? _inFlightCheck;

  @override
  NetworkStatus build() {
    ref.listen(connectivityProvider, (_, __) {
      unawaited(checkNow(force: true));
    });

    _nextCheckTimer = Timer(Duration.zero, () {
      unawaited(checkNow(force: true));
    });

    ref.onDispose(() {
      _nextCheckTimer?.cancel();
    });

    return NetworkStatus.unknown;
  }

  Future<bool> checkNow({bool force = false}) {
    final inFlight = _inFlightCheck;
    if (inFlight != null) return inFlight;

    final now = DateTime.now();
    final lastCheckAt = _lastCheckAt;
    if (!force &&
        lastCheckAt != null &&
        now.difference(lastCheckAt) < _minimumCheckInterval) {
      return Future.value(state == NetworkStatus.online);
    }

    _lastCheckAt = now;
    final check = _checkHealth()
        .then((isOnline) {
          state = isOnline ? NetworkStatus.online : NetworkStatus.offline;
          _scheduleNextCheck();
          return isOnline;
        })
        .whenComplete(() {
          _inFlightCheck = null;
        });

    _inFlightCheck = check;
    return check;
  }

  void markOnline() {
    if (state != NetworkStatus.online) {
      state = NetworkStatus.online;
    }
    _scheduleNextCheck();
  }

  void markOffline() {
    if (state != NetworkStatus.offline) {
      state = NetworkStatus.offline;
    }
    _scheduleNextCheck();
  }

  Future<bool> _checkHealth() async {
    try {
      final res = await ref.read(_networkHealthDioProvider).get<dynamic>(
            _healthPath,
            options: Options(
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 300,
            ),
          );
      final statusCode = res.statusCode;
      return statusCode != null && statusCode >= 200 && statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  void _scheduleNextCheck() {
    _nextCheckTimer?.cancel();

    final delay = state == NetworkStatus.online
        ? _onlineCheckInterval
        : _offlineRetryInterval;
    _nextCheckTimer = Timer(delay, () {
      unawaited(checkNow(force: true));
    });
  }
}

final isOfflineProvider = Provider<bool>((ref) {
  return ref.watch(networkStatusControllerProvider) == NetworkStatus.offline;
});

class _ConnectivityLifecycleObserver with WidgetsBindingObserver {
  _ConnectivityLifecycleObserver(this._onResume);

  final Future<void> Function() _onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_onResume());
    }
  }
}
