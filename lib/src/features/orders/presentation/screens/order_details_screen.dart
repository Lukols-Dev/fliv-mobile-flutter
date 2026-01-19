import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/orders/application/driver_order_details_provider.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, this.orderId});

  final String? orderId;

  String _dashIfEmpty(String? v) {
    final s = v?.trim();
    if (s == null || s.isEmpty) return '-';
    return s;
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  String _formatWeightKg(int? kg) {
    if (kg == null) return '-';
    return '$kg kg';
  }

  String _formatBoolPl(bool? v) {
    if (v == null) return '-';
    return v ? 'Tak' : 'Nie';
  }

  Color _statusColor(String? status) {
    switch (status) {
      // WEB: bg-green-500 / text-green-600
      case 'COMPLETED':
        return const Color(0xFF22C55E); // green-500

      // WEB: text-destructive / bg-destructive/20 (u Ciebie już było)
      case 'PROBLEM':
        return const Color(0xFFEF4444); // red-500

      // WEB: neutral/beige flow
      case 'PENDING':
      case 'ACCEPTED':
      case 'PAUSED':
        return const Color(0xFFEBE5D4); // beige

      // WEB: active/in-progress flow -> green #709470
      case 'IN_PROGRESS':
      case 'LOADING':
      case 'UNLOADING':
        return const Color(0xFF709470); // primary green

      default:
        return const Color(0xFF9CA3AF); // gray-400
    }
  }

  String _statusLabel(AppLocalizations t, String? status) {
    switch (status) {
      case 'PENDING':
        return 'Oczekuje';
      case 'ACCEPTED':
        return 'Zaakceptowane';
      case 'IN_PROGRESS':
        return t.order_status_in_transit;
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
        return '-';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final id = orderId;
    if (id == null || id.trim().isEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text(
            'Brak ID zlecenia',
            style: TextStyle(fontFamily: 'Figtree'),
          ),
        ),
      );
    }

    final detailsAsync = ref.watch(driverOrderDetailsProvider(id));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: detailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Błąd pobierania zlecenia: $e',
            style: const TextStyle(fontFamily: 'Figtree'),
          ),
        ),
        data: (details) {
          final statusLabel = _statusLabel(t, details.status);
          final statusColor = _statusColor(details.status);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),

                        // HEADER
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.order_details_title,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '#${_dashIfEmpty(details.ztNumber)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6B7280),
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                statusLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // CLIENT DATA CARD
                        _InfoCard(
                          title: t.order_client_data,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoField(
                                label: "Nazwa firmy",
                                value: _dashIfEmpty(details.clientName),
                              ),
                              const SizedBox(height: 12),
                              _InfoField(
                                label: t.order_contact_person,
                                value: "Adam Kowalski",
                              ),
                              const SizedBox(height: 8),
                              _InfoField(
                                label: t.order_phone,
                                value: "1234567890",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // TRANSPORT ROUTE CARD
                        _InfoCard(
                          title: t.order_transport_route,
                          child: Column(
                            children: [
                              _RoutePoint(
                                color: const Color(0xFF10B981),
                                title: t.order_loading_point,
                                location: _dashIfEmpty(details.fromCountry),
                                address: '-',
                                date: _formatDate(details.loadingDate),
                                status: '-',
                                statusColor: const Color(0xFF10B981),
                                showLine: true,
                              ),
                              const SizedBox(height: 10),
                              _RoutePoint(
                                color: const Color(0xFFEF4444),
                                title: t.order_unloading_point,
                                location: _dashIfEmpty(details.toCountry),
                                address: '-',
                                date: '-',
                                status: '-',
                                statusColor: const Color(0xFFEF4444),
                                showLine: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // CARGO CARD
                        _InfoCard(
                          title: t.order_cargo,
                          child: Column(
                            children: [
                              _InfoRow(
                                label: t.order_cargo_type,
                                value: _dashIfEmpty(details.cargoDescription),
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                label: t.order_weight,
                                value: _formatWeightKg(details.cargoWeightKg),
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                label: 'Wymaga temperatury',
                                value: _formatBoolPl(
                                  details.temperatureSensitive,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(label: t.order_pallets, value: '-'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // NOTES CARD
                        _InfoCard(
                          title: t.order_notes,
                          child: Text(
                            _dashIfEmpty(details.notes),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF111827),
                              height: 1.5,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),

              // ACTION BUTTONS
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 18,
                      offset: Offset(0, -6),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: () {
                            // TODO: Implement start navigation
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0F4D46),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.near_me_outlined, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                t.order_start_navigation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: () {
                            final zt = details.ztNumber?.trim();
                            final ztQuery = (zt == null || zt.isEmpty)
                                ? ''
                                : '&ztNumber=$zt';
                            context.go(
                              '/documents?orderId=${details.id}$ztQuery',
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF7FA87C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.description_outlined, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                t.order_view_documents,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF709470),
              fontFamily: 'Figtree',
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
              fontFamily: 'Figtree',
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
              fontFamily: 'Figtree',
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
            fontFamily: 'Figtree',
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF111827),
            fontFamily: 'Figtree',
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({
    required this.color,
    required this.title,
    required this.location,
    required this.address,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.showLine,
  });

  final Color color;
  final String title;
  final String location;
  final String address;
  final String date;
  final String status;
  final Color statusColor;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            if (showLine)
              Container(width: 2, height: 60, color: const Color(0xFFE5E7EB)),
          ],
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
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  fontFamily: 'Figtree',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                  fontFamily: 'Figtree',
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    statusColor == const Color(0xFF10B981)
                        ? Icons.check_circle_outline
                        : Icons.radio_button_checked,
                    size: 16,
                    color: statusColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
