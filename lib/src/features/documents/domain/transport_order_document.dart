class TransportOrderDocument {
  const TransportOrderDocument({
    required this.id,
    required this.url,
    required this.mimeType,
    this.sizeBytes,
    this.originalFilename,
    this.description,
  });

  final String id;
  final String url;
  final String mimeType;
  final int? sizeBytes;
  final String? originalFilename;
  final String? description;
}
