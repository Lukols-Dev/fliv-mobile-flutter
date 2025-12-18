import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/documents/application/transport_order_documents_provider.dart';
import 'package:mobile/src/features/documents/domain/transport_order_document.dart';
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';

enum DocumentFilter { all, synchronized, local }

enum DocumentStatus { synchronized, localOnly, syncing }

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key, this.orderId, this.ztNumber});

  final String? orderId;
  final String? ztNumber;

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  DocumentFilter _selectedFilter = DocumentFilter.all;

  String _documentTitle(TransportOrderDocument doc) {
    final description = doc.description?.trim();
    if (description != null && description.isNotEmpty) return description;
    final filename = doc.originalFilename?.trim();
    if (filename != null && filename.isNotEmpty) return filename;
    return 'Dokument';
  }

  String _documentSubtitle(TransportOrderDocument doc) {
    final mime = doc.mimeType.trim();
    final size = doc.sizeBytes;
    if (mime.isNotEmpty && size != null) {
      return '$mime • $size B';
    }
    if (mime.isNotEmpty) return mime;
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: null,
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
                  const SizedBox(height: 20),

                  // FILTERS (only when we have an order)
                  if (hasResolvedOrder)
                    Consumer(
                      builder: (context, ref, _) {
                        final orderId = resolvedOrderId;
                        if (orderId.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final docsAsync = ref.watch(
                          transportOrderDocumentsProvider(orderId),
                        );
                        final docs = docsAsync.maybeWhen(
                          data: (d) => d,
                          orElse: () => const [],
                        );

                        final allCount = docs.length;
                        final syncedCount =
                            docs.length; // server docs == synced
                        final localCount = 0;

                        return Row(
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
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DOCUMENTS LIST
            Expanded(
              child: Builder(
                builder: (context) {
                  // When screen is opened from bottom nav (no orderId):
                  // - if no current order => show "assign ZT" window
                  if (widget.orderId == null) {
                    if (currentOrderAsync.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (currentOrder == null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: const [
                              Text(
                                'Brak przypisanego ZT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Aby dodać dokument, najpierw przypisz zlecenie (ZT).',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }

                  if (!hasResolvedOrder) {
                    return const SizedBox.shrink();
                  }

                  final orderId = resolvedOrderId;
                  if (orderId.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final docsAsync = ref.watch(
                    transportOrderDocumentsProvider(orderId),
                  );

                  return docsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) =>
                        Center(child: Text('Błąd pobierania dokumentów: $e')),
                    data: (docs) {
                      if (docs.isEmpty) {
                        return const Center(
                          child: Text('Dodaj pierwszy dokument do zlecenia.'),
                        );
                      }

                      final filtered = switch (_selectedFilter) {
                        DocumentFilter.all => docs,
                        DocumentFilter.synchronized => docs,
                        DocumentFilter.local => const [],
                      };

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text('Brak dokumentów w tym filtrze.'),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final doc = filtered[index];
                          return _DocumentCard(
                            title: _documentTitle(doc),
                            date: _documentSubtitle(doc),
                            status: DocumentStatus.synchronized,
                            t: t,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: hasResolvedOrder
            ? () {
                context.push('/documents/add');
              }
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
                fontSize: 12,
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
    required this.title,
    required this.date,
    required this.status,
    required this.t,
  });

  final String title;
  final String date;
  final DocumentStatus status;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case DocumentStatus.synchronized:
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle_outline;
        statusText = t.documents_status_synchronized;
        break;
      case DocumentStatus.localOnly:
        statusColor = const Color(0xFFFF6B35);
        statusIcon = Icons.eco_outlined;
        statusText = t.documents_status_local_only;
        break;
      case DocumentStatus.syncing:
        statusColor = const Color(0xFF3B82F6);
        statusIcon = Icons.sync;
        statusText = t.documents_status_syncing;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // DOCUMENT ICON
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
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
                  child: Icon(statusIcon, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // DOCUMENT INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
