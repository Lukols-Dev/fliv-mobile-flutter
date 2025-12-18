import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n.dart';

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => SupportedLocales.pl;

  void setLocale(Locale locale) {
    if (!SupportedLocales.all.any((l) => l.languageCode == locale.languageCode))
      return;
    state = locale;
  }
}
