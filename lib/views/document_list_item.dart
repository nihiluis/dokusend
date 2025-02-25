import 'package:dokusend/database/document_metadata.dart';
import 'package:dokusend/services/document/document_info.dart';
import 'package:dokusend/services/document/document_service.dart';
import 'package:dokusend/services/document/image_document_service.dart';
import 'package:dokusend/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:dokusend/services/document/document_file_service.dart';
import 'package:dokusend/utils/logger.dart';
import 'package:dokusend/views/document_status_icon.dart';

class DocumentListItem extends StatefulWidget {
  final DocumentInfo documentInfo;
  final VoidCallback? onTap;

  const DocumentListItem({
    super.key,
    required this.documentInfo,
    this.onTap,
  });

  @override
  State<DocumentListItem> createState() => _DocumentListItemState();
}

class _DocumentListItemState extends State<DocumentListItem> {
  late DocumentInfo _documentInfo;
  final DocumentService _documentService = DocumentService();
  final ImageDocumentService _imageDocumentService = ImageDocumentService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _documentInfo = widget.documentInfo.copy();
    _initializeDocument();
  }

  Future<void> _initializeDocument() async {
    checkRefreshDocumentInfo();
  }

  Future<void> checkRefreshDocumentInfo() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    
    logger.d('Checking if document ${_documentInfo.metadata.id} needs refresh');
    if (await _documentService.checkDocumentInfoJob(_documentInfo)) {
      logger.d('Need to refresh document ${_documentInfo.metadata.id}');
      final updatedInfo = await _documentService.getDocumentInfo(_documentInfo.metadata.id);
      
      if (mounted) {
        setState(() {
          _documentInfo = updatedInfo;
        });
      }

      if (_documentInfo.isCompleted()) {
        if (_documentInfo.metadata.type == DocumentType.image) {
          final imageId = await _imageDocumentService
              .getDocumentImageIdOrThrow(_documentInfo.metadata.id);

          if (await _imageDocumentService.checkImageData(
              _documentInfo.metadata.id, imageId)) {
            logger.d(
                'Need to refresh document ${_documentInfo.metadata.id} through its image $imageId');
            final updatedInfo = await _documentService.getDocumentInfo(_documentInfo.metadata.id);
            
            if (mounted) {
              setState(() {
                _documentInfo = updatedInfo;
              });
            }
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        title: Text(
          _documentInfo.getDisplayName(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              FormatUtils.formatDateTime(_documentInfo.metadata.createdAt!),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isLoading 
                ? const SizedBox(
                    width: 24, 
                    height: 24, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : DocumentStatusIcon(documentInfo: _documentInfo),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.folder_open),
              onPressed: () => DocumentFileService.openDocumentIdDirectory(
                  _documentInfo.metadata.id),
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
                'v${_documentInfo.metadata.version}',
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
                'id${_documentInfo.metadata.id}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
