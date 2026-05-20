import '../domain/transport_order_document.dart';

class TransportOrderDocumentDto {
  const TransportOrderDocumentDto({
    required this.id,
    required this.url,
    required this.mimeType,
    this.sizeBytes,
    this.originalFilename,
    this.description,
    this.title,
    this.createdAt,
  });

  final String id;
  final String url;
  final String mimeType;
  final int? sizeBytes;
  final String? originalFilename;
  final String? description;
  final String? title;
  final DateTime? createdAt;

  factory TransportOrderDocumentDto.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return TransportOrderDocumentDto(
      id: json['id'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      sizeBytes: parseInt(json['sizeBytes']),
      originalFilename: json['originalFilename'] as String?,
      description: json['description'] as String?,
      title: json['title'] as String?,
      createdAt: parseDate(json['createdAt']),
    );
  }

  TransportOrderDocument toDomain() => TransportOrderDocument(
    id: id,
    url: url,
    mimeType: mimeType,
    sizeBytes: sizeBytes,
    originalFilename: originalFilename,
    description: description,
    title: title,
    createdAt: createdAt,
  );
}
