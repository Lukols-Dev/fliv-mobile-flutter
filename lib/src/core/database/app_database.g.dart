// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DriverProfileTableTable extends DriverProfileTable
    with TableInfo<$DriverProfileTableTable, DriverProfileTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriverProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyInternalIdMeta = const VerificationMeta(
    'companyInternalId',
  );
  @override
  late final GeneratedColumn<String> companyInternalId =
      GeneratedColumn<String>(
        'company_internal_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _driverCodeMeta = const VerificationMeta(
    'driverCode',
  );
  @override
  late final GeneratedColumn<String> driverCode = GeneratedColumn<String>(
    'driver_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _medicalExamExpiryMeta = const VerificationMeta(
    'medicalExamExpiry',
  );
  @override
  late final GeneratedColumn<DateTime> medicalExamExpiry =
      GeneratedColumn<DateTime>(
        'medical_exam_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _psychologicalExamExpiryMeta =
      const VerificationMeta('psychologicalExamExpiry');
  @override
  late final GeneratedColumn<DateTime> psychologicalExamExpiry =
      GeneratedColumn<DateTime>(
        'psychological_exam_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tachographCardExpiryMeta =
      const VerificationMeta('tachographCardExpiry');
  @override
  late final GeneratedColumn<DateTime> tachographCardExpiry =
      GeneratedColumn<DateTime>(
        'tachograph_card_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _licenseExpiryMeta = const VerificationMeta(
    'licenseExpiry',
  );
  @override
  late final GeneratedColumn<DateTime> licenseExpiry =
      GeneratedColumn<DateTime>(
        'license_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _visaExpiryMeta = const VerificationMeta(
    'visaExpiry',
  );
  @override
  late final GeneratedColumn<DateTime> visaExpiry = GeneratedColumn<DateTime>(
    'visa_expiry',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workPermitExpiryMeta = const VerificationMeta(
    'workPermitExpiry',
  );
  @override
  late final GeneratedColumn<DateTime> workPermitExpiry =
      GeneratedColumn<DateTime>(
        'work_permit_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _residenceCardExpiryMeta =
      const VerificationMeta('residenceCardExpiry');
  @override
  late final GeneratedColumn<DateTime> residenceCardExpiry =
      GeneratedColumn<DateTime>(
        'residence_card_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _driverCertificateExpiryMeta =
      const VerificationMeta('driverCertificateExpiry');
  @override
  late final GeneratedColumn<DateTime> driverCertificateExpiry =
      GeneratedColumn<DateTime>(
        'driver_certificate_expiry',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    firstName,
    lastName,
    email,
    phone,
    companyInternalId,
    driverCode,
    updatedAt,
    medicalExamExpiry,
    psychologicalExamExpiry,
    tachographCardExpiry,
    licenseExpiry,
    visaExpiry,
    workPermitExpiry,
    residenceCardExpiry,
    driverCertificateExpiry,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'driver_profile_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriverProfileTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('company_internal_id')) {
      context.handle(
        _companyInternalIdMeta,
        companyInternalId.isAcceptableOrUnknown(
          data['company_internal_id']!,
          _companyInternalIdMeta,
        ),
      );
    }
    if (data.containsKey('driver_code')) {
      context.handle(
        _driverCodeMeta,
        driverCode.isAcceptableOrUnknown(data['driver_code']!, _driverCodeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('medical_exam_expiry')) {
      context.handle(
        _medicalExamExpiryMeta,
        medicalExamExpiry.isAcceptableOrUnknown(
          data['medical_exam_expiry']!,
          _medicalExamExpiryMeta,
        ),
      );
    }
    if (data.containsKey('psychological_exam_expiry')) {
      context.handle(
        _psychologicalExamExpiryMeta,
        psychologicalExamExpiry.isAcceptableOrUnknown(
          data['psychological_exam_expiry']!,
          _psychologicalExamExpiryMeta,
        ),
      );
    }
    if (data.containsKey('tachograph_card_expiry')) {
      context.handle(
        _tachographCardExpiryMeta,
        tachographCardExpiry.isAcceptableOrUnknown(
          data['tachograph_card_expiry']!,
          _tachographCardExpiryMeta,
        ),
      );
    }
    if (data.containsKey('license_expiry')) {
      context.handle(
        _licenseExpiryMeta,
        licenseExpiry.isAcceptableOrUnknown(
          data['license_expiry']!,
          _licenseExpiryMeta,
        ),
      );
    }
    if (data.containsKey('visa_expiry')) {
      context.handle(
        _visaExpiryMeta,
        visaExpiry.isAcceptableOrUnknown(data['visa_expiry']!, _visaExpiryMeta),
      );
    }
    if (data.containsKey('work_permit_expiry')) {
      context.handle(
        _workPermitExpiryMeta,
        workPermitExpiry.isAcceptableOrUnknown(
          data['work_permit_expiry']!,
          _workPermitExpiryMeta,
        ),
      );
    }
    if (data.containsKey('residence_card_expiry')) {
      context.handle(
        _residenceCardExpiryMeta,
        residenceCardExpiry.isAcceptableOrUnknown(
          data['residence_card_expiry']!,
          _residenceCardExpiryMeta,
        ),
      );
    }
    if (data.containsKey('driver_certificate_expiry')) {
      context.handle(
        _driverCertificateExpiryMeta,
        driverCertificateExpiry.isAcceptableOrUnknown(
          data['driver_certificate_expiry']!,
          _driverCertificateExpiryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DriverProfileTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriverProfileTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      companyInternalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_internal_id'],
      ),
      driverCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}driver_code'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      medicalExamExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}medical_exam_expiry'],
      ),
      psychologicalExamExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}psychological_exam_expiry'],
      ),
      tachographCardExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tachograph_card_expiry'],
      ),
      licenseExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}license_expiry'],
      ),
      visaExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}visa_expiry'],
      ),
      workPermitExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}work_permit_expiry'],
      ),
      residenceCardExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}residence_card_expiry'],
      ),
      driverCertificateExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}driver_certificate_expiry'],
      ),
    );
  }

  @override
  $DriverProfileTableTable createAlias(String alias) {
    return $DriverProfileTableTable(attachedDatabase, alias);
  }
}

class DriverProfileTableData extends DataClass
    implements Insertable<DriverProfileTableData> {
  final String key;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? companyInternalId;
  final String? driverCode;
  final DateTime updatedAt;
  final DateTime? medicalExamExpiry;
  final DateTime? psychologicalExamExpiry;
  final DateTime? tachographCardExpiry;
  final DateTime? licenseExpiry;
  final DateTime? visaExpiry;
  final DateTime? workPermitExpiry;
  final DateTime? residenceCardExpiry;
  final DateTime? driverCertificateExpiry;
  const DriverProfileTableData({
    required this.key,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.companyInternalId,
    this.driverCode,
    required this.updatedAt,
    this.medicalExamExpiry,
    this.psychologicalExamExpiry,
    this.tachographCardExpiry,
    this.licenseExpiry,
    this.visaExpiry,
    this.workPermitExpiry,
    this.residenceCardExpiry,
    this.driverCertificateExpiry,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || companyInternalId != null) {
      map['company_internal_id'] = Variable<String>(companyInternalId);
    }
    if (!nullToAbsent || driverCode != null) {
      map['driver_code'] = Variable<String>(driverCode);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || medicalExamExpiry != null) {
      map['medical_exam_expiry'] = Variable<DateTime>(medicalExamExpiry);
    }
    if (!nullToAbsent || psychologicalExamExpiry != null) {
      map['psychological_exam_expiry'] = Variable<DateTime>(
        psychologicalExamExpiry,
      );
    }
    if (!nullToAbsent || tachographCardExpiry != null) {
      map['tachograph_card_expiry'] = Variable<DateTime>(tachographCardExpiry);
    }
    if (!nullToAbsent || licenseExpiry != null) {
      map['license_expiry'] = Variable<DateTime>(licenseExpiry);
    }
    if (!nullToAbsent || visaExpiry != null) {
      map['visa_expiry'] = Variable<DateTime>(visaExpiry);
    }
    if (!nullToAbsent || workPermitExpiry != null) {
      map['work_permit_expiry'] = Variable<DateTime>(workPermitExpiry);
    }
    if (!nullToAbsent || residenceCardExpiry != null) {
      map['residence_card_expiry'] = Variable<DateTime>(residenceCardExpiry);
    }
    if (!nullToAbsent || driverCertificateExpiry != null) {
      map['driver_certificate_expiry'] = Variable<DateTime>(
        driverCertificateExpiry,
      );
    }
    return map;
  }

  DriverProfileTableCompanion toCompanion(bool nullToAbsent) {
    return DriverProfileTableCompanion(
      key: Value(key),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      companyInternalId: companyInternalId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyInternalId),
      driverCode: driverCode == null && nullToAbsent
          ? const Value.absent()
          : Value(driverCode),
      updatedAt: Value(updatedAt),
      medicalExamExpiry: medicalExamExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalExamExpiry),
      psychologicalExamExpiry: psychologicalExamExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(psychologicalExamExpiry),
      tachographCardExpiry: tachographCardExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(tachographCardExpiry),
      licenseExpiry: licenseExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseExpiry),
      visaExpiry: visaExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(visaExpiry),
      workPermitExpiry: workPermitExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(workPermitExpiry),
      residenceCardExpiry: residenceCardExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(residenceCardExpiry),
      driverCertificateExpiry: driverCertificateExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(driverCertificateExpiry),
    );
  }

  factory DriverProfileTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriverProfileTableData(
      key: serializer.fromJson<String>(json['key']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      companyInternalId: serializer.fromJson<String?>(
        json['companyInternalId'],
      ),
      driverCode: serializer.fromJson<String?>(json['driverCode']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      medicalExamExpiry: serializer.fromJson<DateTime?>(
        json['medicalExamExpiry'],
      ),
      psychologicalExamExpiry: serializer.fromJson<DateTime?>(
        json['psychologicalExamExpiry'],
      ),
      tachographCardExpiry: serializer.fromJson<DateTime?>(
        json['tachographCardExpiry'],
      ),
      licenseExpiry: serializer.fromJson<DateTime?>(json['licenseExpiry']),
      visaExpiry: serializer.fromJson<DateTime?>(json['visaExpiry']),
      workPermitExpiry: serializer.fromJson<DateTime?>(
        json['workPermitExpiry'],
      ),
      residenceCardExpiry: serializer.fromJson<DateTime?>(
        json['residenceCardExpiry'],
      ),
      driverCertificateExpiry: serializer.fromJson<DateTime?>(
        json['driverCertificateExpiry'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'companyInternalId': serializer.toJson<String?>(companyInternalId),
      'driverCode': serializer.toJson<String?>(driverCode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'medicalExamExpiry': serializer.toJson<DateTime?>(medicalExamExpiry),
      'psychologicalExamExpiry': serializer.toJson<DateTime?>(
        psychologicalExamExpiry,
      ),
      'tachographCardExpiry': serializer.toJson<DateTime?>(
        tachographCardExpiry,
      ),
      'licenseExpiry': serializer.toJson<DateTime?>(licenseExpiry),
      'visaExpiry': serializer.toJson<DateTime?>(visaExpiry),
      'workPermitExpiry': serializer.toJson<DateTime?>(workPermitExpiry),
      'residenceCardExpiry': serializer.toJson<DateTime?>(residenceCardExpiry),
      'driverCertificateExpiry': serializer.toJson<DateTime?>(
        driverCertificateExpiry,
      ),
    };
  }

  DriverProfileTableData copyWith({
    String? key,
    String? firstName,
    String? lastName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> companyInternalId = const Value.absent(),
    Value<String?> driverCode = const Value.absent(),
    DateTime? updatedAt,
    Value<DateTime?> medicalExamExpiry = const Value.absent(),
    Value<DateTime?> psychologicalExamExpiry = const Value.absent(),
    Value<DateTime?> tachographCardExpiry = const Value.absent(),
    Value<DateTime?> licenseExpiry = const Value.absent(),
    Value<DateTime?> visaExpiry = const Value.absent(),
    Value<DateTime?> workPermitExpiry = const Value.absent(),
    Value<DateTime?> residenceCardExpiry = const Value.absent(),
    Value<DateTime?> driverCertificateExpiry = const Value.absent(),
  }) => DriverProfileTableData(
    key: key ?? this.key,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    companyInternalId: companyInternalId.present
        ? companyInternalId.value
        : this.companyInternalId,
    driverCode: driverCode.present ? driverCode.value : this.driverCode,
    updatedAt: updatedAt ?? this.updatedAt,
    medicalExamExpiry: medicalExamExpiry.present
        ? medicalExamExpiry.value
        : this.medicalExamExpiry,
    psychologicalExamExpiry: psychologicalExamExpiry.present
        ? psychologicalExamExpiry.value
        : this.psychologicalExamExpiry,
    tachographCardExpiry: tachographCardExpiry.present
        ? tachographCardExpiry.value
        : this.tachographCardExpiry,
    licenseExpiry: licenseExpiry.present
        ? licenseExpiry.value
        : this.licenseExpiry,
    visaExpiry: visaExpiry.present ? visaExpiry.value : this.visaExpiry,
    workPermitExpiry: workPermitExpiry.present
        ? workPermitExpiry.value
        : this.workPermitExpiry,
    residenceCardExpiry: residenceCardExpiry.present
        ? residenceCardExpiry.value
        : this.residenceCardExpiry,
    driverCertificateExpiry: driverCertificateExpiry.present
        ? driverCertificateExpiry.value
        : this.driverCertificateExpiry,
  );
  DriverProfileTableData copyWithCompanion(DriverProfileTableCompanion data) {
    return DriverProfileTableData(
      key: data.key.present ? data.key.value : this.key,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      companyInternalId: data.companyInternalId.present
          ? data.companyInternalId.value
          : this.companyInternalId,
      driverCode: data.driverCode.present
          ? data.driverCode.value
          : this.driverCode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      medicalExamExpiry: data.medicalExamExpiry.present
          ? data.medicalExamExpiry.value
          : this.medicalExamExpiry,
      psychologicalExamExpiry: data.psychologicalExamExpiry.present
          ? data.psychologicalExamExpiry.value
          : this.psychologicalExamExpiry,
      tachographCardExpiry: data.tachographCardExpiry.present
          ? data.tachographCardExpiry.value
          : this.tachographCardExpiry,
      licenseExpiry: data.licenseExpiry.present
          ? data.licenseExpiry.value
          : this.licenseExpiry,
      visaExpiry: data.visaExpiry.present
          ? data.visaExpiry.value
          : this.visaExpiry,
      workPermitExpiry: data.workPermitExpiry.present
          ? data.workPermitExpiry.value
          : this.workPermitExpiry,
      residenceCardExpiry: data.residenceCardExpiry.present
          ? data.residenceCardExpiry.value
          : this.residenceCardExpiry,
      driverCertificateExpiry: data.driverCertificateExpiry.present
          ? data.driverCertificateExpiry.value
          : this.driverCertificateExpiry,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriverProfileTableData(')
          ..write('key: $key, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('companyInternalId: $companyInternalId, ')
          ..write('driverCode: $driverCode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('medicalExamExpiry: $medicalExamExpiry, ')
          ..write('psychologicalExamExpiry: $psychologicalExamExpiry, ')
          ..write('tachographCardExpiry: $tachographCardExpiry, ')
          ..write('licenseExpiry: $licenseExpiry, ')
          ..write('visaExpiry: $visaExpiry, ')
          ..write('workPermitExpiry: $workPermitExpiry, ')
          ..write('residenceCardExpiry: $residenceCardExpiry, ')
          ..write('driverCertificateExpiry: $driverCertificateExpiry')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    firstName,
    lastName,
    email,
    phone,
    companyInternalId,
    driverCode,
    updatedAt,
    medicalExamExpiry,
    psychologicalExamExpiry,
    tachographCardExpiry,
    licenseExpiry,
    visaExpiry,
    workPermitExpiry,
    residenceCardExpiry,
    driverCertificateExpiry,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriverProfileTableData &&
          other.key == this.key &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.companyInternalId == this.companyInternalId &&
          other.driverCode == this.driverCode &&
          other.updatedAt == this.updatedAt &&
          other.medicalExamExpiry == this.medicalExamExpiry &&
          other.psychologicalExamExpiry == this.psychologicalExamExpiry &&
          other.tachographCardExpiry == this.tachographCardExpiry &&
          other.licenseExpiry == this.licenseExpiry &&
          other.visaExpiry == this.visaExpiry &&
          other.workPermitExpiry == this.workPermitExpiry &&
          other.residenceCardExpiry == this.residenceCardExpiry &&
          other.driverCertificateExpiry == this.driverCertificateExpiry);
}

class DriverProfileTableCompanion
    extends UpdateCompanion<DriverProfileTableData> {
  final Value<String> key;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> companyInternalId;
  final Value<String?> driverCode;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> medicalExamExpiry;
  final Value<DateTime?> psychologicalExamExpiry;
  final Value<DateTime?> tachographCardExpiry;
  final Value<DateTime?> licenseExpiry;
  final Value<DateTime?> visaExpiry;
  final Value<DateTime?> workPermitExpiry;
  final Value<DateTime?> residenceCardExpiry;
  final Value<DateTime?> driverCertificateExpiry;
  final Value<int> rowid;
  const DriverProfileTableCompanion({
    this.key = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.companyInternalId = const Value.absent(),
    this.driverCode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.medicalExamExpiry = const Value.absent(),
    this.psychologicalExamExpiry = const Value.absent(),
    this.tachographCardExpiry = const Value.absent(),
    this.licenseExpiry = const Value.absent(),
    this.visaExpiry = const Value.absent(),
    this.workPermitExpiry = const Value.absent(),
    this.residenceCardExpiry = const Value.absent(),
    this.driverCertificateExpiry = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriverProfileTableCompanion.insert({
    required String key,
    required String firstName,
    required String lastName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.companyInternalId = const Value.absent(),
    this.driverCode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.medicalExamExpiry = const Value.absent(),
    this.psychologicalExamExpiry = const Value.absent(),
    this.tachographCardExpiry = const Value.absent(),
    this.licenseExpiry = const Value.absent(),
    this.visaExpiry = const Value.absent(),
    this.workPermitExpiry = const Value.absent(),
    this.residenceCardExpiry = const Value.absent(),
    this.driverCertificateExpiry = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<DriverProfileTableData> custom({
    Expression<String>? key,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? companyInternalId,
    Expression<String>? driverCode,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? medicalExamExpiry,
    Expression<DateTime>? psychologicalExamExpiry,
    Expression<DateTime>? tachographCardExpiry,
    Expression<DateTime>? licenseExpiry,
    Expression<DateTime>? visaExpiry,
    Expression<DateTime>? workPermitExpiry,
    Expression<DateTime>? residenceCardExpiry,
    Expression<DateTime>? driverCertificateExpiry,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (companyInternalId != null) 'company_internal_id': companyInternalId,
      if (driverCode != null) 'driver_code': driverCode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (medicalExamExpiry != null) 'medical_exam_expiry': medicalExamExpiry,
      if (psychologicalExamExpiry != null)
        'psychological_exam_expiry': psychologicalExamExpiry,
      if (tachographCardExpiry != null)
        'tachograph_card_expiry': tachographCardExpiry,
      if (licenseExpiry != null) 'license_expiry': licenseExpiry,
      if (visaExpiry != null) 'visa_expiry': visaExpiry,
      if (workPermitExpiry != null) 'work_permit_expiry': workPermitExpiry,
      if (residenceCardExpiry != null)
        'residence_card_expiry': residenceCardExpiry,
      if (driverCertificateExpiry != null)
        'driver_certificate_expiry': driverCertificateExpiry,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriverProfileTableCompanion copyWith({
    Value<String>? key,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? companyInternalId,
    Value<String?>? driverCode,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? medicalExamExpiry,
    Value<DateTime?>? psychologicalExamExpiry,
    Value<DateTime?>? tachographCardExpiry,
    Value<DateTime?>? licenseExpiry,
    Value<DateTime?>? visaExpiry,
    Value<DateTime?>? workPermitExpiry,
    Value<DateTime?>? residenceCardExpiry,
    Value<DateTime?>? driverCertificateExpiry,
    Value<int>? rowid,
  }) {
    return DriverProfileTableCompanion(
      key: key ?? this.key,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      companyInternalId: companyInternalId ?? this.companyInternalId,
      driverCode: driverCode ?? this.driverCode,
      updatedAt: updatedAt ?? this.updatedAt,
      medicalExamExpiry: medicalExamExpiry ?? this.medicalExamExpiry,
      psychologicalExamExpiry:
          psychologicalExamExpiry ?? this.psychologicalExamExpiry,
      tachographCardExpiry: tachographCardExpiry ?? this.tachographCardExpiry,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      visaExpiry: visaExpiry ?? this.visaExpiry,
      workPermitExpiry: workPermitExpiry ?? this.workPermitExpiry,
      residenceCardExpiry: residenceCardExpiry ?? this.residenceCardExpiry,
      driverCertificateExpiry:
          driverCertificateExpiry ?? this.driverCertificateExpiry,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (companyInternalId.present) {
      map['company_internal_id'] = Variable<String>(companyInternalId.value);
    }
    if (driverCode.present) {
      map['driver_code'] = Variable<String>(driverCode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (medicalExamExpiry.present) {
      map['medical_exam_expiry'] = Variable<DateTime>(medicalExamExpiry.value);
    }
    if (psychologicalExamExpiry.present) {
      map['psychological_exam_expiry'] = Variable<DateTime>(
        psychologicalExamExpiry.value,
      );
    }
    if (tachographCardExpiry.present) {
      map['tachograph_card_expiry'] = Variable<DateTime>(
        tachographCardExpiry.value,
      );
    }
    if (licenseExpiry.present) {
      map['license_expiry'] = Variable<DateTime>(licenseExpiry.value);
    }
    if (visaExpiry.present) {
      map['visa_expiry'] = Variable<DateTime>(visaExpiry.value);
    }
    if (workPermitExpiry.present) {
      map['work_permit_expiry'] = Variable<DateTime>(workPermitExpiry.value);
    }
    if (residenceCardExpiry.present) {
      map['residence_card_expiry'] = Variable<DateTime>(
        residenceCardExpiry.value,
      );
    }
    if (driverCertificateExpiry.present) {
      map['driver_certificate_expiry'] = Variable<DateTime>(
        driverCertificateExpiry.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriverProfileTableCompanion(')
          ..write('key: $key, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('companyInternalId: $companyInternalId, ')
          ..write('driverCode: $driverCode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('medicalExamExpiry: $medicalExamExpiry, ')
          ..write('psychologicalExamExpiry: $psychologicalExamExpiry, ')
          ..write('tachographCardExpiry: $tachographCardExpiry, ')
          ..write('licenseExpiry: $licenseExpiry, ')
          ..write('visaExpiry: $visaExpiry, ')
          ..write('workPermitExpiry: $workPermitExpiry, ')
          ..write('residenceCardExpiry: $residenceCardExpiry, ')
          ..write('driverCertificateExpiry: $driverCertificateExpiry, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DriverCurrentOrderTableTable extends DriverCurrentOrderTable
    with TableInfo<$DriverCurrentOrderTableTable, DriverCurrentOrderTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriverCurrentOrderTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ztNumberMeta = const VerificationMeta(
    'ztNumber',
  );
  @override
  late final GeneratedColumn<String> ztNumber = GeneratedColumn<String>(
    'zt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromCountryMeta = const VerificationMeta(
    'fromCountry',
  );
  @override
  late final GeneratedColumn<String> fromCountry = GeneratedColumn<String>(
    'from_country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toCountryMeta = const VerificationMeta(
    'toCountry',
  );
  @override
  late final GeneratedColumn<String> toCountry = GeneratedColumn<String>(
    'to_country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loadingDateMeta = const VerificationMeta(
    'loadingDate',
  );
  @override
  late final GeneratedColumn<DateTime> loadingDate = GeneratedColumn<DateTime>(
    'loading_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    id,
    ztNumber,
    status,
    fromCountry,
    toCountry,
    loadingDate,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'driver_current_order_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriverCurrentOrderTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('zt_number')) {
      context.handle(
        _ztNumberMeta,
        ztNumber.isAcceptableOrUnknown(data['zt_number']!, _ztNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ztNumberMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('from_country')) {
      context.handle(
        _fromCountryMeta,
        fromCountry.isAcceptableOrUnknown(
          data['from_country']!,
          _fromCountryMeta,
        ),
      );
    }
    if (data.containsKey('to_country')) {
      context.handle(
        _toCountryMeta,
        toCountry.isAcceptableOrUnknown(data['to_country']!, _toCountryMeta),
      );
    }
    if (data.containsKey('loading_date')) {
      context.handle(
        _loadingDateMeta,
        loadingDate.isAcceptableOrUnknown(
          data['loading_date']!,
          _loadingDateMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DriverCurrentOrderTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriverCurrentOrderTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ztNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zt_number'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      fromCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_country'],
      ),
      toCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_country'],
      ),
      loadingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}loading_date'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DriverCurrentOrderTableTable createAlias(String alias) {
    return $DriverCurrentOrderTableTable(attachedDatabase, alias);
  }
}

class DriverCurrentOrderTableData extends DataClass
    implements Insertable<DriverCurrentOrderTableData> {
  final String key;
  final String id;
  final String ztNumber;
  final String status;
  final String? fromCountry;
  final String? toCountry;
  final DateTime? loadingDate;
  final DateTime updatedAt;
  const DriverCurrentOrderTableData({
    required this.key,
    required this.id,
    required this.ztNumber,
    required this.status,
    this.fromCountry,
    this.toCountry,
    this.loadingDate,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['id'] = Variable<String>(id);
    map['zt_number'] = Variable<String>(ztNumber);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || fromCountry != null) {
      map['from_country'] = Variable<String>(fromCountry);
    }
    if (!nullToAbsent || toCountry != null) {
      map['to_country'] = Variable<String>(toCountry);
    }
    if (!nullToAbsent || loadingDate != null) {
      map['loading_date'] = Variable<DateTime>(loadingDate);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DriverCurrentOrderTableCompanion toCompanion(bool nullToAbsent) {
    return DriverCurrentOrderTableCompanion(
      key: Value(key),
      id: Value(id),
      ztNumber: Value(ztNumber),
      status: Value(status),
      fromCountry: fromCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(fromCountry),
      toCountry: toCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(toCountry),
      loadingDate: loadingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(loadingDate),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriverCurrentOrderTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriverCurrentOrderTableData(
      key: serializer.fromJson<String>(json['key']),
      id: serializer.fromJson<String>(json['id']),
      ztNumber: serializer.fromJson<String>(json['ztNumber']),
      status: serializer.fromJson<String>(json['status']),
      fromCountry: serializer.fromJson<String?>(json['fromCountry']),
      toCountry: serializer.fromJson<String?>(json['toCountry']),
      loadingDate: serializer.fromJson<DateTime?>(json['loadingDate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'id': serializer.toJson<String>(id),
      'ztNumber': serializer.toJson<String>(ztNumber),
      'status': serializer.toJson<String>(status),
      'fromCountry': serializer.toJson<String?>(fromCountry),
      'toCountry': serializer.toJson<String?>(toCountry),
      'loadingDate': serializer.toJson<DateTime?>(loadingDate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriverCurrentOrderTableData copyWith({
    String? key,
    String? id,
    String? ztNumber,
    String? status,
    Value<String?> fromCountry = const Value.absent(),
    Value<String?> toCountry = const Value.absent(),
    Value<DateTime?> loadingDate = const Value.absent(),
    DateTime? updatedAt,
  }) => DriverCurrentOrderTableData(
    key: key ?? this.key,
    id: id ?? this.id,
    ztNumber: ztNumber ?? this.ztNumber,
    status: status ?? this.status,
    fromCountry: fromCountry.present ? fromCountry.value : this.fromCountry,
    toCountry: toCountry.present ? toCountry.value : this.toCountry,
    loadingDate: loadingDate.present ? loadingDate.value : this.loadingDate,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DriverCurrentOrderTableData copyWithCompanion(
    DriverCurrentOrderTableCompanion data,
  ) {
    return DriverCurrentOrderTableData(
      key: data.key.present ? data.key.value : this.key,
      id: data.id.present ? data.id.value : this.id,
      ztNumber: data.ztNumber.present ? data.ztNumber.value : this.ztNumber,
      status: data.status.present ? data.status.value : this.status,
      fromCountry: data.fromCountry.present
          ? data.fromCountry.value
          : this.fromCountry,
      toCountry: data.toCountry.present ? data.toCountry.value : this.toCountry,
      loadingDate: data.loadingDate.present
          ? data.loadingDate.value
          : this.loadingDate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriverCurrentOrderTableData(')
          ..write('key: $key, ')
          ..write('id: $id, ')
          ..write('ztNumber: $ztNumber, ')
          ..write('status: $status, ')
          ..write('fromCountry: $fromCountry, ')
          ..write('toCountry: $toCountry, ')
          ..write('loadingDate: $loadingDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    id,
    ztNumber,
    status,
    fromCountry,
    toCountry,
    loadingDate,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriverCurrentOrderTableData &&
          other.key == this.key &&
          other.id == this.id &&
          other.ztNumber == this.ztNumber &&
          other.status == this.status &&
          other.fromCountry == this.fromCountry &&
          other.toCountry == this.toCountry &&
          other.loadingDate == this.loadingDate &&
          other.updatedAt == this.updatedAt);
}

class DriverCurrentOrderTableCompanion
    extends UpdateCompanion<DriverCurrentOrderTableData> {
  final Value<String> key;
  final Value<String> id;
  final Value<String> ztNumber;
  final Value<String> status;
  final Value<String?> fromCountry;
  final Value<String?> toCountry;
  final Value<DateTime?> loadingDate;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DriverCurrentOrderTableCompanion({
    this.key = const Value.absent(),
    this.id = const Value.absent(),
    this.ztNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.fromCountry = const Value.absent(),
    this.toCountry = const Value.absent(),
    this.loadingDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriverCurrentOrderTableCompanion.insert({
    required String key,
    required String id,
    required String ztNumber,
    required String status,
    this.fromCountry = const Value.absent(),
    this.toCountry = const Value.absent(),
    this.loadingDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       id = Value(id),
       ztNumber = Value(ztNumber),
       status = Value(status);
  static Insertable<DriverCurrentOrderTableData> custom({
    Expression<String>? key,
    Expression<String>? id,
    Expression<String>? ztNumber,
    Expression<String>? status,
    Expression<String>? fromCountry,
    Expression<String>? toCountry,
    Expression<DateTime>? loadingDate,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (id != null) 'id': id,
      if (ztNumber != null) 'zt_number': ztNumber,
      if (status != null) 'status': status,
      if (fromCountry != null) 'from_country': fromCountry,
      if (toCountry != null) 'to_country': toCountry,
      if (loadingDate != null) 'loading_date': loadingDate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriverCurrentOrderTableCompanion copyWith({
    Value<String>? key,
    Value<String>? id,
    Value<String>? ztNumber,
    Value<String>? status,
    Value<String?>? fromCountry,
    Value<String?>? toCountry,
    Value<DateTime?>? loadingDate,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DriverCurrentOrderTableCompanion(
      key: key ?? this.key,
      id: id ?? this.id,
      ztNumber: ztNumber ?? this.ztNumber,
      status: status ?? this.status,
      fromCountry: fromCountry ?? this.fromCountry,
      toCountry: toCountry ?? this.toCountry,
      loadingDate: loadingDate ?? this.loadingDate,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ztNumber.present) {
      map['zt_number'] = Variable<String>(ztNumber.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (fromCountry.present) {
      map['from_country'] = Variable<String>(fromCountry.value);
    }
    if (toCountry.present) {
      map['to_country'] = Variable<String>(toCountry.value);
    }
    if (loadingDate.present) {
      map['loading_date'] = Variable<DateTime>(loadingDate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriverCurrentOrderTableCompanion(')
          ..write('key: $key, ')
          ..write('id: $id, ')
          ..write('ztNumber: $ztNumber, ')
          ..write('status: $status, ')
          ..write('fromCountry: $fromCountry, ')
          ..write('toCountry: $toCountry, ')
          ..write('loadingDate: $loadingDate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DriverOrderDetailsTableTable extends DriverOrderDetailsTable
    with TableInfo<$DriverOrderDetailsTableTable, DriverOrderDetailsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriverOrderDetailsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ztNumberMeta = const VerificationMeta(
    'ztNumber',
  );
  @override
  late final GeneratedColumn<String> ztNumber = GeneratedColumn<String>(
    'zt_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehiclePlateMeta = const VerificationMeta(
    'vehiclePlate',
  );
  @override
  late final GeneratedColumn<String> vehiclePlate = GeneratedColumn<String>(
    'vehicle_plate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trailerPlateMeta = const VerificationMeta(
    'trailerPlate',
  );
  @override
  late final GeneratedColumn<String> trailerPlate = GeneratedColumn<String>(
    'trailer_plate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromCountryMeta = const VerificationMeta(
    'fromCountry',
  );
  @override
  late final GeneratedColumn<String> fromCountry = GeneratedColumn<String>(
    'from_country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromAddressMeta = const VerificationMeta(
    'fromAddress',
  );
  @override
  late final GeneratedColumn<String> fromAddress = GeneratedColumn<String>(
    'from_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toCountryMeta = const VerificationMeta(
    'toCountry',
  );
  @override
  late final GeneratedColumn<String> toCountry = GeneratedColumn<String>(
    'to_country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toAddressMeta = const VerificationMeta(
    'toAddress',
  );
  @override
  late final GeneratedColumn<String> toAddress = GeneratedColumn<String>(
    'to_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cargoWeightKgMeta = const VerificationMeta(
    'cargoWeightKg',
  );
  @override
  late final GeneratedColumn<int> cargoWeightKg = GeneratedColumn<int>(
    'cargo_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loadingDateMeta = const VerificationMeta(
    'loadingDate',
  );
  @override
  late final GeneratedColumn<DateTime> loadingDate = GeneratedColumn<DateTime>(
    'loading_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cargoDescriptionMeta = const VerificationMeta(
    'cargoDescription',
  );
  @override
  late final GeneratedColumn<String> cargoDescription = GeneratedColumn<String>(
    'cargo_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureSensitiveMeta =
      const VerificationMeta('temperatureSensitive');
  @override
  late final GeneratedColumn<bool> temperatureSensitive = GeneratedColumn<bool>(
    'temperature_sensitive',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("temperature_sensitive" IN (0, 1))',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ztNumber,
    status,
    vehiclePlate,
    trailerPlate,
    clientName,
    fromCountry,
    fromAddress,
    toCountry,
    toAddress,
    cargoWeightKg,
    loadingDate,
    cargoDescription,
    temperatureSensitive,
    notes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'driver_order_details_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriverOrderDetailsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('zt_number')) {
      context.handle(
        _ztNumberMeta,
        ztNumber.isAcceptableOrUnknown(data['zt_number']!, _ztNumberMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('vehicle_plate')) {
      context.handle(
        _vehiclePlateMeta,
        vehiclePlate.isAcceptableOrUnknown(
          data['vehicle_plate']!,
          _vehiclePlateMeta,
        ),
      );
    }
    if (data.containsKey('trailer_plate')) {
      context.handle(
        _trailerPlateMeta,
        trailerPlate.isAcceptableOrUnknown(
          data['trailer_plate']!,
          _trailerPlateMeta,
        ),
      );
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    }
    if (data.containsKey('from_country')) {
      context.handle(
        _fromCountryMeta,
        fromCountry.isAcceptableOrUnknown(
          data['from_country']!,
          _fromCountryMeta,
        ),
      );
    }
    if (data.containsKey('from_address')) {
      context.handle(
        _fromAddressMeta,
        fromAddress.isAcceptableOrUnknown(
          data['from_address']!,
          _fromAddressMeta,
        ),
      );
    }
    if (data.containsKey('to_country')) {
      context.handle(
        _toCountryMeta,
        toCountry.isAcceptableOrUnknown(data['to_country']!, _toCountryMeta),
      );
    }
    if (data.containsKey('to_address')) {
      context.handle(
        _toAddressMeta,
        toAddress.isAcceptableOrUnknown(data['to_address']!, _toAddressMeta),
      );
    }
    if (data.containsKey('cargo_weight_kg')) {
      context.handle(
        _cargoWeightKgMeta,
        cargoWeightKg.isAcceptableOrUnknown(
          data['cargo_weight_kg']!,
          _cargoWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('loading_date')) {
      context.handle(
        _loadingDateMeta,
        loadingDate.isAcceptableOrUnknown(
          data['loading_date']!,
          _loadingDateMeta,
        ),
      );
    }
    if (data.containsKey('cargo_description')) {
      context.handle(
        _cargoDescriptionMeta,
        cargoDescription.isAcceptableOrUnknown(
          data['cargo_description']!,
          _cargoDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('temperature_sensitive')) {
      context.handle(
        _temperatureSensitiveMeta,
        temperatureSensitive.isAcceptableOrUnknown(
          data['temperature_sensitive']!,
          _temperatureSensitiveMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriverOrderDetailsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriverOrderDetailsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ztNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zt_number'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      vehiclePlate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_plate'],
      ),
      trailerPlate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trailer_plate'],
      ),
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      ),
      fromCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_country'],
      ),
      fromAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_address'],
      ),
      toCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_country'],
      ),
      toAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_address'],
      ),
      cargoWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cargo_weight_kg'],
      ),
      loadingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}loading_date'],
      ),
      cargoDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cargo_description'],
      ),
      temperatureSensitive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}temperature_sensitive'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DriverOrderDetailsTableTable createAlias(String alias) {
    return $DriverOrderDetailsTableTable(attachedDatabase, alias);
  }
}

class DriverOrderDetailsTableData extends DataClass
    implements Insertable<DriverOrderDetailsTableData> {
  final String id;
  final String? ztNumber;
  final String? status;
  final String? vehiclePlate;
  final String? trailerPlate;
  final String? clientName;
  final String? fromCountry;
  final String? fromAddress;
  final String? toCountry;
  final String? toAddress;
  final int? cargoWeightKg;
  final DateTime? loadingDate;
  final String? cargoDescription;
  final bool? temperatureSensitive;
  final String? notes;
  final DateTime updatedAt;
  const DriverOrderDetailsTableData({
    required this.id,
    this.ztNumber,
    this.status,
    this.vehiclePlate,
    this.trailerPlate,
    this.clientName,
    this.fromCountry,
    this.fromAddress,
    this.toCountry,
    this.toAddress,
    this.cargoWeightKg,
    this.loadingDate,
    this.cargoDescription,
    this.temperatureSensitive,
    this.notes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || ztNumber != null) {
      map['zt_number'] = Variable<String>(ztNumber);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || vehiclePlate != null) {
      map['vehicle_plate'] = Variable<String>(vehiclePlate);
    }
    if (!nullToAbsent || trailerPlate != null) {
      map['trailer_plate'] = Variable<String>(trailerPlate);
    }
    if (!nullToAbsent || clientName != null) {
      map['client_name'] = Variable<String>(clientName);
    }
    if (!nullToAbsent || fromCountry != null) {
      map['from_country'] = Variable<String>(fromCountry);
    }
    if (!nullToAbsent || fromAddress != null) {
      map['from_address'] = Variable<String>(fromAddress);
    }
    if (!nullToAbsent || toCountry != null) {
      map['to_country'] = Variable<String>(toCountry);
    }
    if (!nullToAbsent || toAddress != null) {
      map['to_address'] = Variable<String>(toAddress);
    }
    if (!nullToAbsent || cargoWeightKg != null) {
      map['cargo_weight_kg'] = Variable<int>(cargoWeightKg);
    }
    if (!nullToAbsent || loadingDate != null) {
      map['loading_date'] = Variable<DateTime>(loadingDate);
    }
    if (!nullToAbsent || cargoDescription != null) {
      map['cargo_description'] = Variable<String>(cargoDescription);
    }
    if (!nullToAbsent || temperatureSensitive != null) {
      map['temperature_sensitive'] = Variable<bool>(temperatureSensitive);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DriverOrderDetailsTableCompanion toCompanion(bool nullToAbsent) {
    return DriverOrderDetailsTableCompanion(
      id: Value(id),
      ztNumber: ztNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(ztNumber),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      vehiclePlate: vehiclePlate == null && nullToAbsent
          ? const Value.absent()
          : Value(vehiclePlate),
      trailerPlate: trailerPlate == null && nullToAbsent
          ? const Value.absent()
          : Value(trailerPlate),
      clientName: clientName == null && nullToAbsent
          ? const Value.absent()
          : Value(clientName),
      fromCountry: fromCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(fromCountry),
      fromAddress: fromAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(fromAddress),
      toCountry: toCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(toCountry),
      toAddress: toAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(toAddress),
      cargoWeightKg: cargoWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(cargoWeightKg),
      loadingDate: loadingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(loadingDate),
      cargoDescription: cargoDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(cargoDescription),
      temperatureSensitive: temperatureSensitive == null && nullToAbsent
          ? const Value.absent()
          : Value(temperatureSensitive),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriverOrderDetailsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriverOrderDetailsTableData(
      id: serializer.fromJson<String>(json['id']),
      ztNumber: serializer.fromJson<String?>(json['ztNumber']),
      status: serializer.fromJson<String?>(json['status']),
      vehiclePlate: serializer.fromJson<String?>(json['vehiclePlate']),
      trailerPlate: serializer.fromJson<String?>(json['trailerPlate']),
      clientName: serializer.fromJson<String?>(json['clientName']),
      fromCountry: serializer.fromJson<String?>(json['fromCountry']),
      fromAddress: serializer.fromJson<String?>(json['fromAddress']),
      toCountry: serializer.fromJson<String?>(json['toCountry']),
      toAddress: serializer.fromJson<String?>(json['toAddress']),
      cargoWeightKg: serializer.fromJson<int?>(json['cargoWeightKg']),
      loadingDate: serializer.fromJson<DateTime?>(json['loadingDate']),
      cargoDescription: serializer.fromJson<String?>(json['cargoDescription']),
      temperatureSensitive: serializer.fromJson<bool?>(
        json['temperatureSensitive'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ztNumber': serializer.toJson<String?>(ztNumber),
      'status': serializer.toJson<String?>(status),
      'vehiclePlate': serializer.toJson<String?>(vehiclePlate),
      'trailerPlate': serializer.toJson<String?>(trailerPlate),
      'clientName': serializer.toJson<String?>(clientName),
      'fromCountry': serializer.toJson<String?>(fromCountry),
      'fromAddress': serializer.toJson<String?>(fromAddress),
      'toCountry': serializer.toJson<String?>(toCountry),
      'toAddress': serializer.toJson<String?>(toAddress),
      'cargoWeightKg': serializer.toJson<int?>(cargoWeightKg),
      'loadingDate': serializer.toJson<DateTime?>(loadingDate),
      'cargoDescription': serializer.toJson<String?>(cargoDescription),
      'temperatureSensitive': serializer.toJson<bool?>(temperatureSensitive),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriverOrderDetailsTableData copyWith({
    String? id,
    Value<String?> ztNumber = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<String?> vehiclePlate = const Value.absent(),
    Value<String?> trailerPlate = const Value.absent(),
    Value<String?> clientName = const Value.absent(),
    Value<String?> fromCountry = const Value.absent(),
    Value<String?> fromAddress = const Value.absent(),
    Value<String?> toCountry = const Value.absent(),
    Value<String?> toAddress = const Value.absent(),
    Value<int?> cargoWeightKg = const Value.absent(),
    Value<DateTime?> loadingDate = const Value.absent(),
    Value<String?> cargoDescription = const Value.absent(),
    Value<bool?> temperatureSensitive = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
  }) => DriverOrderDetailsTableData(
    id: id ?? this.id,
    ztNumber: ztNumber.present ? ztNumber.value : this.ztNumber,
    status: status.present ? status.value : this.status,
    vehiclePlate: vehiclePlate.present ? vehiclePlate.value : this.vehiclePlate,
    trailerPlate: trailerPlate.present ? trailerPlate.value : this.trailerPlate,
    clientName: clientName.present ? clientName.value : this.clientName,
    fromCountry: fromCountry.present ? fromCountry.value : this.fromCountry,
    fromAddress: fromAddress.present ? fromAddress.value : this.fromAddress,
    toCountry: toCountry.present ? toCountry.value : this.toCountry,
    toAddress: toAddress.present ? toAddress.value : this.toAddress,
    cargoWeightKg: cargoWeightKg.present
        ? cargoWeightKg.value
        : this.cargoWeightKg,
    loadingDate: loadingDate.present ? loadingDate.value : this.loadingDate,
    cargoDescription: cargoDescription.present
        ? cargoDescription.value
        : this.cargoDescription,
    temperatureSensitive: temperatureSensitive.present
        ? temperatureSensitive.value
        : this.temperatureSensitive,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DriverOrderDetailsTableData copyWithCompanion(
    DriverOrderDetailsTableCompanion data,
  ) {
    return DriverOrderDetailsTableData(
      id: data.id.present ? data.id.value : this.id,
      ztNumber: data.ztNumber.present ? data.ztNumber.value : this.ztNumber,
      status: data.status.present ? data.status.value : this.status,
      vehiclePlate: data.vehiclePlate.present
          ? data.vehiclePlate.value
          : this.vehiclePlate,
      trailerPlate: data.trailerPlate.present
          ? data.trailerPlate.value
          : this.trailerPlate,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      fromCountry: data.fromCountry.present
          ? data.fromCountry.value
          : this.fromCountry,
      fromAddress: data.fromAddress.present
          ? data.fromAddress.value
          : this.fromAddress,
      toCountry: data.toCountry.present ? data.toCountry.value : this.toCountry,
      toAddress: data.toAddress.present ? data.toAddress.value : this.toAddress,
      cargoWeightKg: data.cargoWeightKg.present
          ? data.cargoWeightKg.value
          : this.cargoWeightKg,
      loadingDate: data.loadingDate.present
          ? data.loadingDate.value
          : this.loadingDate,
      cargoDescription: data.cargoDescription.present
          ? data.cargoDescription.value
          : this.cargoDescription,
      temperatureSensitive: data.temperatureSensitive.present
          ? data.temperatureSensitive.value
          : this.temperatureSensitive,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriverOrderDetailsTableData(')
          ..write('id: $id, ')
          ..write('ztNumber: $ztNumber, ')
          ..write('status: $status, ')
          ..write('vehiclePlate: $vehiclePlate, ')
          ..write('trailerPlate: $trailerPlate, ')
          ..write('clientName: $clientName, ')
          ..write('fromCountry: $fromCountry, ')
          ..write('fromAddress: $fromAddress, ')
          ..write('toCountry: $toCountry, ')
          ..write('toAddress: $toAddress, ')
          ..write('cargoWeightKg: $cargoWeightKg, ')
          ..write('loadingDate: $loadingDate, ')
          ..write('cargoDescription: $cargoDescription, ')
          ..write('temperatureSensitive: $temperatureSensitive, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ztNumber,
    status,
    vehiclePlate,
    trailerPlate,
    clientName,
    fromCountry,
    fromAddress,
    toCountry,
    toAddress,
    cargoWeightKg,
    loadingDate,
    cargoDescription,
    temperatureSensitive,
    notes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriverOrderDetailsTableData &&
          other.id == this.id &&
          other.ztNumber == this.ztNumber &&
          other.status == this.status &&
          other.vehiclePlate == this.vehiclePlate &&
          other.trailerPlate == this.trailerPlate &&
          other.clientName == this.clientName &&
          other.fromCountry == this.fromCountry &&
          other.fromAddress == this.fromAddress &&
          other.toCountry == this.toCountry &&
          other.toAddress == this.toAddress &&
          other.cargoWeightKg == this.cargoWeightKg &&
          other.loadingDate == this.loadingDate &&
          other.cargoDescription == this.cargoDescription &&
          other.temperatureSensitive == this.temperatureSensitive &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class DriverOrderDetailsTableCompanion
    extends UpdateCompanion<DriverOrderDetailsTableData> {
  final Value<String> id;
  final Value<String?> ztNumber;
  final Value<String?> status;
  final Value<String?> vehiclePlate;
  final Value<String?> trailerPlate;
  final Value<String?> clientName;
  final Value<String?> fromCountry;
  final Value<String?> fromAddress;
  final Value<String?> toCountry;
  final Value<String?> toAddress;
  final Value<int?> cargoWeightKg;
  final Value<DateTime?> loadingDate;
  final Value<String?> cargoDescription;
  final Value<bool?> temperatureSensitive;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DriverOrderDetailsTableCompanion({
    this.id = const Value.absent(),
    this.ztNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.vehiclePlate = const Value.absent(),
    this.trailerPlate = const Value.absent(),
    this.clientName = const Value.absent(),
    this.fromCountry = const Value.absent(),
    this.fromAddress = const Value.absent(),
    this.toCountry = const Value.absent(),
    this.toAddress = const Value.absent(),
    this.cargoWeightKg = const Value.absent(),
    this.loadingDate = const Value.absent(),
    this.cargoDescription = const Value.absent(),
    this.temperatureSensitive = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriverOrderDetailsTableCompanion.insert({
    required String id,
    this.ztNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.vehiclePlate = const Value.absent(),
    this.trailerPlate = const Value.absent(),
    this.clientName = const Value.absent(),
    this.fromCountry = const Value.absent(),
    this.fromAddress = const Value.absent(),
    this.toCountry = const Value.absent(),
    this.toAddress = const Value.absent(),
    this.cargoWeightKg = const Value.absent(),
    this.loadingDate = const Value.absent(),
    this.cargoDescription = const Value.absent(),
    this.temperatureSensitive = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<DriverOrderDetailsTableData> custom({
    Expression<String>? id,
    Expression<String>? ztNumber,
    Expression<String>? status,
    Expression<String>? vehiclePlate,
    Expression<String>? trailerPlate,
    Expression<String>? clientName,
    Expression<String>? fromCountry,
    Expression<String>? fromAddress,
    Expression<String>? toCountry,
    Expression<String>? toAddress,
    Expression<int>? cargoWeightKg,
    Expression<DateTime>? loadingDate,
    Expression<String>? cargoDescription,
    Expression<bool>? temperatureSensitive,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ztNumber != null) 'zt_number': ztNumber,
      if (status != null) 'status': status,
      if (vehiclePlate != null) 'vehicle_plate': vehiclePlate,
      if (trailerPlate != null) 'trailer_plate': trailerPlate,
      if (clientName != null) 'client_name': clientName,
      if (fromCountry != null) 'from_country': fromCountry,
      if (fromAddress != null) 'from_address': fromAddress,
      if (toCountry != null) 'to_country': toCountry,
      if (toAddress != null) 'to_address': toAddress,
      if (cargoWeightKg != null) 'cargo_weight_kg': cargoWeightKg,
      if (loadingDate != null) 'loading_date': loadingDate,
      if (cargoDescription != null) 'cargo_description': cargoDescription,
      if (temperatureSensitive != null)
        'temperature_sensitive': temperatureSensitive,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriverOrderDetailsTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? ztNumber,
    Value<String?>? status,
    Value<String?>? vehiclePlate,
    Value<String?>? trailerPlate,
    Value<String?>? clientName,
    Value<String?>? fromCountry,
    Value<String?>? fromAddress,
    Value<String?>? toCountry,
    Value<String?>? toAddress,
    Value<int?>? cargoWeightKg,
    Value<DateTime?>? loadingDate,
    Value<String?>? cargoDescription,
    Value<bool?>? temperatureSensitive,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DriverOrderDetailsTableCompanion(
      id: id ?? this.id,
      ztNumber: ztNumber ?? this.ztNumber,
      status: status ?? this.status,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      trailerPlate: trailerPlate ?? this.trailerPlate,
      clientName: clientName ?? this.clientName,
      fromCountry: fromCountry ?? this.fromCountry,
      fromAddress: fromAddress ?? this.fromAddress,
      toCountry: toCountry ?? this.toCountry,
      toAddress: toAddress ?? this.toAddress,
      cargoWeightKg: cargoWeightKg ?? this.cargoWeightKg,
      loadingDate: loadingDate ?? this.loadingDate,
      cargoDescription: cargoDescription ?? this.cargoDescription,
      temperatureSensitive: temperatureSensitive ?? this.temperatureSensitive,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ztNumber.present) {
      map['zt_number'] = Variable<String>(ztNumber.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (vehiclePlate.present) {
      map['vehicle_plate'] = Variable<String>(vehiclePlate.value);
    }
    if (trailerPlate.present) {
      map['trailer_plate'] = Variable<String>(trailerPlate.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (fromCountry.present) {
      map['from_country'] = Variable<String>(fromCountry.value);
    }
    if (fromAddress.present) {
      map['from_address'] = Variable<String>(fromAddress.value);
    }
    if (toCountry.present) {
      map['to_country'] = Variable<String>(toCountry.value);
    }
    if (toAddress.present) {
      map['to_address'] = Variable<String>(toAddress.value);
    }
    if (cargoWeightKg.present) {
      map['cargo_weight_kg'] = Variable<int>(cargoWeightKg.value);
    }
    if (loadingDate.present) {
      map['loading_date'] = Variable<DateTime>(loadingDate.value);
    }
    if (cargoDescription.present) {
      map['cargo_description'] = Variable<String>(cargoDescription.value);
    }
    if (temperatureSensitive.present) {
      map['temperature_sensitive'] = Variable<bool>(temperatureSensitive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriverOrderDetailsTableCompanion(')
          ..write('id: $id, ')
          ..write('ztNumber: $ztNumber, ')
          ..write('status: $status, ')
          ..write('vehiclePlate: $vehiclePlate, ')
          ..write('trailerPlate: $trailerPlate, ')
          ..write('clientName: $clientName, ')
          ..write('fromCountry: $fromCountry, ')
          ..write('fromAddress: $fromAddress, ')
          ..write('toCountry: $toCountry, ')
          ..write('toAddress: $toAddress, ')
          ..write('cargoWeightKg: $cargoWeightKg, ')
          ..write('loadingDate: $loadingDate, ')
          ..write('cargoDescription: $cargoDescription, ')
          ..write('temperatureSensitive: $temperatureSensitive, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DriverOrderDocumentTableTable extends DriverOrderDocumentTable
    with
        TableInfo<
          $DriverOrderDocumentTableTable,
          DriverOrderDocumentTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriverOrderDocumentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDocumentStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LocalDocumentStatus>(
        $DriverOrderDocumentTableTable.$converterstatus,
      );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteUrlMeta = const VerificationMeta(
    'remoteUrl',
  );
  @override
  late final GeneratedColumn<String> remoteUrl = GeneratedColumn<String>(
    'remote_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    orderId,
    title,
    localPath,
    mimeType,
    sizeBytes,
    status,
    remoteId,
    remoteUrl,
    lastError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'driver_order_document_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriverOrderDocumentTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('remote_url')) {
      context.handle(
        _remoteUrlMeta,
        remoteUrl.isAcceptableOrUnknown(data['remote_url']!, _remoteUrlMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  DriverOrderDocumentTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriverOrderDocumentTableData(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      status: $DriverOrderDocumentTableTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      remoteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_url'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DriverOrderDocumentTableTable createAlias(String alias) {
    return $DriverOrderDocumentTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LocalDocumentStatus, int, int> $converterstatus =
      const EnumIndexConverter<LocalDocumentStatus>(LocalDocumentStatus.values);
}

class DriverOrderDocumentTableData extends DataClass
    implements Insertable<DriverOrderDocumentTableData> {
  final String localId;
  final String orderId;
  final String title;
  final String localPath;
  final String mimeType;
  final int sizeBytes;
  final LocalDocumentStatus status;
  final String? remoteId;
  final String? remoteUrl;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DriverOrderDocumentTableData({
    required this.localId,
    required this.orderId,
    required this.title,
    required this.localPath,
    required this.mimeType,
    required this.sizeBytes,
    required this.status,
    this.remoteId,
    this.remoteUrl,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['order_id'] = Variable<String>(orderId);
    map['title'] = Variable<String>(title);
    map['local_path'] = Variable<String>(localPath);
    map['mime_type'] = Variable<String>(mimeType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    {
      map['status'] = Variable<int>(
        $DriverOrderDocumentTableTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DriverOrderDocumentTableCompanion toCompanion(bool nullToAbsent) {
    return DriverOrderDocumentTableCompanion(
      localId: Value(localId),
      orderId: Value(orderId),
      title: Value(title),
      localPath: Value(localPath),
      mimeType: Value(mimeType),
      sizeBytes: Value(sizeBytes),
      status: Value(status),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriverOrderDocumentTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriverOrderDocumentTableData(
      localId: serializer.fromJson<String>(json['localId']),
      orderId: serializer.fromJson<String>(json['orderId']),
      title: serializer.fromJson<String>(json['title']),
      localPath: serializer.fromJson<String>(json['localPath']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      status: $DriverOrderDocumentTableTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      remoteUrl: serializer.fromJson<String?>(json['remoteUrl']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'orderId': serializer.toJson<String>(orderId),
      'title': serializer.toJson<String>(title),
      'localPath': serializer.toJson<String>(localPath),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'status': serializer.toJson<int>(
        $DriverOrderDocumentTableTable.$converterstatus.toJson(status),
      ),
      'remoteId': serializer.toJson<String?>(remoteId),
      'remoteUrl': serializer.toJson<String?>(remoteUrl),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriverOrderDocumentTableData copyWith({
    String? localId,
    String? orderId,
    String? title,
    String? localPath,
    String? mimeType,
    int? sizeBytes,
    LocalDocumentStatus? status,
    Value<String?> remoteId = const Value.absent(),
    Value<String?> remoteUrl = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DriverOrderDocumentTableData(
    localId: localId ?? this.localId,
    orderId: orderId ?? this.orderId,
    title: title ?? this.title,
    localPath: localPath ?? this.localPath,
    mimeType: mimeType ?? this.mimeType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    status: status ?? this.status,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DriverOrderDocumentTableData copyWithCompanion(
    DriverOrderDocumentTableCompanion data,
  ) {
    return DriverOrderDocumentTableData(
      localId: data.localId.present ? data.localId.value : this.localId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      title: data.title.present ? data.title.value : this.title,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      status: data.status.present ? data.status.value : this.status,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriverOrderDocumentTableData(')
          ..write('localId: $localId, ')
          ..write('orderId: $orderId, ')
          ..write('title: $title, ')
          ..write('localPath: $localPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('status: $status, ')
          ..write('remoteId: $remoteId, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    orderId,
    title,
    localPath,
    mimeType,
    sizeBytes,
    status,
    remoteId,
    remoteUrl,
    lastError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriverOrderDocumentTableData &&
          other.localId == this.localId &&
          other.orderId == this.orderId &&
          other.title == this.title &&
          other.localPath == this.localPath &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.status == this.status &&
          other.remoteId == this.remoteId &&
          other.remoteUrl == this.remoteUrl &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DriverOrderDocumentTableCompanion
    extends UpdateCompanion<DriverOrderDocumentTableData> {
  final Value<String> localId;
  final Value<String> orderId;
  final Value<String> title;
  final Value<String> localPath;
  final Value<String> mimeType;
  final Value<int> sizeBytes;
  final Value<LocalDocumentStatus> status;
  final Value<String?> remoteId;
  final Value<String?> remoteUrl;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DriverOrderDocumentTableCompanion({
    this.localId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.title = const Value.absent(),
    this.localPath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.status = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriverOrderDocumentTableCompanion.insert({
    required String localId,
    required String orderId,
    required String title,
    required String localPath,
    required String mimeType,
    required int sizeBytes,
    required LocalDocumentStatus status,
    this.remoteId = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       orderId = Value(orderId),
       title = Value(title),
       localPath = Value(localPath),
       mimeType = Value(mimeType),
       sizeBytes = Value(sizeBytes),
       status = Value(status);
  static Insertable<DriverOrderDocumentTableData> custom({
    Expression<String>? localId,
    Expression<String>? orderId,
    Expression<String>? title,
    Expression<String>? localPath,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<int>? status,
    Expression<String>? remoteId,
    Expression<String>? remoteUrl,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (orderId != null) 'order_id': orderId,
      if (title != null) 'title': title,
      if (localPath != null) 'local_path': localPath,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (status != null) 'status': status,
      if (remoteId != null) 'remote_id': remoteId,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriverOrderDocumentTableCompanion copyWith({
    Value<String>? localId,
    Value<String>? orderId,
    Value<String>? title,
    Value<String>? localPath,
    Value<String>? mimeType,
    Value<int>? sizeBytes,
    Value<LocalDocumentStatus>? status,
    Value<String?>? remoteId,
    Value<String?>? remoteUrl,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DriverOrderDocumentTableCompanion(
      localId: localId ?? this.localId,
      orderId: orderId ?? this.orderId,
      title: title ?? this.title,
      localPath: localPath ?? this.localPath,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      remoteId: remoteId ?? this.remoteId,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $DriverOrderDocumentTableTable.$converterstatus.toSql(status.value),
      );
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (remoteUrl.present) {
      map['remote_url'] = Variable<String>(remoteUrl.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriverOrderDocumentTableCompanion(')
          ..write('localId: $localId, ')
          ..write('orderId: $orderId, ')
          ..write('title: $title, ')
          ..write('localPath: $localPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('status: $status, ')
          ..write('remoteId: $remoteId, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DriverProfileTableTable driverProfileTable =
      $DriverProfileTableTable(this);
  late final $DriverCurrentOrderTableTable driverCurrentOrderTable =
      $DriverCurrentOrderTableTable(this);
  late final $DriverOrderDetailsTableTable driverOrderDetailsTable =
      $DriverOrderDetailsTableTable(this);
  late final $DriverOrderDocumentTableTable driverOrderDocumentTable =
      $DriverOrderDocumentTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    driverProfileTable,
    driverCurrentOrderTable,
    driverOrderDetailsTable,
    driverOrderDocumentTable,
  ];
}

typedef $$DriverProfileTableTableCreateCompanionBuilder =
    DriverProfileTableCompanion Function({
      required String key,
      required String firstName,
      required String lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> companyInternalId,
      Value<String?> driverCode,
      Value<DateTime> updatedAt,
      Value<DateTime?> medicalExamExpiry,
      Value<DateTime?> psychologicalExamExpiry,
      Value<DateTime?> tachographCardExpiry,
      Value<DateTime?> licenseExpiry,
      Value<DateTime?> visaExpiry,
      Value<DateTime?> workPermitExpiry,
      Value<DateTime?> residenceCardExpiry,
      Value<DateTime?> driverCertificateExpiry,
      Value<int> rowid,
    });
typedef $$DriverProfileTableTableUpdateCompanionBuilder =
    DriverProfileTableCompanion Function({
      Value<String> key,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> companyInternalId,
      Value<String?> driverCode,
      Value<DateTime> updatedAt,
      Value<DateTime?> medicalExamExpiry,
      Value<DateTime?> psychologicalExamExpiry,
      Value<DateTime?> tachographCardExpiry,
      Value<DateTime?> licenseExpiry,
      Value<DateTime?> visaExpiry,
      Value<DateTime?> workPermitExpiry,
      Value<DateTime?> residenceCardExpiry,
      Value<DateTime?> driverCertificateExpiry,
      Value<int> rowid,
    });

class $$DriverProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriverProfileTableTable> {
  $$DriverProfileTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyInternalId => $composableBuilder(
    column: $table.companyInternalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driverCode => $composableBuilder(
    column: $table.driverCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get medicalExamExpiry => $composableBuilder(
    column: $table.medicalExamExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get psychologicalExamExpiry => $composableBuilder(
    column: $table.psychologicalExamExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tachographCardExpiry => $composableBuilder(
    column: $table.tachographCardExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get licenseExpiry => $composableBuilder(
    column: $table.licenseExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get visaExpiry => $composableBuilder(
    column: $table.visaExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get workPermitExpiry => $composableBuilder(
    column: $table.workPermitExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get residenceCardExpiry => $composableBuilder(
    column: $table.residenceCardExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get driverCertificateExpiry => $composableBuilder(
    column: $table.driverCertificateExpiry,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriverProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriverProfileTableTable> {
  $$DriverProfileTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyInternalId => $composableBuilder(
    column: $table.companyInternalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driverCode => $composableBuilder(
    column: $table.driverCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get medicalExamExpiry => $composableBuilder(
    column: $table.medicalExamExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get psychologicalExamExpiry => $composableBuilder(
    column: $table.psychologicalExamExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tachographCardExpiry => $composableBuilder(
    column: $table.tachographCardExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get licenseExpiry => $composableBuilder(
    column: $table.licenseExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get visaExpiry => $composableBuilder(
    column: $table.visaExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get workPermitExpiry => $composableBuilder(
    column: $table.workPermitExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get residenceCardExpiry => $composableBuilder(
    column: $table.residenceCardExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get driverCertificateExpiry => $composableBuilder(
    column: $table.driverCertificateExpiry,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriverProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriverProfileTableTable> {
  $$DriverProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get companyInternalId => $composableBuilder(
    column: $table.companyInternalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driverCode => $composableBuilder(
    column: $table.driverCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get medicalExamExpiry => $composableBuilder(
    column: $table.medicalExamExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get psychologicalExamExpiry => $composableBuilder(
    column: $table.psychologicalExamExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tachographCardExpiry => $composableBuilder(
    column: $table.tachographCardExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get licenseExpiry => $composableBuilder(
    column: $table.licenseExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get visaExpiry => $composableBuilder(
    column: $table.visaExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get workPermitExpiry => $composableBuilder(
    column: $table.workPermitExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get residenceCardExpiry => $composableBuilder(
    column: $table.residenceCardExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get driverCertificateExpiry => $composableBuilder(
    column: $table.driverCertificateExpiry,
    builder: (column) => column,
  );
}

class $$DriverProfileTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriverProfileTableTable,
          DriverProfileTableData,
          $$DriverProfileTableTableFilterComposer,
          $$DriverProfileTableTableOrderingComposer,
          $$DriverProfileTableTableAnnotationComposer,
          $$DriverProfileTableTableCreateCompanionBuilder,
          $$DriverProfileTableTableUpdateCompanionBuilder,
          (
            DriverProfileTableData,
            BaseReferences<
              _$AppDatabase,
              $DriverProfileTableTable,
              DriverProfileTableData
            >,
          ),
          DriverProfileTableData,
          PrefetchHooks Function()
        > {
  $$DriverProfileTableTableTableManager(
    _$AppDatabase db,
    $DriverProfileTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriverProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriverProfileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriverProfileTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> companyInternalId = const Value.absent(),
                Value<String?> driverCode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> medicalExamExpiry = const Value.absent(),
                Value<DateTime?> psychologicalExamExpiry = const Value.absent(),
                Value<DateTime?> tachographCardExpiry = const Value.absent(),
                Value<DateTime?> licenseExpiry = const Value.absent(),
                Value<DateTime?> visaExpiry = const Value.absent(),
                Value<DateTime?> workPermitExpiry = const Value.absent(),
                Value<DateTime?> residenceCardExpiry = const Value.absent(),
                Value<DateTime?> driverCertificateExpiry = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriverProfileTableCompanion(
                key: key,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                companyInternalId: companyInternalId,
                driverCode: driverCode,
                updatedAt: updatedAt,
                medicalExamExpiry: medicalExamExpiry,
                psychologicalExamExpiry: psychologicalExamExpiry,
                tachographCardExpiry: tachographCardExpiry,
                licenseExpiry: licenseExpiry,
                visaExpiry: visaExpiry,
                workPermitExpiry: workPermitExpiry,
                residenceCardExpiry: residenceCardExpiry,
                driverCertificateExpiry: driverCertificateExpiry,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String firstName,
                required String lastName,
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> companyInternalId = const Value.absent(),
                Value<String?> driverCode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> medicalExamExpiry = const Value.absent(),
                Value<DateTime?> psychologicalExamExpiry = const Value.absent(),
                Value<DateTime?> tachographCardExpiry = const Value.absent(),
                Value<DateTime?> licenseExpiry = const Value.absent(),
                Value<DateTime?> visaExpiry = const Value.absent(),
                Value<DateTime?> workPermitExpiry = const Value.absent(),
                Value<DateTime?> residenceCardExpiry = const Value.absent(),
                Value<DateTime?> driverCertificateExpiry = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriverProfileTableCompanion.insert(
                key: key,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                companyInternalId: companyInternalId,
                driverCode: driverCode,
                updatedAt: updatedAt,
                medicalExamExpiry: medicalExamExpiry,
                psychologicalExamExpiry: psychologicalExamExpiry,
                tachographCardExpiry: tachographCardExpiry,
                licenseExpiry: licenseExpiry,
                visaExpiry: visaExpiry,
                workPermitExpiry: workPermitExpiry,
                residenceCardExpiry: residenceCardExpiry,
                driverCertificateExpiry: driverCertificateExpiry,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriverProfileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriverProfileTableTable,
      DriverProfileTableData,
      $$DriverProfileTableTableFilterComposer,
      $$DriverProfileTableTableOrderingComposer,
      $$DriverProfileTableTableAnnotationComposer,
      $$DriverProfileTableTableCreateCompanionBuilder,
      $$DriverProfileTableTableUpdateCompanionBuilder,
      (
        DriverProfileTableData,
        BaseReferences<
          _$AppDatabase,
          $DriverProfileTableTable,
          DriverProfileTableData
        >,
      ),
      DriverProfileTableData,
      PrefetchHooks Function()
    >;
typedef $$DriverCurrentOrderTableTableCreateCompanionBuilder =
    DriverCurrentOrderTableCompanion Function({
      required String key,
      required String id,
      required String ztNumber,
      required String status,
      Value<String?> fromCountry,
      Value<String?> toCountry,
      Value<DateTime?> loadingDate,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DriverCurrentOrderTableTableUpdateCompanionBuilder =
    DriverCurrentOrderTableCompanion Function({
      Value<String> key,
      Value<String> id,
      Value<String> ztNumber,
      Value<String> status,
      Value<String?> fromCountry,
      Value<String?> toCountry,
      Value<DateTime?> loadingDate,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DriverCurrentOrderTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriverCurrentOrderTableTable> {
  $$DriverCurrentOrderTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ztNumber => $composableBuilder(
    column: $table.ztNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromCountry => $composableBuilder(
    column: $table.fromCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCountry => $composableBuilder(
    column: $table.toCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loadingDate => $composableBuilder(
    column: $table.loadingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriverCurrentOrderTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriverCurrentOrderTableTable> {
  $$DriverCurrentOrderTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ztNumber => $composableBuilder(
    column: $table.ztNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromCountry => $composableBuilder(
    column: $table.fromCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCountry => $composableBuilder(
    column: $table.toCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loadingDate => $composableBuilder(
    column: $table.loadingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriverCurrentOrderTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriverCurrentOrderTableTable> {
  $$DriverCurrentOrderTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ztNumber =>
      $composableBuilder(column: $table.ztNumber, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get fromCountry => $composableBuilder(
    column: $table.fromCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toCountry =>
      $composableBuilder(column: $table.toCountry, builder: (column) => column);

  GeneratedColumn<DateTime> get loadingDate => $composableBuilder(
    column: $table.loadingDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DriverCurrentOrderTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriverCurrentOrderTableTable,
          DriverCurrentOrderTableData,
          $$DriverCurrentOrderTableTableFilterComposer,
          $$DriverCurrentOrderTableTableOrderingComposer,
          $$DriverCurrentOrderTableTableAnnotationComposer,
          $$DriverCurrentOrderTableTableCreateCompanionBuilder,
          $$DriverCurrentOrderTableTableUpdateCompanionBuilder,
          (
            DriverCurrentOrderTableData,
            BaseReferences<
              _$AppDatabase,
              $DriverCurrentOrderTableTable,
              DriverCurrentOrderTableData
            >,
          ),
          DriverCurrentOrderTableData,
          PrefetchHooks Function()
        > {
  $$DriverCurrentOrderTableTableTableManager(
    _$AppDatabase db,
    $DriverCurrentOrderTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriverCurrentOrderTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DriverCurrentOrderTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriverCurrentOrderTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> ztNumber = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> fromCountry = const Value.absent(),
                Value<String?> toCountry = const Value.absent(),
                Value<DateTime?> loadingDate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriverCurrentOrderTableCompanion(
                key: key,
                id: id,
                ztNumber: ztNumber,
                status: status,
                fromCountry: fromCountry,
                toCountry: toCountry,
                loadingDate: loadingDate,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String id,
                required String ztNumber,
                required String status,
                Value<String?> fromCountry = const Value.absent(),
                Value<String?> toCountry = const Value.absent(),
                Value<DateTime?> loadingDate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriverCurrentOrderTableCompanion.insert(
                key: key,
                id: id,
                ztNumber: ztNumber,
                status: status,
                fromCountry: fromCountry,
                toCountry: toCountry,
                loadingDate: loadingDate,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriverCurrentOrderTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriverCurrentOrderTableTable,
      DriverCurrentOrderTableData,
      $$DriverCurrentOrderTableTableFilterComposer,
      $$DriverCurrentOrderTableTableOrderingComposer,
      $$DriverCurrentOrderTableTableAnnotationComposer,
      $$DriverCurrentOrderTableTableCreateCompanionBuilder,
      $$DriverCurrentOrderTableTableUpdateCompanionBuilder,
      (
        DriverCurrentOrderTableData,
        BaseReferences<
          _$AppDatabase,
          $DriverCurrentOrderTableTable,
          DriverCurrentOrderTableData
        >,
      ),
      DriverCurrentOrderTableData,
      PrefetchHooks Function()
    >;
typedef $$DriverOrderDetailsTableTableCreateCompanionBuilder =
    DriverOrderDetailsTableCompanion Function({
      required String id,
      Value<String?> ztNumber,
      Value<String?> status,
      Value<String?> vehiclePlate,
      Value<String?> trailerPlate,
      Value<String?> clientName,
      Value<String?> fromCountry,
      Value<String?> fromAddress,
      Value<String?> toCountry,
      Value<String?> toAddress,
      Value<int?> cargoWeightKg,
      Value<DateTime?> loadingDate,
      Value<String?> cargoDescription,
      Value<bool?> temperatureSensitive,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DriverOrderDetailsTableTableUpdateCompanionBuilder =
    DriverOrderDetailsTableCompanion Function({
      Value<String> id,
      Value<String?> ztNumber,
      Value<String?> status,
      Value<String?> vehiclePlate,
      Value<String?> trailerPlate,
      Value<String?> clientName,
      Value<String?> fromCountry,
      Value<String?> fromAddress,
      Value<String?> toCountry,
      Value<String?> toAddress,
      Value<int?> cargoWeightKg,
      Value<DateTime?> loadingDate,
      Value<String?> cargoDescription,
      Value<bool?> temperatureSensitive,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DriverOrderDetailsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriverOrderDetailsTableTable> {
  $$DriverOrderDetailsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ztNumber => $composableBuilder(
    column: $table.ztNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehiclePlate => $composableBuilder(
    column: $table.vehiclePlate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trailerPlate => $composableBuilder(
    column: $table.trailerPlate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromCountry => $composableBuilder(
    column: $table.fromCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromAddress => $composableBuilder(
    column: $table.fromAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCountry => $composableBuilder(
    column: $table.toCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toAddress => $composableBuilder(
    column: $table.toAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cargoWeightKg => $composableBuilder(
    column: $table.cargoWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loadingDate => $composableBuilder(
    column: $table.loadingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cargoDescription => $composableBuilder(
    column: $table.cargoDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get temperatureSensitive => $composableBuilder(
    column: $table.temperatureSensitive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriverOrderDetailsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriverOrderDetailsTableTable> {
  $$DriverOrderDetailsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ztNumber => $composableBuilder(
    column: $table.ztNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehiclePlate => $composableBuilder(
    column: $table.vehiclePlate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trailerPlate => $composableBuilder(
    column: $table.trailerPlate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromCountry => $composableBuilder(
    column: $table.fromCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromAddress => $composableBuilder(
    column: $table.fromAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCountry => $composableBuilder(
    column: $table.toCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toAddress => $composableBuilder(
    column: $table.toAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cargoWeightKg => $composableBuilder(
    column: $table.cargoWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loadingDate => $composableBuilder(
    column: $table.loadingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cargoDescription => $composableBuilder(
    column: $table.cargoDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get temperatureSensitive => $composableBuilder(
    column: $table.temperatureSensitive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriverOrderDetailsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriverOrderDetailsTableTable> {
  $$DriverOrderDetailsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ztNumber =>
      $composableBuilder(column: $table.ztNumber, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get vehiclePlate => $composableBuilder(
    column: $table.vehiclePlate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trailerPlate => $composableBuilder(
    column: $table.trailerPlate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromCountry => $composableBuilder(
    column: $table.fromCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromAddress => $composableBuilder(
    column: $table.fromAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toCountry =>
      $composableBuilder(column: $table.toCountry, builder: (column) => column);

  GeneratedColumn<String> get toAddress =>
      $composableBuilder(column: $table.toAddress, builder: (column) => column);

  GeneratedColumn<int> get cargoWeightKg => $composableBuilder(
    column: $table.cargoWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get loadingDate => $composableBuilder(
    column: $table.loadingDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cargoDescription => $composableBuilder(
    column: $table.cargoDescription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get temperatureSensitive => $composableBuilder(
    column: $table.temperatureSensitive,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DriverOrderDetailsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriverOrderDetailsTableTable,
          DriverOrderDetailsTableData,
          $$DriverOrderDetailsTableTableFilterComposer,
          $$DriverOrderDetailsTableTableOrderingComposer,
          $$DriverOrderDetailsTableTableAnnotationComposer,
          $$DriverOrderDetailsTableTableCreateCompanionBuilder,
          $$DriverOrderDetailsTableTableUpdateCompanionBuilder,
          (
            DriverOrderDetailsTableData,
            BaseReferences<
              _$AppDatabase,
              $DriverOrderDetailsTableTable,
              DriverOrderDetailsTableData
            >,
          ),
          DriverOrderDetailsTableData,
          PrefetchHooks Function()
        > {
  $$DriverOrderDetailsTableTableTableManager(
    _$AppDatabase db,
    $DriverOrderDetailsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriverOrderDetailsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DriverOrderDetailsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriverOrderDetailsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> ztNumber = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> vehiclePlate = const Value.absent(),
                Value<String?> trailerPlate = const Value.absent(),
                Value<String?> clientName = const Value.absent(),
                Value<String?> fromCountry = const Value.absent(),
                Value<String?> fromAddress = const Value.absent(),
                Value<String?> toCountry = const Value.absent(),
                Value<String?> toAddress = const Value.absent(),
                Value<int?> cargoWeightKg = const Value.absent(),
                Value<DateTime?> loadingDate = const Value.absent(),
                Value<String?> cargoDescription = const Value.absent(),
                Value<bool?> temperatureSensitive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriverOrderDetailsTableCompanion(
                id: id,
                ztNumber: ztNumber,
                status: status,
                vehiclePlate: vehiclePlate,
                trailerPlate: trailerPlate,
                clientName: clientName,
                fromCountry: fromCountry,
                fromAddress: fromAddress,
                toCountry: toCountry,
                toAddress: toAddress,
                cargoWeightKg: cargoWeightKg,
                loadingDate: loadingDate,
                cargoDescription: cargoDescription,
                temperatureSensitive: temperatureSensitive,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> ztNumber = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> vehiclePlate = const Value.absent(),
                Value<String?> trailerPlate = const Value.absent(),
                Value<String?> clientName = const Value.absent(),
                Value<String?> fromCountry = const Value.absent(),
                Value<String?> fromAddress = const Value.absent(),
                Value<String?> toCountry = const Value.absent(),
                Value<String?> toAddress = const Value.absent(),
                Value<int?> cargoWeightKg = const Value.absent(),
                Value<DateTime?> loadingDate = const Value.absent(),
                Value<String?> cargoDescription = const Value.absent(),
                Value<bool?> temperatureSensitive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriverOrderDetailsTableCompanion.insert(
                id: id,
                ztNumber: ztNumber,
                status: status,
                vehiclePlate: vehiclePlate,
                trailerPlate: trailerPlate,
                clientName: clientName,
                fromCountry: fromCountry,
                fromAddress: fromAddress,
                toCountry: toCountry,
                toAddress: toAddress,
                cargoWeightKg: cargoWeightKg,
                loadingDate: loadingDate,
                cargoDescription: cargoDescription,
                temperatureSensitive: temperatureSensitive,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriverOrderDetailsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriverOrderDetailsTableTable,
      DriverOrderDetailsTableData,
      $$DriverOrderDetailsTableTableFilterComposer,
      $$DriverOrderDetailsTableTableOrderingComposer,
      $$DriverOrderDetailsTableTableAnnotationComposer,
      $$DriverOrderDetailsTableTableCreateCompanionBuilder,
      $$DriverOrderDetailsTableTableUpdateCompanionBuilder,
      (
        DriverOrderDetailsTableData,
        BaseReferences<
          _$AppDatabase,
          $DriverOrderDetailsTableTable,
          DriverOrderDetailsTableData
        >,
      ),
      DriverOrderDetailsTableData,
      PrefetchHooks Function()
    >;
typedef $$DriverOrderDocumentTableTableCreateCompanionBuilder =
    DriverOrderDocumentTableCompanion Function({
      required String localId,
      required String orderId,
      required String title,
      required String localPath,
      required String mimeType,
      required int sizeBytes,
      required LocalDocumentStatus status,
      Value<String?> remoteId,
      Value<String?> remoteUrl,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DriverOrderDocumentTableTableUpdateCompanionBuilder =
    DriverOrderDocumentTableCompanion Function({
      Value<String> localId,
      Value<String> orderId,
      Value<String> title,
      Value<String> localPath,
      Value<String> mimeType,
      Value<int> sizeBytes,
      Value<LocalDocumentStatus> status,
      Value<String?> remoteId,
      Value<String?> remoteUrl,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DriverOrderDocumentTableTableFilterComposer
    extends Composer<_$AppDatabase, $DriverOrderDocumentTableTable> {
  $$DriverOrderDocumentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDocumentStatus, LocalDocumentStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DriverOrderDocumentTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DriverOrderDocumentTableTable> {
  $$DriverOrderDocumentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DriverOrderDocumentTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriverOrderDocumentTableTable> {
  $$DriverOrderDocumentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDocumentStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get remoteUrl =>
      $composableBuilder(column: $table.remoteUrl, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DriverOrderDocumentTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriverOrderDocumentTableTable,
          DriverOrderDocumentTableData,
          $$DriverOrderDocumentTableTableFilterComposer,
          $$DriverOrderDocumentTableTableOrderingComposer,
          $$DriverOrderDocumentTableTableAnnotationComposer,
          $$DriverOrderDocumentTableTableCreateCompanionBuilder,
          $$DriverOrderDocumentTableTableUpdateCompanionBuilder,
          (
            DriverOrderDocumentTableData,
            BaseReferences<
              _$AppDatabase,
              $DriverOrderDocumentTableTable,
              DriverOrderDocumentTableData
            >,
          ),
          DriverOrderDocumentTableData,
          PrefetchHooks Function()
        > {
  $$DriverOrderDocumentTableTableTableManager(
    _$AppDatabase db,
    $DriverOrderDocumentTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriverOrderDocumentTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DriverOrderDocumentTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DriverOrderDocumentTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<LocalDocumentStatus> status = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriverOrderDocumentTableCompanion(
                localId: localId,
                orderId: orderId,
                title: title,
                localPath: localPath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                status: status,
                remoteId: remoteId,
                remoteUrl: remoteUrl,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String orderId,
                required String title,
                required String localPath,
                required String mimeType,
                required int sizeBytes,
                required LocalDocumentStatus status,
                Value<String?> remoteId = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriverOrderDocumentTableCompanion.insert(
                localId: localId,
                orderId: orderId,
                title: title,
                localPath: localPath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                status: status,
                remoteId: remoteId,
                remoteUrl: remoteUrl,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DriverOrderDocumentTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriverOrderDocumentTableTable,
      DriverOrderDocumentTableData,
      $$DriverOrderDocumentTableTableFilterComposer,
      $$DriverOrderDocumentTableTableOrderingComposer,
      $$DriverOrderDocumentTableTableAnnotationComposer,
      $$DriverOrderDocumentTableTableCreateCompanionBuilder,
      $$DriverOrderDocumentTableTableUpdateCompanionBuilder,
      (
        DriverOrderDocumentTableData,
        BaseReferences<
          _$AppDatabase,
          $DriverOrderDocumentTableTable,
          DriverOrderDocumentTableData
        >,
      ),
      DriverOrderDocumentTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DriverProfileTableTableTableManager get driverProfileTable =>
      $$DriverProfileTableTableTableManager(_db, _db.driverProfileTable);
  $$DriverCurrentOrderTableTableTableManager get driverCurrentOrderTable =>
      $$DriverCurrentOrderTableTableTableManager(
        _db,
        _db.driverCurrentOrderTable,
      );
  $$DriverOrderDetailsTableTableTableManager get driverOrderDetailsTable =>
      $$DriverOrderDetailsTableTableTableManager(
        _db,
        _db.driverOrderDetailsTable,
      );
  $$DriverOrderDocumentTableTableTableManager get driverOrderDocumentTable =>
      $$DriverOrderDocumentTableTableTableManager(
        _db,
        _db.driverOrderDocumentTable,
      );
}
