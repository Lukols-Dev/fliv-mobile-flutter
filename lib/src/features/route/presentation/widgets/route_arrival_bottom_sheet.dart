import 'package:flutter/material.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/orders/domain/driver_transport_order_details.dart';

Future<void> showArrivalConfirmationBottomSheet(
  BuildContext context, {
  required DriverTransportOrderRoutePoint point,
  required int indexOneBased,
  required int total,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: false,
    showDragHandle: false,
    backgroundColor: const Color(0xFFF3F1E9),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) => _ArrivalSheet(
      point: point,
      indexOneBased: indexOneBased,
      total: total,
    ),
  );
}

class _ArrivalSheet extends StatefulWidget {
  const _ArrivalSheet({
    required this.point,
    required this.indexOneBased,
    required this.total,
  });

  final DriverTransportOrderRoutePoint point;
  final int indexOneBased;
  final int total;

  @override
  State<_ArrivalSheet> createState() => _ArrivalSheetState();
}

class _ArrivalSheetState extends State<_ArrivalSheet> {
  bool _isConfirming = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final address = widget.point.address ?? widget.point.label;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9F2EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF0F4D46),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.route_arrival_title(widget.indexOneBased, widget.total),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Figtree',
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      if (address != null && address.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          address,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Figtree',
                            color: Color(0xFF111827),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _isConfirming
                    ? null
                    : () {
                        setState(() => _isConfirming = true);
                        Navigator.of(context).pop();
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F4D46),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                child: _isConfirming
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        t.route_confirm_arrival,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Figtree',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
