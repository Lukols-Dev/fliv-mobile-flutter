import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';

enum DocumentFilter { all, synchronized, local }

enum DocumentStatus { synchronized, localOnly, syncing }

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key, this.orderId});

  final String? orderId;

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  DocumentFilter _selectedFilter = DocumentFilter.all;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: widget.orderId != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
                ),
                onPressed: () => context.pop(),
              ),
            )
          : null,
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
                  if (widget.orderId != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '#${widget.orderId}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // FILTERS
                  Row(
                    children: [
                      Expanded(
                        child: _FilterChip(
                          label: t.documents_filter_all,
                          count: 8,
                          isSelected: _selectedFilter == DocumentFilter.all,
                          onTap: () => setState(
                            () => _selectedFilter = DocumentFilter.all,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _FilterChip(
                          label: t.documents_filter_synchronized,
                          count: 4,
                          isSelected:
                              _selectedFilter == DocumentFilter.synchronized,
                          onTap: () => setState(
                            () => _selectedFilter = DocumentFilter.synchronized,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _FilterChip(
                          label: t.documents_filter_local,
                          count: 3,
                          isSelected: _selectedFilter == DocumentFilter.local,
                          onTap: () => setState(
                            () => _selectedFilter = DocumentFilter.local,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DOCUMENTS LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  _DocumentCard(
                    title: 'CMR - List przewozowy',
                    date: '12.10.2025 • 10:34',
                    status: DocumentStatus.synchronized,
                    t: t,
                  ),
                  const SizedBox(height: 12),
                  _DocumentCard(
                    title: 'Faktura VAT',
                    date: '12.10.2025 • 10:35',
                    status: DocumentStatus.synchronized,
                    t: t,
                  ),
                  const SizedBox(height: 12),
                  _DocumentCard(
                    title: 'Potwierdzenie dostawy',
                    date: '12.10.2025 • 10:36',
                    status: DocumentStatus.localOnly,
                    t: t,
                    onSync: () {
                      // TODO: Implement sync
                    },
                  ),
                  const SizedBox(height: 12),
                  _DocumentCard(
                    title: 'Dokumentacja celna',
                    date: '12.10.2025 • 10:37',
                    status: DocumentStatus.syncing,
                    t: t,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/documents/add');
        },
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
    this.onSync,
  });

  final String title;
  final String date;
  final DocumentStatus status;
  final AppLocalizations t;
  final VoidCallback? onSync;

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

          // SYNC BUTTON (only for local only)
          if (status == DocumentStatus.localOnly && onSync != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF0F4D46),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: onSync,
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }
}
