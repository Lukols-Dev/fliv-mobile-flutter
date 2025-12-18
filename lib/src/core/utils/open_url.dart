import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLegalUrl(BuildContext context, String urlString) async {
  final url = Uri.tryParse(urlString);
  if (url == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nieprawidłowy adres URL')));
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
          const SnackBar(content: Text('Nie udało się otworzyć linku')),
        );
      }
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się otworzyć linku')),
      );
    }
  }
}
