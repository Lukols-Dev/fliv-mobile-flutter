// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get auth_start_title =>
      'Ваш логистический партнёр, обеспечивающий бесперебойную доставку.';

  @override
  String get auth_start_subtitle =>
      'Наши логистические услуги предоставляют комплексные решения для перевозок.';

  @override
  String get auth_login => 'Войти';

  @override
  String get auth_register => 'Создать аккаунт';

  @override
  String get auth_login_title => 'Вход';

  @override
  String get auth_email_label => 'Адрес электронной почты';

  @override
  String get auth_email_hint => 'email@example.com';

  @override
  String get auth_password_label => 'Пароль';

  @override
  String get auth_forgot_password => 'Забыли пароль?';

  @override
  String get auth_terms_text =>
      'Входя в систему, вы принимаете условия обслуживания и политику конфиденциальности';

  @override
  String get auth_register_title => 'Создайте новый аккаунт, чтобы начать';

  @override
  String get auth_first_name_label => 'Имя';

  @override
  String get auth_first_name_hint => 'Имя';

  @override
  String get auth_last_name_label => 'Фамилия';

  @override
  String get auth_last_name_hint => 'Фамилия';

  @override
  String get auth_company_id_label => 'ID компании';

  @override
  String get auth_company_id_hint => 'ID компании';

  @override
  String get auth_already_have_account => 'Уже есть аккаунт? Войти';

  @override
  String get auth_forgot_password_title => 'Забыли пароль?';

  @override
  String get auth_forgot_password_description =>
      'Не переживайте! Такое бывает. Введите адрес электронной почты, связанный с вашим аккаунтом.';

  @override
  String get auth_send_link => 'Отправить ссылку';

  @override
  String get auth_invalid_email => 'Некорректный адрес электронной почты';

  @override
  String get auth_login_failed => 'Неверный email или пароль';

  @override
  String get auth_register_failed => 'Не удалось создать аккаунт';

  @override
  String get auth_register_success_pending_activation =>
      'Аккаунт создан. Войдите после активации аккаунта администратором.';

  @override
  String get common_or => 'или';

  @override
  String get common_fill_all_fields => 'Заполните все поля';

  @override
  String get language_pl => 'Польский';

  @override
  String get language_en => 'Английский';

  @override
  String get profile_user_profile => 'Профиль пользователя';

  @override
  String get profile_your_data => 'Ваши данные';

  @override
  String get profile_driver_data => 'Данные водителя';

  @override
  String get profile_app_settings => 'Настройки приложения';

  @override
  String get profile_location => 'Местоположение';

  @override
  String get profile_language => 'Польский язык';

  @override
  String get profile_about_app => 'О приложении';

  @override
  String get profile_terms => 'Условия и положения';

  @override
  String get profile_privacy_policy => 'Политика конфиденциальности';

  @override
  String get profile_logout => 'Выйти';

  @override
  String get profile_phone_label => 'Телефон';

  @override
  String get profile_save_failed => 'Не удалось сохранить данные';

  @override
  String get common_save => 'Сохранить';

  @override
  String get driver_data_visa_deadline => 'Срок действия визы';

  @override
  String get driver_data_license_deadline =>
      'Срок действия водительского удостоверения';

  @override
  String get driver_data_work_permit_deadline =>
      'Срок действия разрешения на работу';

  @override
  String get driver_data_medical_exam_deadline => 'Срок действия медосмотра';

  @override
  String get driver_data_psychological_exam_deadline =>
      'Срок действия психологического освидетельствования';

  @override
  String get driver_data_driver_card_deadline => 'Срок действия карты водителя';

  @override
  String get driver_data_residence_card_deadline =>
      'Срок действия карты побыта';

  @override
  String get driver_data_driver_certificate_deadline =>
      'Срок действия сертификата водителя';

  @override
  String get driver_data_invalid_date => 'Некорректная дата';

  @override
  String get driver_data_save_failed => 'Не удалось сохранить данные';

  @override
  String get order_details_title => 'Детали заказа';

  @override
  String get order_status_in_transit => 'В пути';

  @override
  String get order_client_data => 'Данные клиента';

  @override
  String get order_contact_person => 'Контактное лицо';

  @override
  String get order_phone => 'Телефон';

  @override
  String get order_transport_route => 'Маршрут перевозки';

  @override
  String get order_loading_point => 'Пункт погрузки';

  @override
  String get order_unloading_point => 'Пункт разгрузки';

  @override
  String get order_loaded => 'Погружено';

  @override
  String get order_en_route => 'В пути';

  @override
  String get order_cargo => 'Груз';

  @override
  String get order_cargo_type => 'Тип груза';

  @override
  String get order_weight => 'Вес';

  @override
  String get order_pallets => 'Паллеты';

  @override
  String get order_notes => 'Примечания';

  @override
  String get order_start_navigation => 'Начать навигацию';

  @override
  String get order_view_documents => 'Просмотреть документы';

  @override
  String get order_eta => 'Ожидаемое время прибытия';

  @override
  String get documents_title => 'Документы';

  @override
  String get documents_filter_all => 'Все';

  @override
  String get documents_filter_synchronized => 'Синхронизированные';

  @override
  String get documents_filter_local => 'Локальные';

  @override
  String get documents_status_synchronized => 'Синхронизировано';

  @override
  String get documents_status_local_only => 'Только локально';

  @override
  String get documents_status_syncing => 'Синхронизация...';

  @override
  String get documents_add_title => 'Добавить документ';

  @override
  String get documents_add_subtitle => 'Заполните информацию о новом документе';

  @override
  String get documents_add_photo_label => 'Фото документа';

  @override
  String get documents_add_photo_hint =>
      'Сделайте фото или выберите из галереи';

  @override
  String get documents_add_photo_max_size => 'Максимальный размер: 10 МБ';

  @override
  String get documents_add_name_label => 'Название документа';

  @override
  String get documents_add_name_hint =>
      'например, CMR — транспортная накладная';

  @override
  String get documents_add_button => 'Добавить документ';

  @override
  String get route_report_event_title => 'Сообщить';

  @override
  String get route_report_event_detour => 'Объезд';

  @override
  String get route_report_event_accident => 'Авария';

  @override
  String get route_report_event_delay => 'Задержка';

  @override
  String get common_close => 'Закрыть';

  @override
  String get route_report_success => 'Событие отправлено';

  @override
  String get route_report_error => 'Не удалось отправить событие';

  @override
  String get home_welcome_back => 'С возвращением!';

  @override
  String get order_status_in_progress => 'В пути';

  @override
  String get order_status_loading => 'Погрузка';

  @override
  String get order_status_unloading => 'Разгрузка';

  @override
  String get order_status_paused => 'Пауза';

  @override
  String get order_status_completed => 'Завершено';

  @override
  String get order_status_problem => 'Проблема';

  @override
  String get order_status_pending => 'Ожидает';

  @override
  String get order_status_accepted => 'Принято';

  @override
  String get common_id_label => 'ID';

  @override
  String get common_location => 'Местоположение';

  @override
  String get common_yes => 'Да';

  @override
  String get common_no => 'Нет';

  @override
  String get common_kg_short => 'кг';

  @override
  String get common_email => 'Email';

  @override
  String get home_current_location_title => 'Текущее местоположение';

  @override
  String get home_location_fetching => 'Получение местоположения…';

  @override
  String get home_location_tap_refresh => 'Нажмите обновить, чтобы получить';

  @override
  String get home_location_resolving_address => 'Определение адреса…';

  @override
  String get home_location_address_not_found => 'Не удалось определить адрес';

  @override
  String get home_location_fetch_failed => 'Не удалось получить';

  @override
  String get home_refresh_location_tooltip => 'Обновить местоположение';

  @override
  String get home_current_order_title => 'Текущий заказ';

  @override
  String get home_enter_zt_number => 'Введите номер ZT.';

  @override
  String get home_order_assigned => 'Заказ назначен.';

  @override
  String get home_assign_order_failed => 'Не удалось назначить заказ';

  @override
  String get home_no_assigned_order_title => 'Нет назначенного заказа';

  @override
  String get home_no_assigned_order_description =>
      'Чтобы назначить заказ, введите номер ZT, полученный от диспетчера.';

  @override
  String get home_zt_hint => 'например, ZT-123456';

  @override
  String get home_assign_order_button => 'Назначить заказ';

  @override
  String get home_order_number_label => 'Номер заказа';

  @override
  String get home_open_navigation => 'Открыть навигацию';

  @override
  String get order_missing_id => 'Нет ID заказа';

  @override
  String get order_fetch_failed => 'Ошибка загрузки заказа';

  @override
  String get order_company_name_label => 'Название компании';

  @override
  String get order_temperature_sensitive_label =>
      'Чувствительность к температуре';

  @override
  String get documents_offline_message =>
      'Офлайн: вы можете добавлять документы локально и синхронизировать позже.';

  @override
  String get documents_no_assigned_zt_title => 'Нет назначенного ZT';

  @override
  String get documents_no_assigned_zt_description =>
      'Чтобы добавить документ, сначала назначьте заказ (ZT).';

  @override
  String get documents_default_title => 'Документ';

  @override
  String get documents_empty_list =>
      'Нет документов. Добавьте первый документ.';

  @override
  String get documents_delete_document_title => 'Удалить документ';

  @override
  String get common_cancel => 'Отмена';

  @override
  String get common_delete => 'Удалить';

  @override
  String get documents_delete_local_confirm =>
      'Удалить документ локально с телефона?';

  @override
  String get documents_delete_remote_confirm => 'Удалить документ с сервера?';

  @override
  String get documents_offline_error =>
      'Вы в офлайне. Вы можете добавлять документы локально и синхронизировать позже.';

  @override
  String get documents_fetch_failed =>
      'Не удалось загрузить документы с сервера.';

  @override
  String get documents_sync_action => 'Синхронизировать';

  @override
  String get documents_status_failed => 'Ошибка синхронизации';

  @override
  String get documents_options_tooltip => 'Опции';

  @override
  String get documents_preview_load_failed =>
      'Не удалось загрузить предпросмотр.';

  @override
  String get route_navigation_title => 'Навигация';

  @override
  String get route_no_order_title => 'Нет назначенного заказа.';

  @override
  String get route_no_order_description =>
      'Когда диспетчер назначит заказ, здесь появится маршрут и кнопка запуска.';

  @override
  String get route_distance_label => 'Расстояние';

  @override
  String get route_time_label => 'Время';

  @override
  String get route_eta_arrival => 'Прибытие';

  @override
  String get route_route_not_calculated => 'Маршрут: еще не рассчитан.';

  @override
  String get route_no_configured_route => 'Маршрут не настроен.';

  @override
  String get route_loading_route => 'Загрузка маршрута...';

  @override
  String get route_route_error => 'Не удалось загрузить или рассчитать маршрут';

  @override
  String get route_next_point => 'Следующая точка';

  @override
  String get route_next_instruction_label => 'Следующий маневр';

  @override
  String get route_calculate_route => 'Рассчитать маршрут';

  @override
  String get route_calculate_approach => 'Рассчитать подъезд';

  @override
  String get route_approach_label => 'Подъезд к старту';

  @override
  String get route_stop => 'Остановить';

  @override
  String get route_start_route => 'Начать маршрут';

  @override
  String get route_change_status => 'Изменить статус';

  @override
  String get route_status_changed_prefix => 'Статус изменен на:';

  @override
  String get route_status_change_failed => 'Не удалось изменить статус';

  @override
  String get common_back => 'Назад';

  @override
  String get route_center_on_my_location =>
      'Центрировать на моем местоположении';

  @override
  String get route_rerouting => 'Пересчёт маршрута...';

  @override
  String get route_report_problem => 'Сообщить о проблеме';

  @override
  String get route_report_problem_sheet_title => 'Сообщить о проблеме';

  @override
  String get route_report_problem_description_label => 'Описание проблемы';

  @override
  String get route_report_problem_description_hint => 'Опишите';

  @override
  String get route_report_problem_submit => 'Добавить сообщение';

  @override
  String get route_report_problem_success => 'Проблема отправлена';

  @override
  String get route_report_problem_failed => 'Не удалось отправить проблему';

  @override
  String get route_controls_title => 'Управление';

  @override
  String get route_controls_report_event => 'Сообщить о событии';

  @override
  String get route_controls_pause => 'Пауза';

  @override
  String get route_controls_resume => 'Возобновить';

  @override
  String get route_controls_finish_route => 'Завершить маршрут';

  @override
  String get route_status_change_title => 'Изменение статуса';

  @override
  String get route_status_in_progress_label => 'В процессе';

  @override
  String get common_minutes_short => 'мин';

  @override
  String get route_order_number_prefix => 'Заказ #';

  @override
  String get route_fetch_route => 'Рассчитать маршрут';

  @override
  String get route_fetching_route => 'Расчёт маршрута...';

  @override
  String get route_total_distance_label => 'Всего';

  @override
  String get route_my_location => 'Моя локализация';

  @override
  String get route_no_order_map_title => 'Нет активного заказа';

  @override
  String get route_no_order_map_description =>
      'Диспетчер ещё не назначил заказ.';

  @override
  String route_arrival_title(int index, int total) {
    return 'Точка $index из $total';
  }

  @override
  String get route_confirm_arrival => 'Подтвердить прибытие';

  @override
  String route_drive_to_point(int index, int total) {
    return 'Ехать к точке $index из $total';
  }

  @override
  String get route_arrival_confirmation_failed =>
      'Не удалось отправить подтверждение';

  @override
  String get order_route_progress_title => 'Прогресс маршрута';

  @override
  String order_route_point_arrived_at(String time) {
    return 'Прибытие: $time';
  }

  @override
  String get order_route_point_next => 'Следующая цель';

  @override
  String get route_manual_route_banner =>
      'Ориентировочный маршрут – прямая линия между точками';

  @override
  String get order_unassign_button => 'Отвязать заказ';

  @override
  String get order_unassign_confirm_title => 'Отвязать заказ?';

  @override
  String get order_unassign_confirm_description =>
      'Заказ вернётся в пул неназначенных. Диспетчеру потребуется назначить его снова.';

  @override
  String get order_unassign_confirm_action => 'Отвязать';

  @override
  String get order_unassign_cancel => 'Отмена';

  @override
  String get order_unassign_success => 'Заказ успешно отвязан';

  @override
  String get order_unassign_failed => 'Не удалось отвязать заказ';
}
