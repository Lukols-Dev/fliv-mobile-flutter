import 'package:mobile/src/features/documents/domain/local_document_status.dart';

class OrderDocumentItem {
  const OrderDocumentItem({
    required this.localId,
    required this.orderId,
    required this.title,
    required this.status,
    this.localPath,
    this.remoteId,
    this.remoteUrl,
    this.mimeType,
    this.sizeBytes,
    this.originalFilename,
    this.description,
  });

  final String localId;
  final String orderId;

  final String title;
  final LocalDocumentStatus status;

  final String? localPath;
  final String? remoteId;
  final String? remoteUrl;

  final String? mimeType;
  final int? sizeBytes;
  final String? originalFilename;
  final String? description;
}
