import 'dart:io';
import 'package:drift/drift.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/src/core/database/app_database.dart';
import 'package:mobile/src/core/network/connectivity_provider.dart';
import 'package:mobile/src/features/documents/data/transport_order_documents_file_store.dart';
import 'package:mobile/src/features/documents/data/transport_order_documents_local_data_source.dart';
import 'package:mobile/src/features/documents/data/transport_order_documents_repository_impl.dart';
import 'package:mobile/src/features/documents/application/transport_order_documents_provider.dart';
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

  /// Returns `true` if the document was uploaded immediately,
  /// `false` if it was saved locally (offline / server unavailable / tryUploadImmediately=false).
  Future<bool> addDocument({
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
    if (!tryUploadImmediately) return false;
    final isOnline = await ref
        .read(networkStatusControllerProvider.notifier)
        .checkNow(force: true);
    if (!isOnline) return false;

    return await _uploadOne(
      localId: localId,
      repo: repo,
      localDs: localDs,
      swallowNetworkErrors: true,
    );
  }

  Future<void> syncDocument({
    required String localId,
    required String orderId,
  }) async {
    final isOnline = await ref
        .read(networkStatusControllerProvider.notifier)
        .checkNow(force: true);
    if (!isOnline) {
      throw Exception('Brak internetu. Spróbuj ponownie gdy będziesz online.');
    }
    final localDs = ref.read(orderDocumentsLocalDataSourceProvider);
    final repo = ref.read(transportOrderDocumentsRepositoryProvider);
    await _uploadOne(localId: localId, repo: repo, localDs: localDs);
  }

  bool _isOfflineLikeUploadError(Object e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return true;
        case DioExceptionType.unknown:
          return e.error is SocketException;
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
        case DioExceptionType.cancel:
          return false;
      }
    }
    if (e is SocketException) return true;
    return false;
  }

  /// Used to heal older local rows where remoteId stored a different id (e.g. Document.id)
  /// by re-linking them to the server OrderDocument.id when we can match by URL.
  Future<void> linkRemoteToLocal({
    required String localId,
    required String remoteId,
    required String remoteUrl,
  }) async {
    final localDs = ref.read(orderDocumentsLocalDataSourceProvider);
    await localDs.setRemoteLink(
      localId: localId,
      remoteId: remoteId,
      remoteUrl: remoteUrl,
    );
  }

  Future<void> markLocalOnly({required String localId}) async {
    final localDs = ref.read(orderDocumentsLocalDataSourceProvider);
    await localDs.clearRemoteLink(
      localId: localId,
      status: LocalDocumentStatus.localOnly,
    );
  }

  Future<void> deleteLocalDocument({
    required String localId,
    bool deleteFile = true,
  }) async {
    final localDs = ref.read(orderDocumentsLocalDataSourceProvider);
    final row = await localDs.getByLocalId(localId);
    if (row == null) return;

    if (deleteFile) {
      final p = row.localPath.trim();
      if (p.isNotEmpty) {
        try {
          final f = File(p);
          if (await f.exists()) await f.delete();
        } catch (_) {
          // ignore
        }
      }
    }

    await localDs.deleteByLocalId(localId);
  }

  Future<void> deleteRemoteDocument({
    required String orderId,
    required String orderDocumentId,
  }) async {
    final isOnline = await ref
        .read(networkStatusControllerProvider.notifier)
        .checkNow(force: true);
    if (!isOnline) {
      throw Exception('Brak internetu. Nie można usunąć dokumentu z serwera.');
    }
    final repo = ref.read(transportOrderDocumentsRepositoryProvider);
    await repo.deleteForOrder(
      orderId: orderId,
      orderDocumentId: orderDocumentId,
    );
  }

  Future<void> deleteLocalAndRemote({
    required String orderId,
    required String localId,
    required String orderDocumentId,
  }) async {
    await deleteRemoteDocument(
      orderId: orderId,
      orderDocumentId: orderDocumentId,
    );
    await deleteLocalDocument(localId: localId, deleteFile: true);
  }

  Future<bool> _uploadOne({
    required String localId,
    required OrderDocumentsLocalDataSource localDs,
    required dynamic
    repo, // TransportOrderDocumentsRepository (jeśli masz import interfejsu, daj typ)
    bool swallowNetworkErrors = false,
  }) async {
    final row = await localDs.getByLocalId(localId);
    if (row == null) return false;

    // Jeśli już synced lub upload w toku – nie rób nic
    if (row.status == LocalDocumentStatus.synced) return true;
    if (row.status == LocalDocumentStatus.uploading) return false;

    // Brak lokalnego pliku = nie da się wysłać
    if (row.localPath.trim().isEmpty) {
      await localDs.setStatus(
        localId: localId,
        status: LocalDocumentStatus.failed,
        lastError: 'Missing localPath',
      );
      return false;
    }

    await localDs.setStatus(
      localId: localId,
      status: LocalDocumentStatus.uploading,
      lastError: null,
    );

    try {
      await repo.uploadForOrder(
        orderId: row.orderId,
        file: File(row.localPath),
        title: row.title,
      );

      // Po udanym uploadzie traktujemy lokalny dokument jako cache offline:
      // usuń lokalny plik + rekord (żeby na liście został tylko dokument z serwera).
      await deleteLocalDocument(localId: localId, deleteFile: true);

      // Odśwież listę z serwera, żeby dokument pojawił się natychmiast jako zdalny.
      ref.invalidate(transportOrderDocumentsProvider(row.orderId));
      return true;
    } catch (e) {
      if (_isOfflineLikeUploadError(e)) {
        // Brak połączenia / timeout: dokument zostaje lokalnie, bez technicznych błędów w UI.
        await localDs.setStatus(
          localId: localId,
          status: LocalDocumentStatus.localOnly,
          lastError: null,
        );
        if (swallowNetworkErrors) return false;
        throw Exception(
          'Brak połączenia z serwerem. Dokument pozostaje lokalnie.',
        );
      }

      // Zostaw jako lokalny (żeby dalej był dostępny) i pokaż ewentualnie szczegóły w lastError,
      // ale nie przełączaj UI w "błąd synchronizacji".
      await localDs.setStatus(
        localId: localId,
        status: LocalDocumentStatus.localOnly,
        lastError: 'Nie udało się zsynchronizować. Spróbuj ponownie.',
      );
      rethrow;
    }
  }
}
