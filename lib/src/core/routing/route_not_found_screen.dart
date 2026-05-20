import 'package:flutter/material.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';

class RouteNotFoundScreen extends StatelessWidget {
  const RouteNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(child: Center(child: Text(t.route_not_found))),
    );
  }
}
