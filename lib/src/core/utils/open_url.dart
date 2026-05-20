import 'package:flutter/material.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLegalUrl(BuildContext context, String urlString) async {
  final t = AppLocalizations.of(context)!;
  final url = Uri.tryParse(urlString);
  if (url == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.open_url_invalid)));
    }
    return;
  }

  try {
    final ok = await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    );

    if (!ok) {
      final fallback = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!fallback && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.open_url_failed)),
        );
      }
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.open_url_failed)),
      );
    }
  }
}
