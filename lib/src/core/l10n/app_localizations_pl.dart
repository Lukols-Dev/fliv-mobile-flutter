// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get auth_start_title =>
      'Twój partner logistyczny zapewniający płynną dostawę.';

  @override
  String get auth_start_subtitle =>
      'Nasze usługi logistyczne zapewniają kompleksowe rozwiązania w zakresie transportu.';

  @override
  String get auth_login => 'Zaloguj się';

  @override
  String get auth_register => 'Utwórz konto';

  @override
  String get common_or => 'lub';

  @override
  String get language_pl => 'Polski';

  @override
  String get language_en => 'English';
}
