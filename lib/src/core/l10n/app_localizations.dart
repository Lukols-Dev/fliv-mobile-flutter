import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pl.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pl'),
    Locale('ru'),
  ];

  /// No description provided for @auth_start_title.
  ///
  /// In pl, this message translates to:
  /// **'Twój partner logistyczny zapewniający płynną dostawę.'**
  String get auth_start_title;

  /// No description provided for @auth_start_subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Nasze usługi logistyczne zapewniają kompleksowe rozwiązania w zakresie transportu.'**
  String get auth_start_subtitle;

  /// No description provided for @auth_login.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się'**
  String get auth_login;

  /// No description provided for @auth_register.
  ///
  /// In pl, this message translates to:
  /// **'Utwórz konto'**
  String get auth_register;

  /// No description provided for @auth_login_title.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie'**
  String get auth_login_title;

  /// No description provided for @auth_email_label.
  ///
  /// In pl, this message translates to:
  /// **'Adres email'**
  String get auth_email_label;

  /// No description provided for @auth_email_hint.
  ///
  /// In pl, this message translates to:
  /// **'jan.nowak@example.com'**
  String get auth_email_hint;

  /// No description provided for @auth_password_label.
  ///
  /// In pl, this message translates to:
  /// **'Hasło'**
  String get auth_password_label;

  /// No description provided for @auth_forgot_password.
  ///
  /// In pl, this message translates to:
  /// **'Zapomniałeś hasła?'**
  String get auth_forgot_password;

  /// No description provided for @auth_terms_text.
  ///
  /// In pl, this message translates to:
  /// **'Logując się, akceptujesz regulamin serwisu oraz politykę prywatności'**
  String get auth_terms_text;

  /// No description provided for @auth_register_title.
  ///
  /// In pl, this message translates to:
  /// **'Utwórz nowe konto aby rozpocząć'**
  String get auth_register_title;

  /// No description provided for @auth_first_name_label.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get auth_first_name_label;

  /// No description provided for @auth_first_name_hint.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get auth_first_name_hint;

  /// No description provided for @auth_last_name_label.
  ///
  /// In pl, this message translates to:
  /// **'Nazwisko'**
  String get auth_last_name_label;

  /// No description provided for @auth_last_name_hint.
  ///
  /// In pl, this message translates to:
  /// **'Nazwisko'**
  String get auth_last_name_hint;

  /// No description provided for @auth_company_id_label.
  ///
  /// In pl, this message translates to:
  /// **'Id Firmy'**
  String get auth_company_id_label;

  /// No description provided for @auth_company_id_hint.
  ///
  /// In pl, this message translates to:
  /// **'Id Firmy'**
  String get auth_company_id_hint;

  /// No description provided for @auth_already_have_account.
  ///
  /// In pl, this message translates to:
  /// **'Masz już konto? Zaloguj się'**
  String get auth_already_have_account;

  /// No description provided for @auth_forgot_password_title.
  ///
  /// In pl, this message translates to:
  /// **'Zapomniałeś hasła?'**
  String get auth_forgot_password_title;

  /// No description provided for @auth_forgot_password_description.
  ///
  /// In pl, this message translates to:
  /// **'Nie martw się! To się zdarza. Wpisz adres e-mail powiązany z Twoim kontem.'**
  String get auth_forgot_password_description;

  /// No description provided for @auth_send_link.
  ///
  /// In pl, this message translates to:
  /// **'Wyślij link'**
  String get auth_send_link;

  /// No description provided for @common_or.
  ///
  /// In pl, this message translates to:
  /// **'lub'**
  String get common_or;

  /// No description provided for @language_pl.
  ///
  /// In pl, this message translates to:
  /// **'Polski'**
  String get language_pl;

  /// No description provided for @language_en.
  ///
  /// In pl, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @profile_user_profile.
  ///
  /// In pl, this message translates to:
  /// **'Profil użytkownika'**
  String get profile_user_profile;

  /// No description provided for @profile_your_data.
  ///
  /// In pl, this message translates to:
  /// **'Twoje dane'**
  String get profile_your_data;

  /// No description provided for @profile_driver_data.
  ///
  /// In pl, this message translates to:
  /// **'Dane kierowcy'**
  String get profile_driver_data;

  /// No description provided for @profile_app_settings.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia aplikacji'**
  String get profile_app_settings;

  /// No description provided for @profile_location.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja'**
  String get profile_location;

  /// No description provided for @profile_language.
  ///
  /// In pl, this message translates to:
  /// **'Język polski'**
  String get profile_language;

  /// No description provided for @profile_about_app.
  ///
  /// In pl, this message translates to:
  /// **'O aplikacji'**
  String get profile_about_app;

  /// No description provided for @profile_terms.
  ///
  /// In pl, this message translates to:
  /// **'Regulamin'**
  String get profile_terms;

  /// No description provided for @profile_privacy_policy.
  ///
  /// In pl, this message translates to:
  /// **'Polityka prywatności'**
  String get profile_privacy_policy;

  /// No description provided for @profile_logout.
  ///
  /// In pl, this message translates to:
  /// **'Wyloguj się'**
  String get profile_logout;

  /// No description provided for @profile_phone_label.
  ///
  /// In pl, this message translates to:
  /// **'Telefon'**
  String get profile_phone_label;

  /// No description provided for @common_save.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get common_save;

  /// No description provided for @driver_data_visa_deadline.
  ///
  /// In pl, this message translates to:
  /// **'Termin wizy'**
  String get driver_data_visa_deadline;

  /// No description provided for @driver_data_license_deadline.
  ///
  /// In pl, this message translates to:
  /// **'Termin prawa jazdy'**
  String get driver_data_license_deadline;

  /// No description provided for @driver_data_work_permit_deadline.
  ///
  /// In pl, this message translates to:
  /// **'Termin pozwolenia na pracę'**
  String get driver_data_work_permit_deadline;

  /// No description provided for @driver_data_medical_exam_deadline.
  ///
  /// In pl, this message translates to:
  /// **'Termin badania lekarskiego'**
  String get driver_data_medical_exam_deadline;

  /// No description provided for @driver_data_psychological_exam_deadline.
  ///
  /// In pl, this message translates to:
  /// **'Termin badania psychologicznego'**
  String get driver_data_psychological_exam_deadline;

  /// No description provided for @driver_data_driver_card_deadline.
  ///
  /// In pl, this message translates to:
  /// **'Termin karty kierowcy'**
  String get driver_data_driver_card_deadline;

  /// No description provided for @driver_data_residence_card_deadline.
  ///
  /// In pl, this message translates to:
  /// **'Termin karty pobytu'**
  String get driver_data_residence_card_deadline;

  /// No description provided for @driver_data_driver_certificate_deadline.
  ///
  /// In pl, this message translates to:
  /// **'Termin świadectwa kierowcy'**
  String get driver_data_driver_certificate_deadline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pl', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pl':
      return AppLocalizationsPl();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
