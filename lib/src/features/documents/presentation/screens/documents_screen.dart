import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/network/connectivity_provider.dart';
import 'package:mobile/src/features/documents/application/local_transport_order_documents_provider.dart';
import 'package:mobile/src/features/documents/application/transport_order_documents_controller.dart';
import 'package:mobile/src/features/documents/application/transport_order_documents_provider.dart';
import 'package:mobile/src/features/documents/domain/local_document_status.dart';
import 'package:mobile/src/features/documents/domain/transport_order_document.dart';
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';

enum DocumentFilter { all, synchronized, local }

enum DocumentStatusUi { synchronized, localOnly, syncing, failed }

class _DocItem {
  const _DocItem({
    required this.title,
    required this.subtitle,
    required this.status,
    this.localId,
    this.localPath,
    this.remoteId,
    this.remoteUrl,
    this.lastError,
  });

  final String title;
  final String subtitle;
  final DocumentStatusUi status;

  final String? localId;
  final String? localPath;

  final String? remoteId;
  final String? remoteUrl;

  final String? lastError;

  bool get isLocal => localId != null;
}

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key, this.orderId, this.ztNumber});

  final String? orderId;
  final String? ztNumber;

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  DocumentFilter _selectedFilter = DocumentFilter.all;

  bool _isOfflineLikeRemoteError(Object? e) {
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

  String _subtitleFromCreatedAt(DateTime? dt) {
    if (dt == null) return '-';
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd.$mm.$yyyy • $hh:$min';
  }

  DocumentStatusUi _mapLocalStatus(LocalDocumentStatus s) {
    switch (s) {
      case LocalDocumentStatus.localOnly:
        return DocumentStatusUi.localOnly;
      case LocalDocumentStatus.uploading:
        return DocumentStatusUi.syncing;
      case LocalDocumentStatus.synced:
        return DocumentStatusUi.synchronized;
      case LocalDocumentStatus.failed:
        return DocumentStatusUi.localOnly;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final isOffline = ref.watch(isOfflineProvider);

    final currentOrderAsync = ref.watch(currentDriverOrderProvider);
    final currentOrder = currentOrderAsync.maybeWhen(
      data: (o) => o,
      orElse: () => null,
    );

    final resolvedOrderId = widget.orderId ?? currentOrder?.id;
    final resolvedZtLabel = (widget.ztNumber?.trim().isNotEmpty ?? false)
        ? widget.ztNumber!.trim()
        : (currentOrder?.ztNumber ?? '');

    final hasResolvedOrder =
        resolvedOrderId != null && resolvedOrderId.isNotEmpty;

    Future<void> refresh() async {
      if (!hasResolvedOrder) return;
      ref.invalidate(transportOrderDocumentsProvider(resolvedOrderId));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    t.documents_title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  if (resolvedZtLabel.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '#$resolvedZtLabel',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (isOffline)
                    Text(
                      t.documents_offline_message,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  const SizedBox(height: 12),

                  if (hasResolvedOrder) ...[
                    // Filtry na podstawie scalonej listy (wyliczane niżej)
                    const SizedBox(height: 6),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (widget.orderId == null) {
                    if (currentOrderAsync.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF004F45),
                        ),
                      );
                    }
                    if (currentOrder == null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Align(
                          alignment: Alignment
                              .topCenter, // albo Alignment.center, jak wolisz
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  560, // opcjonalnie, żeby nie było "na pół metra" na tabletach
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      t.documents_no_assigned_zt_title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      t.documents_no_assigned_zt_description,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  if (!hasResolvedOrder) return const SizedBox.shrink();

                  final orderId = resolvedOrderId;
                  final localAsync = ref.watch(
                    localOrderDocumentsProvider(orderId),
                  );

                  final remoteAsync = isOffline
                      ? const AsyncValue.data(<TransportOrderDocument>[])
                      : ref.watch(transportOrderDocumentsProvider(orderId));

                  final localRows = localAsync.maybeWhen(
                    data: (d) => d,
                    orElse: () => const [],
                  );
                  final remoteDocs = remoteAsync.maybeWhen(
                    data: (d) => d,
                    orElse: () => const [],
                  );

                  // de-dupe: jeśli lokalny ma remoteId i serwer też go ma, nie pokazuj serwerowego
                  final localRemoteIds = localRows
                      .map((r) => r.remoteId)
                      .whereType<String>()
                      .toSet();
                  final localRemoteUrls = localRows
                      .map((r) => r.remoteUrl)
                      .whereType<String>()
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toSet();

                  final remoteUnique = remoteDocs
                      .where(
                        (d) =>
                            !localRemoteIds.contains(d.id) &&
                            !localRemoteUrls.contains(d.url.trim()),
                      )
                      .toList();

                  // Heal legacy rows (when upload endpoint returned Document.id instead of OrderDocument.id):
                  // if local has remoteUrl that matches a remote document url, update local.remoteId to remote.id
                  if (!isOffline &&
                      remoteAsync.hasValue &&
                      // remoteDocs.isNotEmpty &&
                      localRows.isNotEmpty) {
                    final remoteByUrl = <String, TransportOrderDocument>{
                      for (final d in remoteDocs) d.url.trim(): d,
                    };
                    final remoteIds = remoteDocs.map((d) => d.id).toSet();
                    final remoteUrls = remoteDocs
                        .map((d) => d.url.trim())
                        .toSet();
                    for (final r in localRows) {
                      final localId = r.localId;
                      final rUrl = (r.remoteUrl ?? '').trim();
                      if (localId.isEmpty) continue;

                      // Reconcile "synced" rows that were deleted on server:
                      // If local says synced but server no longer has this remoteId/url, downgrade to localOnly.
                      if (r.status == LocalDocumentStatus.synced) {
                        final rid = (r.remoteId ?? '').trim();
                        final hasOnServer =
                            (rid.isNotEmpty && remoteIds.contains(rid)) ||
                            (rUrl.isNotEmpty && remoteUrls.contains(rUrl));
                        if (!hasOnServer) {
                          Future.microtask(() {
                            ref
                                .read(orderDocumentsControllerProvider.notifier)
                                .markLocalOnly(localId: localId);
                          });
                          continue;
                        }
                      }

                      // Heal legacy id mismatch (Document.id stored as remoteId)
                      if (rUrl.isEmpty) continue;
                      final match = remoteByUrl[rUrl];
                      if (match == null) continue;
                      if (r.remoteId == match.id) continue;
                      Future.microtask(() {
                        ref
                            .read(orderDocumentsControllerProvider.notifier)
                            .linkRemoteToLocal(
                              localId: localId,
                              remoteId: match.id,
                              remoteUrl: match.url,
                            );
                      });
                    }
                  }

                  final localItems = localRows.map((r) {
                    final statusUi = _mapLocalStatus(r.status);
                    return _DocItem(
                      title: r.title,
                      subtitle: _subtitleFromCreatedAt(r.createdAt),
                      status: statusUi,
                      localId: r.localId,
                      localPath: r.localPath,
                      remoteId: r.remoteId,
                      remoteUrl: r.remoteUrl,
                      lastError: r.lastError,
                    );
                  }).toList();

                  final remoteItems = remoteUnique.map((d) {
                    final title = (d.title?.trim().isNotEmpty ?? false)
                        ? d.title!.trim()
                        : (d.description?.trim().isNotEmpty ?? false)
                        ? d.description!.trim()
                        : (d.originalFilename?.trim().isNotEmpty ?? false)
                        ? d.originalFilename!.trim()
                        : t.documents_default_title;

                    return _DocItem(
                      title: title,
                      subtitle: _subtitleFromCreatedAt(d.createdAt),
                      status: DocumentStatusUi.synchronized,
                      remoteId: d.id,
                      remoteUrl: d.url,
                    );
                  }).toList();

                  final allItems = [...localItems, ...remoteItems];

                  final filtered = switch (_selectedFilter) {
                    DocumentFilter.all => allItems,
                    DocumentFilter.synchronized =>
                      allItems
                          .where(
                            (i) => i.status == DocumentStatusUi.synchronized,
                          )
                          .toList(),
                    DocumentFilter.local =>
                      allItems
                          .where(
                            (i) => i.status != DocumentStatusUi.synchronized,
                          )
                          .toList(),
                  };

                  final allCount = allItems.length;
                  final syncedCount = allItems
                      .where((i) => i.status == DocumentStatusUi.synchronized)
                      .length;
                  final localCount = allItems
                      .where((i) => i.status != DocumentStatusUi.synchronized)
                      .length;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            Expanded(
                              child: _FilterChip(
                                label: t.documents_filter_all,
                                count: allCount,
                                isSelected:
                                    _selectedFilter == DocumentFilter.all,
                                onTap: () => setState(
                                  () => _selectedFilter = DocumentFilter.all,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _FilterChip(
                                label: t.documents_filter_synchronized,
                                count: syncedCount,
                                isSelected:
                                    _selectedFilter ==
                                    DocumentFilter.synchronized,
                                onTap: () => setState(
                                  () => _selectedFilter =
                                      DocumentFilter.synchronized,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _FilterChip(
                                label: t.documents_filter_local,
                                count: localCount,
                                isSelected:
                                    _selectedFilter == DocumentFilter.local,
                                onTap: () => setState(
                                  () => _selectedFilter = DocumentFilter.local,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: refresh,
                          child: filtered.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    const SizedBox(height: 140),
                                    Center(child: Text(t.documents_empty_list)),
                                  ],
                                )
                              : ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final item = filtered[index];
                                    Future<bool> confirmDelete(
                                      String message,
                                    ) async {
                                      final ok = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text(
                                            t.documents_delete_document_title,
                                          ),
                                          content: Text(message),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(false),
                                              child: Text(t.common_cancel),
                                            ),
                                            FilledButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(true),
                                              child: Text(t.common_delete),
                                            ),
                                          ],
                                        ),
                                      );
                                      return ok == true;
                                    }

                                    final canSync =
                                        !isOffline &&
                                        (item.status ==
                                                DocumentStatusUi.localOnly ||
                                            item.status ==
                                                DocumentStatusUi.failed);
                                    final isBusy =
                                        item.status == DocumentStatusUi.syncing;

                                    final onSync =
                                        (item.localId == null || !canSync)
                                        ? null
                                        : () async {
                                            try {
                                              await ref
                                                  .read(
                                                    orderDocumentsControllerProvider
                                                        .notifier,
                                                  )
                                                  .syncDocument(
                                                    localId: item.localId!,
                                                    orderId: orderId,
                                                  );
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(content: Text('$e')),
                                              );
                                            }
                                          };

                                    final onDeleteLocal =
                                        (item.localId == null || isBusy)
                                        ? null
                                        : () async {
                                            if (!await confirmDelete(
                                              t.documents_delete_local_confirm,
                                            ))
                                              return;
                                            try {
                                              await ref
                                                  .read(
                                                    orderDocumentsControllerProvider
                                                        .notifier,
                                                  )
                                                  .deleteLocalDocument(
                                                    localId: item.localId!,
                                                    deleteFile: true,
                                                  );
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(content: Text('$e')),
                                              );
                                            }
                                          };

                                    final onDeleteRemote =
                                        (item.remoteId == null ||
                                            isBusy ||
                                            isOffline)
                                        ? null
                                        : () async {
                                            if (!await confirmDelete(
                                              t.documents_delete_remote_confirm,
                                            ))
                                              return;
                                            try {
                                              await ref
                                                  .read(
                                                    orderDocumentsControllerProvider
                                                        .notifier,
                                                  )
                                                  .deleteRemoteDocument(
                                                    orderId: orderId,
                                                    orderDocumentId:
                                                        item.remoteId!,
                                                  );
                                              ref.invalidate(
                                                transportOrderDocumentsProvider(
                                                  orderId,
                                                ),
                                              );
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(content: Text('$e')),
                                              );
                                            }
                                          };

                                    return _DocumentCard(
                                      item: item,
                                      isOffline: isOffline,
                                      onSync: onSync,
                                      onDeleteLocal: onDeleteLocal,
                                      onDeleteRemote: onDeleteRemote,
                                      t: t,
                                    );
                                  },
                                ),
                        ),
                      ),

                      if (!isOffline && remoteAsync.hasError)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                          child: Text(
                            _isOfflineLikeRemoteError(remoteAsync.error)
                                ? t.documents_offline_error
                                : '${t.documents_fetch_failed}\n${remoteAsync.error}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: hasResolvedOrder
            ? () => context.push(
                '/documents/add?orderId=${Uri.encodeComponent(resolvedOrderId)}',
              )
            : null,
        backgroundColor: const Color(0xFF0F4D46),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5E7EB) : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF111827)
                    : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? const Color(0xFF111827)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.item,
    required this.isOffline,
    required this.onSync,
    required this.onDeleteLocal,
    required this.onDeleteRemote,
    required this.t,
  });

  final _DocItem item;
  final bool isOffline;
  final VoidCallback? onSync;
  final VoidCallback? onDeleteLocal;
  final VoidCallback? onDeleteRemote;
  final AppLocalizations t;

  Future<void> _showActionsSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onSync != null)
                  ListTile(
                    leading: const Icon(
                      Icons.cloud_upload_outlined,
                      color: Color(0xFF0F4D46),
                    ),
                    title: Text(t.documents_sync_action),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      onSync?.call();
                    },
                  ),
                if (onDeleteRemote != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: Text(t.common_delete),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      onDeleteRemote?.call();
                    },
                  ),
                if (onDeleteLocal != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: Text(t.common_delete),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      onDeleteLocal?.call();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPreview(BuildContext context) {
    final localPath = item.localPath?.trim();
    final remoteUrl = item.remoteUrl?.trim();

    if (localPath != null && localPath.isNotEmpty) {
      final f = File(localPath);
      if (f.existsSync()) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _DocumentImagePreviewScreen(
              title: item.title,
              filePath: localPath,
            ),
          ),
        );
        return;
      }
    }

    if (remoteUrl != null && remoteUrl.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              _DocumentImagePreviewScreen(title: item.title, url: remoteUrl),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusBadgeIcon;
    IconData statusRowIcon;
    String statusText;

    switch (item.status) {
      case DocumentStatusUi.synchronized:
        statusColor = const Color(0xFF10B981);
        statusBadgeIcon = Icons.cloud_done_outlined;
        statusRowIcon = Icons.check_circle_outline;
        statusText = t.documents_status_synchronized;
        break;
      case DocumentStatusUi.localOnly:
        statusColor = const Color(0xFFFF6B35);
        statusBadgeIcon = Icons.cloud_off_outlined;
        statusRowIcon = Icons.cloud_off_outlined;
        statusText = t.documents_status_local_only;
        break;
      case DocumentStatusUi.syncing:
        statusColor = const Color(0xFF3B82F6);
        statusBadgeIcon = Icons.sync;
        statusRowIcon = Icons.sync;
        statusText = t.documents_status_syncing;
        break;
      case DocumentStatusUi.failed:
        statusColor = const Color(0xFFEF4444);
        statusBadgeIcon = Icons.error_outline;
        statusRowIcon = Icons.error_outline;
        statusText = t.documents_status_failed;
        break;
    }

    final canSync =
        !isOffline &&
        (item.status == DocumentStatusUi.localOnly ||
            item.status == DocumentStatusUi.failed);
    final isBusy = item.status == DocumentStatusUi.syncing;
    final hasAnyActions =
        (canSync && onSync != null) ||
        (!isBusy && (onDeleteLocal != null || onDeleteRemote != null));

    Widget? thumb;
    if (item.localPath != null && item.localPath!.isNotEmpty) {
      final f = File(item.localPath!);
      if (f.existsSync()) {
        thumb = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(f, width: 48, height: 48, fit: BoxFit.cover),
        );
      }
    }
    thumb ??= (() {
      final u = (item.remoteUrl ?? '').trim();
      if (u.isEmpty) return null;
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          u,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.description_outlined,
                color: Color(0xFF0F4D46),
                size: 24,
              ),
            );
          },
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        ),
      );
    })();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap:
                (thumb != null || (item.remoteUrl?.trim().isNotEmpty ?? false))
                ? () => _openPreview(context)
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      thumb ??
                      const Icon(
                        Icons.description_outlined,
                        color: Color(0xFF0F4D46),
                        size: 24,
                      ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(statusBadgeIcon, size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusRowIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          statusText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((item.lastError ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.lastError!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (item.status == DocumentStatusUi.syncing)
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (hasAnyActions)
            IconButton(
              tooltip: t.documents_options_tooltip,
              onPressed: () => _showActionsSheet(context),
              icon: const Icon(Icons.more_vert),
            ),
        ],
      ),
    );
  }
}

class _DocumentImagePreviewScreen extends StatelessWidget {
  const _DocumentImagePreviewScreen({
    required this.title,
    this.filePath,
    this.url,
  });

  final String title;
  final String? filePath;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    Widget child;

    final local = filePath?.trim();
    if (local != null && local.isNotEmpty) {
      child = Image.file(File(local), fit: BoxFit.contain);
    } else {
      final u = url?.trim() ?? '';
      child = Image.network(
        u,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              '${t.documents_preview_load_failed}\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(minScale: 0.8, maxScale: 4.0, child: child),
        ),
      ),
    );
  }
}
