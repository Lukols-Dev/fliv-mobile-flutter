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
  String get auth_login_title => 'Logowanie';

  @override
  String get auth_email_label => 'Adres email';

  @override
  String get auth_email_hint => 'email@example.com';

  @override
  String get auth_password_label => 'Hasło';

  @override
  String get auth_forgot_password => 'Zapomniałeś hasła?';

  @override
  String get auth_terms_text =>
      'Logując się, akceptujesz regulamin serwisu oraz politykę prywatności';

  @override
  String get auth_register_title => 'Utwórz nowe konto aby rozpocząć';

  @override
  String get auth_first_name_label => 'Imię';

  @override
  String get auth_first_name_hint => 'Imię';

  @override
  String get auth_last_name_label => 'Nazwisko';

  @override
  String get auth_last_name_hint => 'Nazwisko';

  @override
  String get auth_company_id_label => 'Id Firmy';

  @override
  String get auth_company_id_hint => 'Id Firmy';

  @override
  String get auth_already_have_account => 'Masz już konto? Zaloguj się';

  @override
  String get auth_forgot_password_title => 'Zapomniałeś hasła?';

  @override
  String get auth_forgot_password_description =>
      'Nie martw się! To się zdarza. Wpisz adres e-mail powiązany z Twoim kontem.';

  @override
  String get auth_send_link => 'Wyślij link';

  @override
  String get auth_invalid_email => 'Nieprawidłowy adres email';

  @override
  String get auth_login_failed => 'Nieprawidłowy email lub hasło';

  @override
  String get auth_register_failed => 'Nie udało się utworzyć konta';

  @override
  String get common_or => 'lub';

  @override
  String get common_fill_all_fields => 'Wypełnij wszystkie pola';

  @override
  String get language_pl => 'Polski';

  @override
  String get language_en => 'English';

  @override
  String get profile_user_profile => 'Profil użytkownika';

  @override
  String get profile_your_data => 'Twoje dane';

  @override
  String get profile_driver_data => 'Dane kierowcy';

  @override
  String get profile_app_settings => 'Ustawienia aplikacji';

  @override
  String get profile_location => 'Lokalizacja';

  @override
  String get profile_language => 'Język polski';

  @override
  String get profile_about_app => 'O aplikacji';

  @override
  String get profile_terms => 'Regulamin';

  @override
  String get profile_privacy_policy => 'Polityka prywatności';

  @override
  String get profile_logout => 'Wyloguj się';

  @override
  String get profile_phone_label => 'Telefon';

  @override
  String get profile_save_failed => 'Nie udało się zapisać danych';

  @override
  String get common_save => 'Zapisz';

  @override
  String get driver_data_visa_deadline => 'Termin wizy';

  @override
  String get driver_data_license_deadline => 'Termin prawa jazdy';

  @override
  String get driver_data_work_permit_deadline => 'Termin pozwolenia na pracę';

  @override
  String get driver_data_medical_exam_deadline => 'Termin badania lekarskiego';

  @override
  String get driver_data_psychological_exam_deadline =>
      'Termin badania psychologicznego';

  @override
  String get driver_data_driver_card_deadline => 'Termin karty kierowcy';

  @override
  String get driver_data_residence_card_deadline => 'Termin karty pobytu';

  @override
  String get driver_data_driver_certificate_deadline =>
      'Termin świadectwa kierowcy';

  @override
  String get driver_data_invalid_date => 'Nieprawidłowa data';

  @override
  String get driver_data_save_failed => 'Nie udało się zapisać danych';

  @override
  String get order_details_title => 'Szczegóły zlecenia';

  @override
  String get order_status_in_transit => 'W trasie';

  @override
  String get order_client_data => 'Dane klienta';

  @override
  String get order_contact_person => 'Osoba kontaktowa';

  @override
  String get order_phone => 'Telefon';

  @override
  String get order_transport_route => 'Trasa transportu';

  @override
  String get order_loading_point => 'Punkt załadunku';

  @override
  String get order_unloading_point => 'Punkt rozładunku';

  @override
  String get order_loaded => 'Załadowano';

  @override
  String get order_en_route => 'W drodze';

  @override
  String get order_cargo => 'Ładunek';

  @override
  String get order_cargo_type => 'Rodzaj towaru';

  @override
  String get order_weight => 'Waga';

  @override
  String get order_pallets => 'Palety';

  @override
  String get order_notes => 'Uwagi';

  @override
  String get order_start_navigation => 'Rozpocznij nawigację';

  @override
  String get order_view_documents => 'Zobacz dokumenty';

  @override
  String get order_eta => 'ETA';

  @override
  String get documents_title => 'Dokumenty';

  @override
  String get documents_filter_all => 'Wszystkie';

  @override
  String get documents_filter_synchronized => 'Zsynchronizowane';

  @override
  String get documents_filter_local => 'Lokalne';

  @override
  String get documents_status_synchronized => 'Zsynchronizowano';

  @override
  String get documents_status_local_only => 'Tylko lokalnie';

  @override
  String get documents_status_syncing => 'Synchronizacja...';

  @override
  String get documents_add_title => 'Dodaj dokument';

  @override
  String get documents_add_subtitle => 'Wypełnij informacje o nowym dokumencie';

  @override
  String get documents_add_photo_label => 'Zdjęcie dokumentu';

  @override
  String get documents_add_photo_hint => 'Zrób zdjęcie lub wybierz z galerii';

  @override
  String get documents_add_photo_max_size => 'Maksymalny rozmiar: 10 MB';

  @override
  String get documents_add_name_label => 'Nazwa dokumentu';

  @override
  String get documents_add_name_hint => 'np. CMR - List przewozowy';

  @override
  String get documents_add_button => 'Dodaj dokument';

  @override
  String get route_report_event_title => 'Zgłoś';

  @override
  String get route_report_event_detour => 'Objazd';

  @override
  String get route_report_event_accident => 'Wypadek';

  @override
  String get route_report_event_delay => 'Opóźnienie';

  @override
  String get common_close => 'Zamknij';

  @override
  String get route_report_success => 'Zgłoszono zdarzenie';

  @override
  String get route_report_error => 'Nie udało się zgłosić zdarzenia';

  @override
  String get home_welcome_back => 'Witaj z powrotem!';

  @override
  String get order_status_in_progress => 'W trasie';

  @override
  String get order_status_loading => 'Załadunek';

  @override
  String get order_status_unloading => 'Rozładunek';

  @override
  String get order_status_paused => 'Pauza';

  @override
  String get order_status_completed => 'Zakończone';

  @override
  String get order_status_problem => 'Problem';

  @override
  String get order_status_pending => 'Oczekuje';

  @override
  String get order_status_accepted => 'Zaakceptowane';

  @override
  String get common_id_label => 'ID';

  @override
  String get common_location => 'Lokalizacja';

  @override
  String get common_yes => 'Tak';

  @override
  String get common_no => 'Nie';

  @override
  String get common_kg_short => 'kg';

  @override
  String get common_email => 'Email';

  @override
  String get home_current_location_title => 'Obecna lokalizacja';

  @override
  String get home_location_fetching => 'Pobieranie lokalizacji…';

  @override
  String get home_location_tap_refresh => 'Kliknij odśwież, aby pobrać';

  @override
  String get home_location_resolving_address => 'Ustalanie adresu…';

  @override
  String get home_location_address_not_found => 'Nie udało się ustalić adresu';

  @override
  String get home_location_fetch_failed => 'Nie udało się pobrać';

  @override
  String get home_refresh_location_tooltip => 'Odśwież lokalizację';

  @override
  String get home_current_order_title => 'Aktualne Zlecenie';

  @override
  String get home_enter_zt_number => 'Podaj numer ZT.';

  @override
  String get home_order_assigned => 'Zlecenie przypisane.';

  @override
  String get home_assign_order_failed => 'Nie udało się przypisać zlecenia';

  @override
  String get home_no_assigned_order_title => 'Brak przypisanego zlecenia';

  @override
  String get home_no_assigned_order_description =>
      'Aby przypisać zlecenie, wpisz numer ZT otrzymany od dyspozytora.';

  @override
  String get home_zt_hint => 'np. ZT-123456';

  @override
  String get home_assign_order_button => 'Przypisz zlecenie';

  @override
  String get home_order_number_label => 'Numer zlecenia';

  @override
  String get home_open_navigation => 'Otwórz nawigację';

  @override
  String get order_missing_id => 'Brak ID zlecenia';

  @override
  String get order_fetch_failed => 'Błąd pobierania zlecenia';

  @override
  String get order_company_name_label => 'Nazwa firmy';

  @override
  String get order_temperature_sensitive_label => 'Wrażliwość na temperaturę';

  @override
  String get documents_offline_message =>
      'Offline: możesz dodawać dokumenty lokalnie i synchronizować później.';

  @override
  String get documents_no_assigned_zt_title => 'Brak przypisanego ZT';

  @override
  String get documents_no_assigned_zt_description =>
      'Aby dodać dokument, najpierw przypisz zlecenie (ZT).';

  @override
  String get documents_default_title => 'Dokument';

  @override
  String get documents_empty_list =>
      'Brak dokumentów. Dodaj pierwszy dokument.';

  @override
  String get documents_delete_document_title => 'Usuń dokument';

  @override
  String get common_cancel => 'Anuluj';

  @override
  String get common_delete => 'Usuń';

  @override
  String get documents_delete_local_confirm =>
      'Usunąć dokument lokalnie z telefonu?';

  @override
  String get documents_delete_remote_confirm => 'Usunąć dokument z serwera?';

  @override
  String get documents_offline_error =>
      'Jesteś offline. Możesz dodawać dokumenty lokalnie i zsynchronizować później.';

  @override
  String get documents_fetch_failed =>
      'Nie udało się pobrać dokumentów z serwera.';

  @override
  String get documents_sync_action => 'Synchronizuj';

  @override
  String get documents_status_failed => 'Błąd synchronizacji';

  @override
  String get documents_options_tooltip => 'Opcje';

  @override
  String get documents_preview_load_failed =>
      'Nie udało się załadować podglądu.';

  @override
  String get route_navigation_title => 'Nawigacja';

  @override
  String get route_no_order_title => 'Brak przypisanego aktualnie zlecenia.';

  @override
  String get route_no_order_description =>
      'Gdy dyspozytor przypisze zlecenie, tutaj pojawi się trasa oraz przycisk rozpoczęcia.';

  @override
  String get route_distance_label => 'Dystans';

  @override
  String get route_time_label => 'Czas';

  @override
  String get route_route_not_calculated => 'Trasa: jeszcze nie wyznaczona.';

  @override
  String get route_calculate_route => 'Wyznacz trasę';

  @override
  String get route_stop => 'Zatrzymaj';

  @override
  String get route_start_route => 'Rozpocznij trasę';

  @override
  String get route_change_status => 'Zmień status';

  @override
  String get route_status_changed_prefix => 'Status zmieniony na:';

  @override
  String get route_status_change_failed => 'Nie udało się zmienić statusu';

  @override
  String get common_back => 'Wstecz';

  @override
  String get route_center_on_my_location => 'Wycentruj na mojej lokalizacji';

  @override
  String get route_report_problem => 'Zgłoś Problem';

  @override
  String get route_report_problem_sheet_title => 'Zgłoś problem';

  @override
  String get route_report_problem_description_label => 'Opis problemu';

  @override
  String get route_report_problem_description_hint => 'Opisz';

  @override
  String get route_report_problem_submit => 'Dodaj zgłoszenie';

  @override
  String get route_report_problem_success => 'Zgłoszono problem';

  @override
  String get route_report_problem_failed => 'Nie udało się zgłosić problemu';

  @override
  String get route_controls_title => 'Sterowanie';

  @override
  String get route_controls_report_event => 'Zgłoś zdarzenie';

  @override
  String get route_controls_pause => 'Pauza';

  @override
  String get route_controls_resume => 'Wznów';

  @override
  String get route_controls_finish_route => 'Zakończ trasę';

  @override
  String get route_status_change_title => 'Zmiana statusu';

  @override
  String get route_status_in_progress_label => 'W realizacji';

  @override
  String get common_minutes_short => 'min';

  @override
  String get route_order_number_prefix => 'Zlecenie #';
}
