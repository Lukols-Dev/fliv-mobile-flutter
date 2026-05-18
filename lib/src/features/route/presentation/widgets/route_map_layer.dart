import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/navigation.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/transport.dart';

import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';

class RouteMapLayer extends StatelessWidget {
  const RouteMapLayer({
    super.key,
    required this.controller,
    required this.onBack,
    required this.bottomPaddingForFab,
    this.onReportEvent,
  });

  final RouteMapController controller;
  final VoidCallback onBack;
  final double bottomPaddingForFab;
  final VoidCallback? onReportEvent;

  static final Set<Factory<OneSequenceGestureRecognizer>>
      _mapGestureRecognizers = {
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Stack(
      children: [
        HereMap(
          gestureRecognizers: _mapGestureRecognizers,
          onMapCreated: (map) => controller.onMapCreated(map),
        ),

        // BACK
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: IconButton(
                  tooltip: t.common_back,
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
            ),
          ),
        ),

        // MANEUVER BANNER + LANE ASSISTANCE (top, visible only during active navigation)
        if (controller.isFollowing)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(72, 8, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (controller.nextManeuverAction != null)
                      _ManeuverBanner(
                        action: controller.nextManeuverAction!,
                        distanceMeters: controller.distanceToNextManeuverMeters,
                        roadName: controller.nextRoadName,
                      ),
                    if (controller.lanesForNextManeuver != null) ...[
                      const SizedBox(height: 6),
                      _LaneAssistanceBar(lanes: controller.lanesForNextManeuver!),
                    ],
                    if (controller.safetyCameraWarning != null) ...[
                      const SizedBox(height: 6),
                      _SafetyCameraCard(warning: controller.safetyCameraWarning!),
                    ],
                  ],
                ),
              ),
            ),
          ),

        // BOTTOM-RIGHT: center button + speed panel (when following)
        SafeArea(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 12, bottomPaddingForFab),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!(controller.isFollowing && controller.isCameraTracking))
                    Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: IconButton(
                        tooltip: t.route_center_on_my_location,
                        icon: const Icon(Icons.my_location_rounded),
                        onPressed: () async {
                          try {
                            await controller.refreshAndCenter();
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${t.common_location}: $e'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  if (controller.isFollowing) ...[
                    const SizedBox(height: 10),
                    ...controller.activeTruckRestrictions.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _TruckRestrictionBadge(restriction: r),
                      ),
                    ),
                    _SpeedWidget(
                      speedLimitKmh: controller.currentSpeedLimitKmh,
                      currentSpeedKmh: controller.currentSpeedKmh!,
                      isExceeded: controller.isSpeedExceeded,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // BOTTOM-LEFT: report event button (when following)
        if (controller.isFollowing && onReportEvent != null)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 16, 16, bottomPaddingForFab),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: IconButton(
                    tooltip: t.route_report_event_title,
                    icon: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFF2542F),
                    ),
                    onPressed: onReportEvent,
                  ),
                ),
              ),
            ),
          ),

        // REROUTING OVERLAY
        if (controller.isRerouting)
          _ReroutingOverlay(label: t.route_rerouting),
      ],
    );
  }
}

class _ManeuverBanner extends StatelessWidget {
  const _ManeuverBanner({
    required this.action,
    required this.distanceMeters,
    required this.roadName,
  });

  final ManeuverAction action;
  final int? distanceMeters;
  final String? roadName;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      color: const Color(0xFF0F4D46),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _maneuverIcon(action),
              color: Colors.white,
              size: 36,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (distanceMeters != null)
                    Text(
                      _formatDistance(distanceMeters!),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Figtree',
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  if (roadName != null && roadName!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      roadName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                        color: Color(0xFFB2DDD8),
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(int meters) {
    if (meters < 1000) return '$meters m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  IconData _maneuverIcon(ManeuverAction action) => switch (action) {
    ManeuverAction.depart => Icons.navigation_rounded,
    ManeuverAction.arrive => Icons.flag_rounded,
    ManeuverAction.leftUTurn => Icons.u_turn_left_rounded,
    ManeuverAction.rightUTurn => Icons.u_turn_right_rounded,
    ManeuverAction.sharpLeftTurn ||
    ManeuverAction.leftTurn => Icons.turn_left_rounded,
    ManeuverAction.slightLeftTurn => Icons.turn_slight_left_rounded,
    ManeuverAction.sharpRightTurn ||
    ManeuverAction.rightTurn => Icons.turn_right_rounded,
    ManeuverAction.slightRightTurn => Icons.turn_slight_right_rounded,
    ManeuverAction.continueOn ||
    ManeuverAction.middleFork => Icons.straight_rounded,
    ManeuverAction.leftExit ||
    ManeuverAction.leftRamp ||
    ManeuverAction.enterHighwayFromLeft => Icons.ramp_left_rounded,
    ManeuverAction.rightExit ||
    ManeuverAction.rightRamp ||
    ManeuverAction.enterHighwayFromRight => Icons.ramp_right_rounded,
    ManeuverAction.leftFork => Icons.fork_left_rounded,
    ManeuverAction.rightFork => Icons.fork_right_rounded,
    ManeuverAction.leftRoundaboutEnter ||
    ManeuverAction.leftRoundaboutPass ||
    ManeuverAction.leftRoundaboutExit1 ||
    ManeuverAction.leftRoundaboutExit2 ||
    ManeuverAction.leftRoundaboutExit3 ||
    ManeuverAction.leftRoundaboutExit4 ||
    ManeuverAction.leftRoundaboutExit5 ||
    ManeuverAction.leftRoundaboutExit6 ||
    ManeuverAction.leftRoundaboutExit7 ||
    ManeuverAction.leftRoundaboutExit8 ||
    ManeuverAction.leftRoundaboutExit9 ||
    ManeuverAction.leftRoundaboutExit10 ||
    ManeuverAction.leftRoundaboutExit11 ||
    ManeuverAction.leftRoundaboutExit12 => Icons.roundabout_right_rounded,
    ManeuverAction.rightRoundaboutEnter ||
    ManeuverAction.rightRoundaboutPass ||
    ManeuverAction.rightRoundaboutExit1 ||
    ManeuverAction.rightRoundaboutExit2 ||
    ManeuverAction.rightRoundaboutExit3 ||
    ManeuverAction.rightRoundaboutExit4 ||
    ManeuverAction.rightRoundaboutExit5 ||
    ManeuverAction.rightRoundaboutExit6 ||
    ManeuverAction.rightRoundaboutExit7 ||
    ManeuverAction.rightRoundaboutExit8 ||
    ManeuverAction.rightRoundaboutExit9 ||
    ManeuverAction.rightRoundaboutExit10 ||
    ManeuverAction.rightRoundaboutExit11 ||
    ManeuverAction.rightRoundaboutExit12 => Icons.roundabout_left_rounded,
  };
}

class _SpeedWidget extends StatelessWidget {
  const _SpeedWidget({
    required this.speedLimitKmh,
    required this.currentSpeedKmh,
    required this.isExceeded,
  });

  final double? speedLimitKmh;
  final double currentSpeedKmh;
  final bool isExceeded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speed limit circle
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isExceeded ? const Color(0xFFDC2626) : Colors.white,
                border: Border.all(
                  color: const Color(0xFFDC2626),
                  width: 4,
                ),
              ),
              child: Center(
                child: speedLimitKmh != null
                    ? Text(
                        speedLimitKmh!.round().toString(),
                        style: TextStyle(
                          fontSize: speedLimitKmh! >= 100 ? 15 : 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Figtree',
                          color: isExceeded ? Colors.white : const Color(0xFF111827),
                          height: 1.0,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Divider(height: 8, thickness: 1, color: Color(0xFFE5E7EB)),
          ),
          // Current speed
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentSpeedKmh.round().toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Figtree',
                    color: isExceeded ? const Color(0xFFDC2626) : const Color(0xFF111827),
                    height: 1.1,
                  ),
                ),
                Text(
                  'km/h',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
                    color: Color(0xFF6B7280),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LaneAssistanceBar extends StatelessWidget {
  const _LaneAssistanceBar({required this.lanes});

  final List<Lane> lanes;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(14),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: lanes
              .map((lane) => _LaneTile(lane: lane))
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _LaneTile extends StatelessWidget {
  const _LaneTile({required this.lane});

  final Lane lane;

  static const _tileSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final isHighly = lane.recommendationState == LaneRecommendationState.highlyRecommended;
    final isRecommended = lane.recommendationState == LaneRecommendationState.recommended;
    final isActive = isHighly || isRecommended;

    final bgColor = isHighly
        ? const Color(0xFF0F4D46)
        : isRecommended
            ? const Color(0xFFD1FAE5)
            : const Color(0xFFF3F4F6);

    final iconColor = isHighly
        ? Colors.white
        : isRecommended
            ? const Color(0xFF065F46)
            : const Color(0xFF9CA3AF);

    // Primary direction: prefer directionsOnRoute, fall back to first direction
    final directions = lane.directionsOnRoute.isNotEmpty
        ? lane.directionsOnRoute
        : lane.directions;
    final primary = directions.isNotEmpty ? directions.first : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _tileSize,
        height: _tileSize,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: isActive
              ? Border.all(
                  color: isHighly
                      ? const Color(0xFF0F4D46)
                      : const Color(0xFF6EE7B7),
                  width: 1.5,
                )
              : null,
        ),
        child: Icon(
          _directionIcon(primary),
          color: iconColor,
          size: 22,
        ),
      ),
    );
  }

  IconData _directionIcon(LaneDirection? direction) => switch (direction) {
    LaneDirection.straight => Icons.straight_rounded,
    LaneDirection.slightLeft => Icons.turn_slight_left_rounded,
    LaneDirection.quiteLeft => Icons.turn_left_rounded,
    LaneDirection.hardLeft => Icons.turn_sharp_left_rounded,
    LaneDirection.uTurnLeft => Icons.u_turn_left_rounded,
    LaneDirection.slightRight => Icons.turn_slight_right_rounded,
    LaneDirection.quiteRight => Icons.turn_right_rounded,
    LaneDirection.hardRight => Icons.turn_sharp_right_rounded,
    LaneDirection.uTurnRight => Icons.u_turn_right_rounded,
    LaneDirection.mergeLeft => Icons.merge_rounded,
    LaneDirection.mergeRight => Icons.merge_rounded,
    LaneDirection.mergeLanes => Icons.merge_rounded,
    LaneDirection.secondLeft => Icons.fork_left_rounded,
    LaneDirection.secondRight => Icons.fork_right_rounded,
    null => Icons.straight_rounded,
  };
}

class _SafetyCameraCard extends StatelessWidget {
  const _SafetyCameraCard({required this.warning});

  final SafetyCameraWarning warning;

  @override
  Widget build(BuildContext context) {
    final cardColor = _cardColor(warning.type);
    final limitKmh = warning.speedLimitInMetersPerSecond > 0
        ? (warning.speedLimitInMetersPerSecond * 3.6).round()
        : null;

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _cameraIcon(warning.type),
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDistance(warning.distanceToCameraInMeters),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Figtree',
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  if (limitKmh != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '$limitKmh km/h',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                        color: Color(0xFFFFE4E4),
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Color _cardColor(SafetyCameraType type) => switch (type) {
    SafetyCameraType.redLight => const Color(0xFFB91C1C),
    SafetyCameraType.redLightAndSpeed => const Color(0xFFB91C1C),
    SafetyCameraType.speed => const Color(0xFFD97706),
    SafetyCameraType.sectionStart => const Color(0xFFD97706),
    SafetyCameraType.sectionEnd => const Color(0xFFD97706),
    SafetyCameraType.busLane => const Color(0xFF1D4ED8),
    SafetyCameraType.distance => const Color(0xFF1D4ED8),
  };

  IconData _cameraIcon(SafetyCameraType type) => switch (type) {
    SafetyCameraType.redLight => Icons.traffic_rounded,
    SafetyCameraType.redLightAndSpeed => Icons.traffic_rounded,
    SafetyCameraType.speed => Icons.speed_rounded,
    SafetyCameraType.sectionStart => Icons.photo_camera_rounded,
    SafetyCameraType.sectionEnd => Icons.photo_camera_rounded,
    SafetyCameraType.busLane => Icons.directions_bus_rounded,
    SafetyCameraType.distance => Icons.social_distance_rounded,
  };
}

class _TruckRestrictionBadge extends StatelessWidget {
  const _TruckRestrictionBadge({required this.restriction});

  final TruckRestrictionWarning restriction;

  @override
  Widget build(BuildContext context) {
    final (icon, label, borderColor) = _badgeContent(restriction);

    return Container(
      width: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: borderColor),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              fontFamily: 'Figtree',
              color: borderColor,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String, Color) _badgeContent(TruckRestrictionWarning r) {
    if (r.hazardousMaterials.isNotEmpty) {
      return (
        Icons.warning_amber_rounded,
        'ADR',
        const Color(0xFFDC2626),
      );
    }
    final dim = r.dimensionRestriction;
    if (dim != null) {
      final meters = (dim.valueInCentimeters / 100);
      final label = meters == meters.truncateToDouble()
          ? '${meters.toInt()} m'
          : '${meters.toStringAsFixed(1)} m';
      return switch (dim.type) {
        DimensionRestrictionType.truckHeight => (
            Icons.height_rounded,
            label,
            const Color(0xFFD97706),
          ),
        DimensionRestrictionType.truckWidth => (
            Icons.swap_horiz_rounded,
            label,
            const Color(0xFFD97706),
          ),
        DimensionRestrictionType.truckLength => (
            Icons.straighten_rounded,
            label,
            const Color(0xFFD97706),
          ),
      };
    }
    final weight = r.weightRestriction;
    if (weight != null) {
      final tons = weight.valueInKilograms / 1000;
      final label = tons == tons.truncateToDouble()
          ? '${tons.toInt()} t'
          : '${tons.toStringAsFixed(1)} t';
      return (Icons.monitor_weight_rounded, label, const Color(0xFFD97706));
    }
    return (Icons.local_shipping_rounded, '!', const Color(0xFFD97706));
  }
}

class _ReroutingOverlay extends StatelessWidget {
  const _ReroutingOverlay({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF0F4D46),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 18),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Figtree',
                    color: Color(0xFF111827),
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
