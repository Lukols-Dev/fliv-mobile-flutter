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
  /// **'email@example.com'**
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

  /// No description provided for @auth_invalid_email.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy adres email'**
  String get auth_invalid_email;

  /// No description provided for @auth_login_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy email lub hasło'**
  String get auth_login_failed;

  /// No description provided for @auth_register_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się utworzyć konta'**
  String get auth_register_failed;

  /// No description provided for @common_or.
  ///
  /// In pl, this message translates to:
  /// **'lub'**
  String get common_or;

  /// No description provided for @common_fill_all_fields.
  ///
  /// In pl, this message translates to:
  /// **'Wypełnij wszystkie pola'**
  String get common_fill_all_fields;

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

  /// No description provided for @profile_save_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zapisać danych'**
  String get profile_save_failed;

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

  /// No description provided for @driver_data_invalid_date.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowa data'**
  String get driver_data_invalid_date;

  /// No description provided for @driver_data_save_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zapisać danych'**
  String get driver_data_save_failed;

  /// No description provided for @order_details_title.
  ///
  /// In pl, this message translates to:
  /// **'Szczegóły zlecenia'**
  String get order_details_title;

  /// No description provided for @order_status_in_transit.
  ///
  /// In pl, this message translates to:
  /// **'W trasie'**
  String get order_status_in_transit;

  /// No description provided for @order_client_data.
  ///
  /// In pl, this message translates to:
  /// **'Dane klienta'**
  String get order_client_data;

  /// No description provided for @order_contact_person.
  ///
  /// In pl, this message translates to:
  /// **'Osoba kontaktowa'**
  String get order_contact_person;

  /// No description provided for @order_phone.
  ///
  /// In pl, this message translates to:
  /// **'Telefon'**
  String get order_phone;

  /// No description provided for @order_transport_route.
  ///
  /// In pl, this message translates to:
  /// **'Trasa transportu'**
  String get order_transport_route;

  /// No description provided for @order_loading_point.
  ///
  /// In pl, this message translates to:
  /// **'Punkt załadunku'**
  String get order_loading_point;

  /// No description provided for @order_unloading_point.
  ///
  /// In pl, this message translates to:
  /// **'Punkt rozładunku'**
  String get order_unloading_point;

  /// No description provided for @order_loaded.
  ///
  /// In pl, this message translates to:
  /// **'Załadowano'**
  String get order_loaded;

  /// No description provided for @order_en_route.
  ///
  /// In pl, this message translates to:
  /// **'W drodze'**
  String get order_en_route;

  /// No description provided for @order_cargo.
  ///
  /// In pl, this message translates to:
  /// **'Ładunek'**
  String get order_cargo;

  /// No description provided for @order_cargo_type.
  ///
  /// In pl, this message translates to:
  /// **'Rodzaj towaru'**
  String get order_cargo_type;

  /// No description provided for @order_weight.
  ///
  /// In pl, this message translates to:
  /// **'Waga'**
  String get order_weight;

  /// No description provided for @order_pallets.
  ///
  /// In pl, this message translates to:
  /// **'Palety'**
  String get order_pallets;

  /// No description provided for @order_notes.
  ///
  /// In pl, this message translates to:
  /// **'Uwagi'**
  String get order_notes;

  /// No description provided for @order_start_navigation.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij nawigację'**
  String get order_start_navigation;

  /// No description provided for @order_view_documents.
  ///
  /// In pl, this message translates to:
  /// **'Zobacz dokumenty'**
  String get order_view_documents;

  /// No description provided for @order_eta.
  ///
  /// In pl, this message translates to:
  /// **'ETA'**
  String get order_eta;

  /// No description provided for @documents_title.
  ///
  /// In pl, this message translates to:
  /// **'Dokumenty'**
  String get documents_title;

  /// No description provided for @documents_filter_all.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie'**
  String get documents_filter_all;

  /// No description provided for @documents_filter_synchronized.
  ///
  /// In pl, this message translates to:
  /// **'Zsynchronizowane'**
  String get documents_filter_synchronized;

  /// No description provided for @documents_filter_local.
  ///
  /// In pl, this message translates to:
  /// **'Lokalne'**
  String get documents_filter_local;

  /// No description provided for @documents_status_synchronized.
  ///
  /// In pl, this message translates to:
  /// **'Zsynchronizowano'**
  String get documents_status_synchronized;

  /// No description provided for @documents_status_local_only.
  ///
  /// In pl, this message translates to:
  /// **'Tylko lokalnie'**
  String get documents_status_local_only;

  /// No description provided for @documents_status_syncing.
  ///
  /// In pl, this message translates to:
  /// **'Synchronizacja...'**
  String get documents_status_syncing;

  /// No description provided for @documents_add_title.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj dokument'**
  String get documents_add_title;

  /// No description provided for @documents_add_subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wypełnij informacje o nowym dokumencie'**
  String get documents_add_subtitle;

  /// No description provided for @documents_add_photo_label.
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcie dokumentu'**
  String get documents_add_photo_label;

  /// No description provided for @documents_add_photo_hint.
  ///
  /// In pl, this message translates to:
  /// **'Zrób zdjęcie lub wybierz z galerii'**
  String get documents_add_photo_hint;

  /// No description provided for @documents_add_photo_max_size.
  ///
  /// In pl, this message translates to:
  /// **'Maksymalny rozmiar: 10 MB'**
  String get documents_add_photo_max_size;

  /// No description provided for @documents_add_name_label.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa dokumentu'**
  String get documents_add_name_label;

  /// No description provided for @documents_add_name_hint.
  ///
  /// In pl, this message translates to:
  /// **'np. CMR - List przewozowy'**
  String get documents_add_name_hint;

  /// No description provided for @documents_add_button.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj dokument'**
  String get documents_add_button;

  /// No description provided for @route_report_event_title.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś'**
  String get route_report_event_title;

  /// No description provided for @route_report_event_detour.
  ///
  /// In pl, this message translates to:
  /// **'Objazd'**
  String get route_report_event_detour;

  /// No description provided for @route_report_event_accident.
  ///
  /// In pl, this message translates to:
  /// **'Wypadek'**
  String get route_report_event_accident;

  /// No description provided for @route_report_event_delay.
  ///
  /// In pl, this message translates to:
  /// **'Opóźnienie'**
  String get route_report_event_delay;

  /// No description provided for @common_close.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get common_close;

  /// No description provided for @route_report_success.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoszono zdarzenie'**
  String get route_report_success;

  /// No description provided for @route_report_error.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zgłosić zdarzenia'**
  String get route_report_error;

  /// No description provided for @home_welcome_back.
  ///
  /// In pl, this message translates to:
  /// **'Witaj z powrotem!'**
  String get home_welcome_back;

  /// No description provided for @order_status_in_progress.
  ///
  /// In pl, this message translates to:
  /// **'W trasie'**
  String get order_status_in_progress;

  /// No description provided for @order_status_loading.
  ///
  /// In pl, this message translates to:
  /// **'Załadunek'**
  String get order_status_loading;

  /// No description provided for @order_status_unloading.
  ///
  /// In pl, this message translates to:
  /// **'Rozładunek'**
  String get order_status_unloading;

  /// No description provided for @order_status_paused.
  ///
  /// In pl, this message translates to:
  /// **'Pauza'**
  String get order_status_paused;

  /// No description provided for @order_status_completed.
  ///
  /// In pl, this message translates to:
  /// **'Zakończone'**
  String get order_status_completed;

  /// No description provided for @order_status_problem.
  ///
  /// In pl, this message translates to:
  /// **'Problem'**
  String get order_status_problem;

  /// No description provided for @order_status_pending.
  ///
  /// In pl, this message translates to:
  /// **'Oczekuje'**
  String get order_status_pending;

  /// No description provided for @order_status_accepted.
  ///
  /// In pl, this message translates to:
  /// **'Zaakceptowane'**
  String get order_status_accepted;

  /// No description provided for @common_id_label.
  ///
  /// In pl, this message translates to:
  /// **'ID'**
  String get common_id_label;

  /// No description provided for @common_location.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja'**
  String get common_location;

  /// No description provided for @common_yes.
  ///
  /// In pl, this message translates to:
  /// **'Tak'**
  String get common_yes;

  /// No description provided for @common_no.
  ///
  /// In pl, this message translates to:
  /// **'Nie'**
  String get common_no;

  /// No description provided for @common_kg_short.
  ///
  /// In pl, this message translates to:
  /// **'kg'**
  String get common_kg_short;

  /// No description provided for @common_email.
  ///
  /// In pl, this message translates to:
  /// **'Email'**
  String get common_email;

  /// No description provided for @home_current_location_title.
  ///
  /// In pl, this message translates to:
  /// **'Obecna lokalizacja'**
  String get home_current_location_title;

  /// No description provided for @home_location_fetching.
  ///
  /// In pl, this message translates to:
  /// **'Pobieranie lokalizacji…'**
  String get home_location_fetching;

  /// No description provided for @home_location_tap_refresh.
  ///
  /// In pl, this message translates to:
  /// **'Kliknij odśwież, aby pobrać'**
  String get home_location_tap_refresh;

  /// No description provided for @home_location_resolving_address.
  ///
  /// In pl, this message translates to:
  /// **'Ustalanie adresu…'**
  String get home_location_resolving_address;

  /// No description provided for @home_location_address_not_found.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się ustalić adresu'**
  String get home_location_address_not_found;

  /// No description provided for @home_location_fetch_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać'**
  String get home_location_fetch_failed;

  /// No description provided for @home_refresh_location_tooltip.
  ///
  /// In pl, this message translates to:
  /// **'Odśwież lokalizację'**
  String get home_refresh_location_tooltip;

  /// No description provided for @home_current_order_title.
  ///
  /// In pl, this message translates to:
  /// **'Aktualne Zlecenie'**
  String get home_current_order_title;

  /// No description provided for @home_enter_zt_number.
  ///
  /// In pl, this message translates to:
  /// **'Podaj numer ZT.'**
  String get home_enter_zt_number;

  /// No description provided for @home_order_assigned.
  ///
  /// In pl, this message translates to:
  /// **'Zlecenie przypisane.'**
  String get home_order_assigned;

  /// No description provided for @home_assign_order_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się przypisać zlecenia'**
  String get home_assign_order_failed;

  /// No description provided for @home_no_assigned_order_title.
  ///
  /// In pl, this message translates to:
  /// **'Brak przypisanego zlecenia'**
  String get home_no_assigned_order_title;

  /// No description provided for @home_no_assigned_order_description.
  ///
  /// In pl, this message translates to:
  /// **'Aby przypisać zlecenie, wpisz numer ZT otrzymany od dyspozytora.'**
  String get home_no_assigned_order_description;

  /// No description provided for @home_zt_hint.
  ///
  /// In pl, this message translates to:
  /// **'np. ZT-123456'**
  String get home_zt_hint;

  /// No description provided for @home_assign_order_button.
  ///
  /// In pl, this message translates to:
  /// **'Przypisz zlecenie'**
  String get home_assign_order_button;

  /// No description provided for @home_order_number_label.
  ///
  /// In pl, this message translates to:
  /// **'Numer zlecenia'**
  String get home_order_number_label;

  /// No description provided for @home_open_navigation.
  ///
  /// In pl, this message translates to:
  /// **'Otwórz nawigację'**
  String get home_open_navigation;

  /// No description provided for @order_missing_id.
  ///
  /// In pl, this message translates to:
  /// **'Brak ID zlecenia'**
  String get order_missing_id;

  /// No description provided for @order_fetch_failed.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania zlecenia'**
  String get order_fetch_failed;

  /// No description provided for @order_company_name_label.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa firmy'**
  String get order_company_name_label;

  /// No description provided for @order_temperature_sensitive_label.
  ///
  /// In pl, this message translates to:
  /// **'Wrażliwość na temperaturę'**
  String get order_temperature_sensitive_label;

  /// No description provided for @documents_offline_message.
  ///
  /// In pl, this message translates to:
  /// **'Offline: możesz dodawać dokumenty lokalnie i synchronizować później.'**
  String get documents_offline_message;

  /// No description provided for @documents_no_assigned_zt_title.
  ///
  /// In pl, this message translates to:
  /// **'Brak przypisanego ZT'**
  String get documents_no_assigned_zt_title;

  /// No description provided for @documents_no_assigned_zt_description.
  ///
  /// In pl, this message translates to:
  /// **'Aby dodać dokument, najpierw przypisz zlecenie (ZT).'**
  String get documents_no_assigned_zt_description;

  /// No description provided for @documents_default_title.
  ///
  /// In pl, this message translates to:
  /// **'Dokument'**
  String get documents_default_title;

  /// No description provided for @documents_empty_list.
  ///
  /// In pl, this message translates to:
  /// **'Brak dokumentów. Dodaj pierwszy dokument.'**
  String get documents_empty_list;

  /// No description provided for @documents_delete_document_title.
  ///
  /// In pl, this message translates to:
  /// **'Usuń dokument'**
  String get documents_delete_document_title;

  /// No description provided for @common_cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get common_cancel;

  /// No description provided for @common_delete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get common_delete;

  /// No description provided for @documents_delete_local_confirm.
  ///
  /// In pl, this message translates to:
  /// **'Usunąć dokument lokalnie z telefonu?'**
  String get documents_delete_local_confirm;

  /// No description provided for @documents_delete_remote_confirm.
  ///
  /// In pl, this message translates to:
  /// **'Usunąć dokument z serwera?'**
  String get documents_delete_remote_confirm;

  /// No description provided for @documents_offline_error.
  ///
  /// In pl, this message translates to:
  /// **'Jesteś offline. Możesz dodawać dokumenty lokalnie i zsynchronizować później.'**
  String get documents_offline_error;

  /// No description provided for @documents_fetch_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać dokumentów z serwera.'**
  String get documents_fetch_failed;

  /// No description provided for @documents_sync_action.
  ///
  /// In pl, this message translates to:
  /// **'Synchronizuj'**
  String get documents_sync_action;

  /// No description provided for @documents_status_failed.
  ///
  /// In pl, this message translates to:
  /// **'Błąd synchronizacji'**
  String get documents_status_failed;

  /// No description provided for @documents_options_tooltip.
  ///
  /// In pl, this message translates to:
  /// **'Opcje'**
  String get documents_options_tooltip;

  /// No description provided for @documents_preview_load_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się załadować podglądu.'**
  String get documents_preview_load_failed;

  /// No description provided for @route_navigation_title.
  ///
  /// In pl, this message translates to:
  /// **'Nawigacja'**
  String get route_navigation_title;

  /// No description provided for @route_no_order_title.
  ///
  /// In pl, this message translates to:
  /// **'Brak przypisanego aktualnie zlecenia.'**
  String get route_no_order_title;

  /// No description provided for @route_no_order_description.
  ///
  /// In pl, this message translates to:
  /// **'Gdy dyspozytor przypisze zlecenie, tutaj pojawi się trasa oraz przycisk rozpoczęcia.'**
  String get route_no_order_description;

  /// No description provided for @route_distance_label.
  ///
  /// In pl, this message translates to:
  /// **'Dystans'**
  String get route_distance_label;

  /// No description provided for @route_time_label.
  ///
  /// In pl, this message translates to:
  /// **'Czas'**
  String get route_time_label;

  /// No description provided for @route_eta_arrival.
  ///
  /// In pl, this message translates to:
  /// **'Przyjazd'**
  String get route_eta_arrival;

  /// No description provided for @route_route_not_calculated.
  ///
  /// In pl, this message translates to:
  /// **'Trasa: jeszcze nie wyznaczona.'**
  String get route_route_not_calculated;

  /// No description provided for @route_no_configured_route.
  ///
  /// In pl, this message translates to:
  /// **'Brak skonfigurowanej trasy.'**
  String get route_no_configured_route;

  /// No description provided for @route_loading_route.
  ///
  /// In pl, this message translates to:
  /// **'Ładowanie trasy...'**
  String get route_loading_route;

  /// No description provided for @route_route_error.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się pobrać lub wyznaczyć trasy'**
  String get route_route_error;

  /// No description provided for @route_next_point.
  ///
  /// In pl, this message translates to:
  /// **'Następny punkt'**
  String get route_next_point;

  /// No description provided for @route_next_instruction_label.
  ///
  /// In pl, this message translates to:
  /// **'Następny manewr'**
  String get route_next_instruction_label;

  /// No description provided for @route_calculate_route.
  ///
  /// In pl, this message translates to:
  /// **'Wyznacz trasę'**
  String get route_calculate_route;

  /// No description provided for @route_calculate_approach.
  ///
  /// In pl, this message translates to:
  /// **'Wylicz dojazd'**
  String get route_calculate_approach;

  /// No description provided for @route_approach_label.
  ///
  /// In pl, this message translates to:
  /// **'Dojazd do startu'**
  String get route_approach_label;

  /// No description provided for @route_stop.
  ///
  /// In pl, this message translates to:
  /// **'Zatrzymaj'**
  String get route_stop;

  /// No description provided for @route_start_route.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij trasę'**
  String get route_start_route;

  /// No description provided for @route_change_status.
  ///
  /// In pl, this message translates to:
  /// **'Zmień status'**
  String get route_change_status;

  /// No description provided for @route_status_changed_prefix.
  ///
  /// In pl, this message translates to:
  /// **'Status zmieniony na:'**
  String get route_status_changed_prefix;

  /// No description provided for @route_status_change_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zmienić statusu'**
  String get route_status_change_failed;

  /// No description provided for @common_back.
  ///
  /// In pl, this message translates to:
  /// **'Wstecz'**
  String get common_back;

  /// No description provided for @route_center_on_my_location.
  ///
  /// In pl, this message translates to:
  /// **'Wycentruj na mojej lokalizacji'**
  String get route_center_on_my_location;

  /// No description provided for @route_rerouting.
  ///
  /// In pl, this message translates to:
  /// **'Przeliczam trasę...'**
  String get route_rerouting;

  /// No description provided for @route_report_problem.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś Problem'**
  String get route_report_problem;

  /// No description provided for @route_report_problem_sheet_title.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś problem'**
  String get route_report_problem_sheet_title;

  /// No description provided for @route_report_problem_description_label.
  ///
  /// In pl, this message translates to:
  /// **'Opis problemu'**
  String get route_report_problem_description_label;

  /// No description provided for @route_report_problem_description_hint.
  ///
  /// In pl, this message translates to:
  /// **'Opisz'**
  String get route_report_problem_description_hint;

  /// No description provided for @route_report_problem_submit.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj zgłoszenie'**
  String get route_report_problem_submit;

  /// No description provided for @route_report_problem_success.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoszono problem'**
  String get route_report_problem_success;

  /// No description provided for @route_report_problem_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zgłosić problemu'**
  String get route_report_problem_failed;

  /// No description provided for @route_controls_title.
  ///
  /// In pl, this message translates to:
  /// **'Sterowanie'**
  String get route_controls_title;

  /// No description provided for @route_controls_report_event.
  ///
  /// In pl, this message translates to:
  /// **'Zgłoś zdarzenie'**
  String get route_controls_report_event;

  /// No description provided for @route_controls_pause.
  ///
  /// In pl, this message translates to:
  /// **'Pauza'**
  String get route_controls_pause;

  /// No description provided for @route_controls_resume.
  ///
  /// In pl, this message translates to:
  /// **'Wznów'**
  String get route_controls_resume;

  /// No description provided for @route_controls_finish_route.
  ///
  /// In pl, this message translates to:
  /// **'Zakończ trasę'**
  String get route_controls_finish_route;

  /// No description provided for @route_status_change_title.
  ///
  /// In pl, this message translates to:
  /// **'Zmiana statusu'**
  String get route_status_change_title;

  /// No description provided for @route_status_in_progress_label.
  ///
  /// In pl, this message translates to:
  /// **'W realizacji'**
  String get route_status_in_progress_label;

  /// No description provided for @common_minutes_short.
  ///
  /// In pl, this message translates to:
  /// **'min'**
  String get common_minutes_short;

  /// No description provided for @route_order_number_prefix.
  ///
  /// In pl, this message translates to:
  /// **'Zlecenie #'**
  String get route_order_number_prefix;

  /// No description provided for @route_fetch_route.
  ///
  /// In pl, this message translates to:
  /// **'Oblicz trasę'**
  String get route_fetch_route;

  /// No description provided for @route_fetching_route.
  ///
  /// In pl, this message translates to:
  /// **'Obliczanie trasy...'**
  String get route_fetching_route;

  /// No description provided for @route_total_distance_label.
  ///
  /// In pl, this message translates to:
  /// **'Łącznie'**
  String get route_total_distance_label;

  /// No description provided for @route_my_location.
  ///
  /// In pl, this message translates to:
  /// **'Moja lokalizacja'**
  String get route_my_location;

  /// No description provided for @route_no_order_map_title.
  ///
  /// In pl, this message translates to:
  /// **'Brak aktywnego zlecenia'**
  String get route_no_order_map_title;

  /// No description provided for @route_no_order_map_description.
  ///
  /// In pl, this message translates to:
  /// **'Dyspozytor nie przypisał jeszcze zlecenia.'**
  String get route_no_order_map_description;

  /// No description provided for @route_arrival_title.
  ///
  /// In pl, this message translates to:
  /// **'Punkt {index} z {total}'**
  String route_arrival_title(int index, int total);

  /// No description provided for @route_confirm_arrival.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź dotarcie'**
  String get route_confirm_arrival;

  /// No description provided for @route_drive_to_point.
  ///
  /// In pl, this message translates to:
  /// **'Jedź do punktu {index} z {total}'**
  String route_drive_to_point(int index, int total);

  /// No description provided for @route_arrival_confirmation_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się wysłać potwierdzenia'**
  String get route_arrival_confirmation_failed;

  /// No description provided for @order_route_progress_title.
  ///
  /// In pl, this message translates to:
  /// **'Postęp trasy'**
  String get order_route_progress_title;

  /// No description provided for @order_route_point_arrived_at.
  ///
  /// In pl, this message translates to:
  /// **'Dotarcie: {time}'**
  String order_route_point_arrived_at(String time);

  /// No description provided for @order_route_point_next.
  ///
  /// In pl, this message translates to:
  /// **'Następny cel'**
  String get order_route_point_next;

  /// No description provided for @route_manual_route_banner.
  ///
  /// In pl, this message translates to:
  /// **'Trasa orientacyjna – linia prosta między punktami'**
  String get route_manual_route_banner;

  /// No description provided for @order_unassign_button.
  ///
  /// In pl, this message translates to:
  /// **'Odepnij zlecenie'**
  String get order_unassign_button;

  /// No description provided for @order_unassign_confirm_title.
  ///
  /// In pl, this message translates to:
  /// **'Odepnij zlecenie?'**
  String get order_unassign_confirm_title;

  /// No description provided for @order_unassign_confirm_description.
  ///
  /// In pl, this message translates to:
  /// **'Zlecenie wróci do puli nieprzypisanych. Dyspozytor będzie musiał przypisać je ponownie.'**
  String get order_unassign_confirm_description;

  /// No description provided for @order_unassign_confirm_action.
  ///
  /// In pl, this message translates to:
  /// **'Odepnij'**
  String get order_unassign_confirm_action;

  /// No description provided for @order_unassign_cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get order_unassign_cancel;

  /// No description provided for @order_unassign_success.
  ///
  /// In pl, this message translates to:
  /// **'Zlecenie zostało odpięte'**
  String get order_unassign_success;

  /// No description provided for @order_unassign_failed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się odpiąć zlecenia'**
  String get order_unassign_failed;
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
