import 'package:dokusend/database/document_metadata.dart';
import 'package:dokusend/services/document/document_info.dart';
import 'package:dokusend/services/document/document_service.dart';
import 'package:dokusend/services/document/image_document_service.dart';
import 'package:dokusend/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:dokusend/services/document/document_file_service.dart';
import 'package:dokusend/utils/logger.dart';
import 'package:dokusend/views/document_status_icon.dart';

class DocumentListItem extends StatelessWidget {
  final ValueNotifier<DocumentInfo> _documentInfoNotifier;
  final VoidCallback? onTap;
  final DocumentService documentService;
  final ImageDocumentService imageDocumentService;
  final ValueNotifier<bool> _isLoadingNotifier;

  DocumentListItem({
    super.key,
    required DocumentInfo documentInfo,
    this.onTap,
  })  : _documentInfoNotifier = ValueNotifier(documentInfo.copy()),
        documentService = DocumentService(),
        imageDocumentService = ImageDocumentService(),
        _isLoadingNotifier = ValueNotifier(false) {
    _initializeDocument();
  }

  DocumentInfo get documentInfo => _documentInfoNotifier.value;
  set documentInfo(DocumentInfo value) => _documentInfoNotifier.value = value;

  Future<void> _initializeDocument() async {
    checkRefreshDocumentInfo();
  }

  Future<void> checkRefreshDocumentInfo() async {
    _isLoadingNotifier.value = true;
    logger.d('Checking if document ${documentInfo.metadata.id} needs refresh');
    if (await documentService.checkDocumentInfoJob(documentInfo)) {
      logger.d('Need to refresh document ${documentInfo.metadata.id}');
      documentInfo =
          await documentService.getDocumentInfo(documentInfo.metadata.id);
    }

    if (documentInfo.isCompleted()) {
      if (documentInfo.metadata.type == DocumentType.image) {
        final imageId = await imageDocumentService
            .getDocumentImageIdOrThrow(documentInfo.metadata.id);

        if (await imageDocumentService.checkImageData(
            documentInfo.metadata.id, imageId)) {
          logger.d(
              'Need to refresh document ${documentInfo.metadata.id} through its image $imageId');
          documentInfo =
              await documentService.getDocumentInfo(documentInfo.metadata.id);
        }
      }
    }

    _isLoadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DocumentInfo>(
      valueListenable: _documentInfoNotifier,
      builder: (context, documentInfo, child) {
        return Material(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(
              documentInfo.getDisplayName(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  FormatUtils.formatDateTime(documentInfo.metadata.createdAt!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DocumentStatusIcon(documentInfo: documentInfo),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: () => DocumentFileService.openDocumentIdDirectory(
                      documentInfo.metadata.id),
                  tooltip: 'Open document folder',
                ),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'v${documentInfo.metadata.version}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'id${documentInfo.metadata.id}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
