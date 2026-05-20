import 'package:flutter/material.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';

enum OrderStatusChoice { inProgress, loading, unloading }

extension OrderStatusChoiceX on OrderStatusChoice {
  String title(AppLocalizations t) => switch (this) {
    OrderStatusChoice.inProgress => t.route_status_in_progress_label,
    OrderStatusChoice.loading => t.order_status_loading,
    OrderStatusChoice.unloading => t.order_status_unloading,
  };

  String get apiKey => switch (this) {
    OrderStatusChoice.inProgress => 'IN_PROGRESS',
    OrderStatusChoice.loading => 'LOADING',
    OrderStatusChoice.unloading => 'UNLOADING',
  };

  IconData get icon => switch (this) {
    OrderStatusChoice.inProgress => Icons.route_rounded,
    OrderStatusChoice.loading => Icons.inventory_2_outlined,
    OrderStatusChoice.unloading => Icons.location_on_outlined,
  };

  Color get iconBg => const Color(0xFFE9F2EE);
  Color get iconColor => const Color(0xFF0F4D46);
}

Future<OrderStatusChoice?> showOrderStatusBottomSheet(BuildContext context) {
  final t = AppLocalizations.of(context)!;
  return showModalBottomSheet<OrderStatusChoice>(
    context: context,
    isScrollControlled: false,
    showDragHandle: true,
    backgroundColor: const Color(0xFFF3F1E9),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.route_status_change_title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Figtree',
                  color: Color(0xFF0A0A0A),
                ),
              ),
              const SizedBox(height: 8),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.55,
                children: [
                  _StatusTile(
                    title: OrderStatusChoice.inProgress.title(t),
                    icon: OrderStatusChoice.inProgress.icon,
                    iconBg: OrderStatusChoice.inProgress.iconBg,
                    iconColor: OrderStatusChoice.inProgress.iconColor,
                    onTap: () =>
                        Navigator.pop(ctx, OrderStatusChoice.inProgress),
                  ),
                  _StatusTile(
                    title: OrderStatusChoice.loading.title(t),
                    icon: OrderStatusChoice.loading.icon,
                    iconBg: OrderStatusChoice.loading.iconBg,
                    iconColor: OrderStatusChoice.loading.iconColor,
                    onTap: () => Navigator.pop(ctx, OrderStatusChoice.loading),
                  ),
                  _StatusTile(
                    title: OrderStatusChoice.unloading.title(t),
                    icon: OrderStatusChoice.unloading.icon,
                    iconBg: OrderStatusChoice.unloading.iconBg,
                    iconColor: OrderStatusChoice.unloading.iconColor,
                    onTap: () =>
                        Navigator.pop(ctx, OrderStatusChoice.unloading),
                  ),
                  _StatusTile(
                    title: t.common_close,
                    icon: Icons.close_rounded,
                    iconBg: const Color(0xFFE5E7EB),
                    iconColor: const Color(0xFF111827),
                    onTap: () => Navigator.pop(ctx, null),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Figtree',
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
