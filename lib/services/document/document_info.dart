import 'package:dokusend/database/database.dart';
import 'package:flutter/material.dart';
import 'package:dokusend/database/document_job.dart';

/// DocumentInfo contains all the necessary information to display a document in the UI.
class DocumentInfo {
  final DocumentMetadataData metadata;
  DocumentJobData? firstJob;

  DocumentInfo({required this.metadata, required this.firstJob});

  DocumentInfo copy() {
    return DocumentInfo(metadata: metadata.copyWith(), firstJob: firstJob?.copyWith());
  }

  String getDisplayName() {
    if (metadata.name.isNotEmpty) {
      return metadata.name;
    }

    return 'Untitled';
  }

  bool isFinished() {
    return firstJob != null &&
            firstJob!.status == DocumentJobStatus.completed ||
        firstJob!.status == DocumentJobStatus.failed;
  }

  bool isPending() {
    return firstJob != null && firstJob!.status == DocumentJobStatus.pending;
  }

  bool isProcessing() {
    return firstJob != null && firstJob!.status == DocumentJobStatus.processing;
  }

  bool isCompleted() {
    return firstJob != null && firstJob!.status == DocumentJobStatus.completed;
  }

  IconData getStatusIcon() {
    if (firstJob == null) {
      return Icons.description; // Default document icon
    }

    switch (firstJob!.status) {
      case DocumentJobStatus.pending:
        return Icons.pending;
      case DocumentJobStatus.processing:
        return Icons.hourglass_empty;
      case DocumentJobStatus.completed:
        return Icons.check_circle;
      case DocumentJobStatus.failed:
        return Icons.error;
    }
  }

  String getStatusDescription() {
    if (firstJob == null) {
      return 'No job found.';
    }

    return firstJob!.status.name[0].toUpperCase() + firstJob!.status.name.substring(1);
  }
}
