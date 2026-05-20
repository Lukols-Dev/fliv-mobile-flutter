import 'package:flutter/material.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';

class RouteControlsPanel extends StatelessWidget {
  const RouteControlsPanel({
    super.key,
    required this.isFollowing,
    required this.onReportEvent,
    required this.onPause,
    required this.onResume,
    required this.onFinishRoute,
  });

  final bool isFollowing;

  final VoidCallback onReportEvent;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onFinishRoute;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF3F1E9)),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.route_controls_title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Figtree',
              color: Color(0xFF0A0A0A),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: GridView.count(
              padding: EdgeInsets.zero, // ważne
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.55,
              children: [
                _ControlTile(
                  label: t.route_controls_report_event,
                  icon: Icons.report_gmailerrorred_rounded,
                  iconColor: Color(0xFFEF4444),
                  iconBg: Color(0xFFFEE2E2),
                  onTap: onReportEvent,
                ),
                _ControlTile(
                  label: t.route_controls_pause,
                  icon: Icons.pause_rounded,
                  iconColor: Color(0xFF709470),
                  iconBg: Color(0xFFE7EFE7),
                  onTap: isFollowing ? onPause : null,
                ),
                _ControlTile(
                  label: t.route_controls_resume,
                  icon: Icons.play_arrow_rounded,
                  iconColor: Color(0xFF0F4D46),
                  iconBg: Color(0xFFE7EFE7),
                  onTap: !isFollowing ? onResume : null,
                ),
                _ControlTile(
                  label: t.route_controls_finish_route,
                  icon: Icons.check_circle_rounded,
                  iconColor: Color(0xFF709470),
                  iconBg: Color(0xFFE7EFE7),
                  onTap: onFinishRoute,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlTile extends StatelessWidget {
  const _ControlTile({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                  spreadRadius: -6,
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Figtree',
                    color: Color(0xFF0A0A0A),
                    height: 1.15,
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
