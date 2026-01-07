import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((
  ref,
) async* {
  final connectivity = Connectivity();

  // 1) initial value
  yield await connectivity.checkConnectivity();

  // 2) updates
  yield* connectivity.onConnectivityChanged;
});

final isOfflineProvider = Provider<bool>((ref) {
  final results = ref.watch(connectivityProvider).asData?.value;
  return results?.contains(ConnectivityResult.none) ?? false;
});
