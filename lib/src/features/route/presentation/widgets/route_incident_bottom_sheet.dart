import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/orders/application/report_order_problem_controller.dart';

import '../../application/report_route_event_controller.dart';
import '../../domain/report_route_event_payload.dart';
import '../../domain/route_event_type.dart';

Future<void> showReportEventBottomSheet(
  BuildContext context, {
  required String orderId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: const Color(0xFFF3F1E9),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (sheetCtx) =>
        _ReportEventSheet(orderId: orderId, parentContext: context),
  );
}

class _ReportEventSheet extends ConsumerStatefulWidget {
  const _ReportEventSheet({required this.orderId, required this.parentContext});

  final String orderId;
  final BuildContext parentContext;

  @override
  ConsumerState<_ReportEventSheet> createState() => _ReportEventSheetState();
}

class _ReportEventSheetState extends ConsumerState<_ReportEventSheet> {
  final _descController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  String _label(AppLocalizations t, RouteEventType type) => switch (type) {
    RouteEventType.detour => t.route_report_event_detour,
    RouteEventType.accident => t.route_report_event_accident,
    RouteEventType.delay => t.route_report_event_delay,
  };

  IconData _icon(RouteEventType type) => switch (type) {
    RouteEventType.detour => Icons.alt_route_rounded,
    RouteEventType.accident => Icons.car_crash_rounded,
    RouteEventType.delay => Icons.schedule_rounded,
  };

  Future<void> _reportProblemFlow({required BuildContext sheetContext}) async {
    if (_sending) return;

    final description = await showDialog<String>(
      context: widget.parentContext,
      builder: (_) => const _ReportProblemDialog(),
    );

    if (description == null || description.trim().isEmpty) return;

    setState(() => _sending = true);
    try {
      await ref
          .read(reportOrderProblemControllerProvider.notifier)
          .reportProblem(orderId: widget.orderId, description: description);

      if (!mounted) return;
      Navigator.of(sheetContext).pop(); // close sheet after request

      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        const SnackBar(
          content: Text('Zgłoszono problem'),
          backgroundColor: Color(0xFF0F4D46),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        SnackBar(
          content: Text('Nie udało się zgłosić problemu: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendAndClose({
    required BuildContext sheetContext,
    required RouteEventType type,
  }) async {
    if (_sending) return;
    setState(() => _sending = true);

    Navigator.of(sheetContext).pop();

    final t = AppLocalizations.of(widget.parentContext)!;
    try {
      await ref
          .read(reportRouteEventControllerProvider.notifier)
          .report(
            orderId: widget.orderId,
            payload: ReportRouteEventPayload(
              type: type,
              description: _descController.text,
            ),
          );

      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        SnackBar(
          content: Text(t.route_report_success),
          backgroundColor: const Color(0xFF0F4D46),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        SnackBar(
          content: Text('${t.route_report_error}: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          14,
          0,
          14,
          14 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.route_report_event_title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Figtree',
                color: Color(0xFF0A0A0A),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.55,
              children: [
                for (final type in RouteEventType.values)
                  _ChoiceTile(
                    title: _label(t, type),
                    icon: _icon(type),
                    enabled: !_sending,
                    onTap: () =>
                        _sendAndClose(sheetContext: context, type: type),
                  ),

                _ChoiceTile(
                  title: 'Zgłoś Problem',
                  icon: Icons.report_problem_rounded,
                  iconBg: const Color(0xFFFEE2E2),
                  iconColor: const Color(0xFF991B1B),
                  enabled: !_sending,
                  onTap: () => _reportProblemFlow(sheetContext: context),
                ),

                _ChoiceTile(
                  title: t.common_close,
                  icon: Icons.close_rounded,
                  iconBg: const Color(0xFFE5E7EB),
                  iconColor: const Color(0xFF111827),
                  enabled: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.enabled,
    this.iconBg = const Color(0xFFE9F2EE),
    this.iconColor = const Color(0xFF0F4D46),
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Opacity(
            opacity: enabled ? 1 : 0.45,
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Figtree',
                      color: Color(0xFF0A0A0A),
                      height: 1.1,
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

class _ReportProblemDialog extends StatefulWidget {
  const _ReportProblemDialog();

  @override
  State<_ReportProblemDialog> createState() => _ReportProblemDialogState();
}

class _ReportProblemDialogState extends State<_ReportProblemDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _controller.text.trim().isNotEmpty;

    return AlertDialog(
      title: const Text('Zgłoś Problem'),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        decoration: const InputDecoration(hintText: 'Opisz problem'),
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: canSubmit
              ? () => Navigator.of(context).pop(_controller.text.trim())
              : null,
          child: const Text('Wyślij'),
        ),
      ],
    );
  }
}
