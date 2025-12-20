import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class OrderDocumentsFileStore {
  const OrderDocumentsFileStore();

  static const _uuid = Uuid();

  Future<File> saveAsJpeg({
    required File input,
    required String orderId,
    int quality = 85,
    int? maxWidth,
  }) async {
    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory(
      p.join(baseDir.path, 'fliv', 'orders', orderId, 'documents'),
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final filename = '${_uuid.v4()}.jpg';
    final outPath = p.join(dir.path, filename);

    final result = await FlutterImageCompress.compressAndGetFile(
      input.absolute.path,
      outPath,
      format: CompressFormat.jpeg,
      quality: quality,
      minWidth: maxWidth ?? 0,
      keepExif: true,
    );

    if (result == null) {
      throw Exception('Nie udało się zapisać/skompressować zdjęcia');
    }

    return File(result.path);
  }
}
