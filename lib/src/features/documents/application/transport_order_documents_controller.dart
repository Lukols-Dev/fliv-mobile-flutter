import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/src/core/database/app_database.dart';
import 'package:mobile/src/core/network/connectivity_provider.dart';
import 'package:mobile/src/features/documents/data/transport_order_documents_file_store.dart';
import 'package:mobile/src/features/documents/data/transport_order_documents_local_data_source.dart';
import 'package:mobile/src/features/documents/data/transport_order_documents_repository_impl.dart';
import 'package:uuid/uuid.dart';

import '../domain/local_document_status.dart';

const kMaxOrderDocumentBytes = 10 * 1024 * 1024;

final orderDocumentsControllerProvider =
    NotifierProvider<OrderDocumentsController, void>(
      OrderDocumentsController.new,
    );

class OrderDocumentsController extends Notifier<void> {
  static const _uuid = Uuid();
  final _fileStore = const OrderDocumentsFileStore();

  @override
  void build() {}

  Future<void> addDocument({
    required String orderId,
    required XFile pickedImage,
    required String title,
    bool tryUploadImmediately =
        true, // możesz ustawić false jeśli chcesz STRICT manual
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw Exception('Nazwa dokumentu jest wymagana');
    }
    if (trimmedTitle.length > 255) {
      throw Exception('Nazwa dokumentu jest za długa (max 255)');
    }

    final localDs = ref.read(orderDocumentsLocalDataSourceProvider);
    final repo = ref.read(transportOrderDocumentsRepositoryProvider);

    // 1) normalizuj + zapisz jako JPG do folderu orderId
    final inputFile = File(pickedImage.path);
    final savedFile = await _fileStore.saveAsJpeg(
      input: inputFile,
      orderId: orderId,
      quality: 85,
      maxWidth: 2200,
    );

    final size = await savedFile.length();
    if (size > kMaxOrderDocumentBytes) {
      throw Exception(
        'Plik jest za duży (max ${kMaxOrderDocumentBytes ~/ (1024 * 1024)}MB)',
      );
    }
    const mimeType = 'image/jpeg';

    // 2) zapisz metadane w Drift jako localOnly
    final localId = _uuid.v4();
    await localDs.upsert(
      DriverOrderDocumentTableCompanion.insert(
        localId: localId,
        orderId: orderId,
        title: trimmedTitle,
        localPath: savedFile.path,
        mimeType: mimeType,
        sizeBytes: size,
        status: LocalDocumentStatus.localOnly,
        updatedAt: Value(DateTime.now()),
      ),
    );

    // 3) opcjonalnie spróbuj wysłać od razu (jeśli online)
    if (!tryUploadImmediately) return;
    if (ref.read(isOfflineProvider)) return;

    await _uploadOne(localId: localId, repo: repo, localDs: localDs);
  }

  Future<void> syncDocument({
    required String localId,
    required String orderId,
  }) async {
    if (ref.read(isOfflineProvider)) {
      throw Exception('Brak internetu. Spróbuj ponownie gdy będziesz online.');
    }
    final localDs = ref.read(orderDocumentsLocalDataSourceProvider);
    final repo = ref.read(transportOrderDocumentsRepositoryProvider);
    await _uploadOne(localId: localId, repo: repo, localDs: localDs);
  }

  Future<void> _uploadOne({
    required String localId,
    required OrderDocumentsLocalDataSource localDs,
    required dynamic
    repo, // TransportOrderDocumentsRepository (jeśli masz import interfejsu, daj typ)
  }) async {
    final row = await localDs.getByLocalId(localId);
    if (row == null) return;

    // Jeśli już synced lub upload w toku – nie rób nic
    if (row.status == LocalDocumentStatus.synced) return;
    if (row.status == LocalDocumentStatus.uploading) return;

    // Brak lokalnego pliku = nie da się wysłać
    if (row.localPath.trim().isEmpty) {
      await localDs.setStatus(
        localId: localId,
        status: LocalDocumentStatus.failed,
        lastError: 'Missing localPath',
      );
      return;
    }

    await localDs.setStatus(
      localId: localId,
      status: LocalDocumentStatus.uploading,
      lastError: null,
    );

    try {
      final uploaded = await repo.uploadForOrder(
        orderId: row.orderId,
        file: File(row.localPath),
        title: row.title,
      );

      await localDs.setStatus(
        localId: localId,
        status: LocalDocumentStatus.synced,
        remoteId: uploaded.id,
        remoteUrl: uploaded.url,
        lastError: null,
      );
    } catch (e) {
      await localDs.setStatus(
        localId: localId,
        status: LocalDocumentStatus.failed,
        lastError: e.toString(),
      );
      rethrow;
    }
  }
}
