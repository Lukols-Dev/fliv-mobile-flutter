import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  String _statusLabel(String raw) {
    switch (raw) {
      case 'IN_PROGRESS':
        return 'W trasie';
      case 'LOADING':
        return 'Załadunek';
      case 'UNLOADING':
        return 'Rozładunek';
      case 'PAUSED':
        return 'Pauza';
      case 'COMPLETED':
        return 'Zakończone';
      case 'PROBLEM':
        return 'Problem';
      default:
        return raw;
    }
  }

  Future<void> _assignOrder(BuildContext context) async {
    final zt = _ztController.text.trim();
    if (zt.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Podaj numer ZT.')));
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
        ).showSnackBar(const SnackBar(content: Text('Zlecenie przypisane.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nie udało się przypisać zlecenia: $e')),
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

    await Future.wait([
      ref.read(driverProfileProvider.future).catchError((_) {}),
      ref.read(currentDriverOrderProvider.future).catchError((_) {}),
      ref.read(avatarControllerProvider.future).catchError((_) {}),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(driverProfileProvider);
    final profile = profileAsync.maybeWhen(data: (p) => p, orElse: () => null);

    final fullName = profile != null
        ? '${profile.firstName} ${profile.lastName}'.trim()
        : '—';

    final driverId = (profile as dynamic?)?.driverCode as String? ?? '—';

    final currentOrderAsync = ref.watch(currentDriverOrderProvider);
    final currentOrder = currentOrderAsync.maybeWhen(
      data: (o) => o,
      orElse: () => null,
    );

    final avatarAsync = ref.watch(avatarControllerProvider);
    final avatarUrl = avatarAsync.maybeWhen(data: (u) => u, orElse: () => null);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                const Expanded(
                                  child: Text(
                                    'Witaj z powrotem!',
                                    style: TextStyle(
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
                              'ID: $driverId',
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
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.settings_outlined, size: 20),
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
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF0F4D46),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Obecna lokalizacja',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Figtree',
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Warszawa, Chmielna 44/2',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Figtree',
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Aktualne Zlecenie',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Figtree',
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),

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
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Brak przypisanego zlecenia',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Figtree',
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Aby przypisać zlecenie, wpisz numer ZT otrzymany od dyspozytora.',
                            style: TextStyle(
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
                              hintText: 'np. ZT-123456',
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
                                  : const Text(
                                      'Przypisz zlecenie',
                                      style: TextStyle(
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
                      onTap: () => context.push('/orders/${currentOrder.id}'),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
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
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.50, 0.00),
                                  end: Alignment(0.50, 1.00),
                                  colors: [
                                    Color(0xFF004F45),
                                    Color(0xFF005A4D),
                                  ],
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
                                      const Expanded(
                                        child: Text(
                                          'Numer zlecenia',
                                          style: TextStyle(
                                            color: Color(0xFFD1FAE5),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Figtree',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEF4444),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Text(
                                          _statusLabel(currentOrder.status),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Figtree',
                                          ),
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
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Figtree',
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
                                    color: const Color(0xFF10B981),
                                    title: 'Punkt załadunku',
                                    subtitle1: currentOrder.fromCountry,
                                    subtitle2: '',
                                    date: _formatLoadingDate(
                                      currentOrder.loadingDate,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _TimelineRow(
                                    color: const Color(0xFFEF4444),
                                    title: 'Punkt rozładunku',
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
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        elevation: 4,
                                        shadowColor: Colors.black.withOpacity(
                                          0.2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.near_me_outlined,
                                            size: 18,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Otwórz nawigację',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Figtree',
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
                ],
              ),
            ),
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
            Container(width: 2, height: 34, color: const Color(0xFFE5E7EB)),
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
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Figtree',
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Figtree',
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle1,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Figtree',
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle2,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Figtree',
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
