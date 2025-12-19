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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DriverProfileTableTable driverProfileTable =
      $DriverProfileTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [driverProfileTable];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DriverProfileTableTableTableManager get driverProfileTable =>
      $$DriverProfileTableTableTableManager(_db, _db.driverProfileTable);
}
