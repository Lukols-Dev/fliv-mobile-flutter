import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';

import 'package:mobile/src/core/location/location_controller.dart';
import 'package:mobile/src/core/location/geocoding_providers.dart';
import 'package:mobile/src/features/driver/application/driver_profile_provider.dart';
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';
import 'package:mobile/src/features/orders/data/driver_transport_orders_repository_impl.dart';
import 'package:mobile/src/features/users/application/avatar_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _ztController = TextEditingController();
  bool _isAssigning = false;

  @override
  void dispose() {
    _ztController.dispose();
    super.dispose();
  }

  String _formatLoadingDate(DateTime? dt) {
    if (dt == null) return '—';
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  String _statusLabel(AppLocalizations t, String raw) {
    switch (raw) {
      case 'IN_PROGRESS':
        return t.order_status_in_progress;
      case 'LOADING':
        return t.order_status_loading;
      case 'UNLOADING':
        return t.order_status_unloading;
      case 'PAUSED':
        return t.order_status_paused;
      case 'COMPLETED':
        return t.order_status_completed;
      case 'PROBLEM':
        return t.order_status_problem;
      case 'PENDING':
        return t.order_status_pending;
      case 'ACCEPTED':
        return t.order_status_accepted;
      default:
        return raw;
    }
  }

  Future<void> _assignOrder(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final zt = _ztController.text.trim();
    if (zt.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.home_enter_zt_number)));
      return;
    }

    setState(() => _isAssigning = true);
    try {
      final repo = ref.read(driverTransportOrdersRepositoryProvider);
      await repo.assignByZtNumber(ztNumber: zt);

      ref.invalidate(currentDriverOrderProvider);

      _ztController.clear();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.home_order_assigned)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.home_assign_order_failed}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAssigning = false);
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(driverProfileProvider);
    ref.invalidate(currentDriverOrderProvider);
    ref.invalidate(avatarControllerProvider);

    await Future.wait<void>([
      ref.read(driverProfileProvider.future).then((_) {}).catchError((_) {}),
      ref
          .read(currentDriverOrderProvider.future)
          .then((_) {})
          .catchError((_) {}),
      ref.read(avatarControllerProvider.future).then((_) {}).catchError((_) {}),
      // User initiated refresh: ok to request location permission if needed.
      ref
          .read(locationControllerProvider.notifier)
          .getCurrent()
          .then((_) {})
          .catchError((_) {}),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final profileAsync = ref.watch(driverProfileProvider);
    final profile = profileAsync.maybeWhen(data: (p) => p, orElse: () => null);

    final fullName = profile != null
        ? '${profile.firstName} ${profile.lastName}'.trim()
        : '—';

    final driverId = profile != null
        ? ((profile as dynamic).driverCode as String? ?? '—')
        : '—';

    final currentOrderAsync = ref.watch(currentDriverOrderProvider);
    final currentOrder = currentOrderAsync.maybeWhen(
      data: (o) => o,
      orElse: () => null,
    );

    final avatarAsync = ref.watch(avatarControllerProvider);
    final avatarUrl = avatarAsync.maybeWhen(data: (u) => u, orElse: () => null);

    final locationAsync = ref.watch(locationControllerProvider);
    final loc = locationAsync.asData?.value;
    final cityStreetAsync = loc == null
        ? const AsyncValue<String?>.data(null)
        : ref.watch(locationCityStreetProvider(loc));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: const Color(0xFF004F45),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // HEADER
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFFE5E7EB),
                              backgroundImage: avatarUrl != null
                                  ? NetworkImage(avatarUrl)
                                  : null,
                              child: avatarUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Color(0xFF111827),
                                      size: 32,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.home_welcome_back,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Figtree',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    fullName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Figtree',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${t.common_id_label}: $driverId',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Figtree',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  size: 20,
                                ),
                                color: const Color.fromARGB(255, 0, 0, 0),
                                onPressed: () => context.push('/account'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // LOCATION CARD
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 79, 69, 0.10),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: const Icon(
                                  Icons.location_on_outlined,
                                  size: 24,
                                  color: Color(0xFF004F45),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.home_current_location_title,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontFamily: 'Figtree',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      () {
                                        if (locationAsync.isLoading) {
                                          return t.home_location_fetching;
                                        }

                                        return locationAsync.when(
                                          data: (loc) {
                                            if (loc == null) {
                                              return t
                                                  .home_location_tap_refresh;
                                            }

                                            if (cityStreetAsync.isLoading) {
                                              return t
                                                  .home_location_resolving_address;
                                            }

                                            return cityStreetAsync.when(
                                              data: (v) =>
                                                  (v == null || v.isEmpty)
                                                  ? t.home_location_address_not_found
                                                  : v,
                                              loading: () => t
                                                  .home_location_resolving_address,
                                              error: (e, _) => t
                                                  .home_location_address_not_found,
                                            );
                                          },
                                          loading: () =>
                                              t.home_location_fetching,
                                          error: (e, _) =>
                                              t.home_location_fetch_failed,
                                        );
                                      }(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontFamily: 'Figtree',
                                        fontWeight: FontWeight.w500,
                                        height: 1.50,
                                        letterSpacing: -0.08,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: t.home_refresh_location_tooltip,
                                icon: const Icon(Icons.refresh_rounded),
                                color: const Color(0xFF004F45),
                                onPressed: () async {
                                  try {
                                    await ref
                                        .read(
                                          locationControllerProvider.notifier,
                                        )
                                        .getCurrent();
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${t.common_location}: $e',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 38),

                        Text(
                          t.home_current_order_title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Figtree',
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (currentOrderAsync.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (currentOrder == null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  t.home_no_assigned_order_title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Figtree',
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  t.home_no_assigned_order_description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Figtree',
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _ztController,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: t.home_zt_hint,
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5DC),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 52,
                                  child: FilledButton(
                                    onPressed: _isAssigning
                                        ? null
                                        : () => _assignOrder(context),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF0F4D46),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: _isAssigning
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            t.home_assign_order_button,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Figtree',
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          InkWell(
                            onTap: () =>
                                context.push('/orders/${currentOrder.id}'),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF004F45),
                                          Color(0xFF005A4D),
                                          Color(0xFF006B5C),
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                t.home_order_number_label,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Figtree',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEF4444),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    _statusLabel(
                                                      t,
                                                      currentOrder.status,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontFamily: 'Figtree',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '#${currentOrder.ztNumber}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Figtree',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      14,
                                      12,
                                      14,
                                      12,
                                    ),
                                    child: Column(
                                      children: [
                                        _TimelineRow(
                                          color: const Color(0xFF004F45),
                                          title: t.order_loading_point,
                                          subtitle1: currentOrder.fromCountry,
                                          subtitle2: '',
                                          date: _formatLoadingDate(
                                            currentOrder.loadingDate,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        _TimelineRow(
                                          color: const Color(0xFFEF4444),
                                          title: t.order_unloading_point,
                                          subtitle1: currentOrder.toCountry,
                                          subtitle2: '',
                                          date: '—',
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          height: 54,
                                          width: double.infinity,
                                          child: FilledButton(
                                            onPressed: () {
                                              // TODO: Implement open navigation
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF0F4D46,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              elevation: 4,
                                              shadowColor: Colors.black
                                                  .withOpacity(0.2),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.near_me_outlined,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  t.home_open_navigation,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Figtree',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.color,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.date,
  });

  final Color color;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Container(
              width: 2,
              height: 34,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color, color.withValues(alpha: 0.0)],
                  stops: const [0.0, 0.8],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF709470),
                        fontSize: 11,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFF99A1AE),
                      fontSize: 10,
                      fontFamily: 'Figtree',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle1,
                style: const TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 14,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle2,
                style: const TextStyle(
                  color: Color(0xFF99A1AE),
                  fontSize: 10,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
