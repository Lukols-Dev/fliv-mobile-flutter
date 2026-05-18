import 'package:flutter/material.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/orders/domain/driver_transport_order_details.dart';

/// Timeline postępu punktów trasy.
///
/// Gdy [myLocationLabel] nie jest null, na początku wyświetlany jest wiersz
/// „Moja lokalizacja" z dystansem dojazdu [approachDistanceM].
/// [confirmedStops] to liczba zaliczonych punktów (indeks następnego celu).
class RouteStopsProgressList extends StatelessWidget {
  const RouteStopsProgressList({
    super.key,
    required this.routePoints,
    required this.confirmedStops,
    this.myLocationLabel,
    this.approachDistanceM = 0,
  });

  final List<DriverTransportOrderRoutePoint> routePoints;
  final int confirmedStops;
  final String? myLocationLabel;
  final int approachDistanceM;

  static String _fmtDist(int m) {
    if (m < 1000) return '$m m';
    return '${(m / 1000).toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    if (routePoints.isEmpty) return const SizedBox.shrink();

    final t = AppLocalizations.of(context)!;
    final items = <Widget>[];

    if (myLocationLabel != null) {
      items.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF0F4D46),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.my_location_rounded,
                size: 11,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                myLocationLabel!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Figtree',
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      );

      items.add(
        Padding(
          padding: const EdgeInsets.only(left: 9),
          child: Row(
            children: [
              Container(
                width: 2,
                height: 20,
                color: const Color(0xFF0F4D46),
              ),
              if (approachDistanceM > 0) ...[
                const SizedBox(width: 8),
                Text(
                  _fmtDist(approachDistanceM),
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: 'Figtree',
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    for (int i = 0; i < routePoints.length; i++) {
      final point = routePoints[i];
      final isDone = i < confirmedStops;
      final isNext = i == confirmedStops;
      final isLast = i == routePoints.length - 1;
      final label = point.address ?? point.label ?? 'Punkt ${point.sequence}';

      final dotColor = isDone
          ? const Color(0xFF22C55E)
          : isNext
              ? const Color(0xFFF6873B)
              : const Color(0xFFD1D5DB);

      final dotBg = isDone
          ? const Color(0xFF22C55E)
          : isNext
              ? const Color(0xFFFFF7ED)
              : const Color(0xFFF3F4F6);

      items.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: dotBg,
                shape: BoxShape.circle,
                border: Border.all(color: dotColor, width: isDone ? 0 : 1.5),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : isNext
                      ? const Icon(
                          Icons.near_me_rounded,
                          size: 11,
                          color: Color(0xFFF6873B),
                        )
                      : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isNext)
                    Text(
                      t.order_route_point_next,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Figtree',
                        color: Color(0xFFF6873B),
                      ),
                    ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isNext ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: 'Figtree',
                      color: isDone
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF111827),
                      decoration:
                          isDone ? TextDecoration.lineThrough : null,
                      decorationColor: const Color(0xFF9CA3AF),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isDone && point.arrivedAt != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      t.order_route_point_arrived_at(_formatTime(point.arrivedAt!)),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'Figtree',
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );

      if (!isLast) {
        items.add(
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Container(
              width: 2,
              height: 20,
              color: isDone
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFE5E7EB),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }

  static String _formatTime(DateTime dt) {
    final l = dt.toLocal();
    return '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}
