import 'dart:ui';

class SupportedLocales {
  static const pl = Locale('pl');
  static const ru = Locale('ru');

  static const all = <Locale>[pl, ru];

  static String label(Locale locale) => switch (locale.languageCode) {
    'pl' => 'Polski',
    'ru' => 'Russian',
    _ => locale.languageCode,
  };
}
