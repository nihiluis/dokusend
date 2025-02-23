import 'package:flutter/material.dart';
import 'package:dokusend/services/document/document_info.dart';

class DocumentStatusIcon extends StatelessWidget {
  final DocumentInfo documentInfo;
  final double size;

  const DocumentStatusIcon({
    super.key,
    required this.documentInfo,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: documentInfo.getStatusDescription(),
      child: Icon(
        documentInfo.getStatusIcon(),
        size: size,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
} 