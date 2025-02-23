import 'package:dokusend/config.dart';
import 'package:dokusend/database/document_job.dart';
import 'package:dokusend/database/document_metadata.dart';
import 'package:dokusend/services/document/document_info.dart';
import 'package:dokusend/services/document/image_document_service.dart';
import 'package:dokusend/services/job_service.dart';
import 'package:dokusend/utils/exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dokusend/utils/logger.dart';
import 'package:uuid/uuid.dart';

class DocumentService {
  final DocumentMetadataRepository _documentMetadataRepository;
  final DocumentJobRepository _documentJobRepository;
  final JobService _jobService;
  final ImageDocumentService _imageDocumentService;

  DocumentService()
      : _documentMetadataRepository = DocumentMetadataRepository(),
        _documentJobRepository = DocumentJobRepository(),
        _jobService = JobService(),
        _imageDocumentService = ImageDocumentService();

  /// @return true if the job was updated
  Future<bool> checkDocumentInfoJob(DocumentInfo documentInfo) async {
    if (documentInfo.isFinished()) {
      return false;
    }

    // First job should have been automatically created when the document was created.
    if (documentInfo.firstJob == null) {
      // Create a failed dummy job
      final jobId = const Uuid().v4();
      await _documentJobRepository.create(
          jobId, documentInfo.metadata.id, DocumentJobStatus.failed);
      final savedJob = await _documentJobRepository.findById(jobId);
      documentInfo.firstJob = savedJob;
      return true;
    }

    if (documentInfo.isPending() || documentInfo.isProcessing()) {
      final remoteJobData =
          await _jobService.getJobData(documentInfo.firstJob!.id);
      if (remoteJobData.status == RemoteJobStatus.failed) {
        await _documentJobRepository.updateStatus(
            documentInfo.firstJob!.id, DocumentJobStatus.failed);
      } else if (remoteJobData.status == RemoteJobStatus.pending) {
        logger.d('Document ${documentInfo.metadata.id} is still pending.');
        return false;
      } else if (remoteJobData.status == RemoteJobStatus.processing) {
        if (!documentInfo.isProcessing()) {
          await _documentJobRepository.updateStatus(
              documentInfo.firstJob!.id, DocumentJobStatus.processing);
        }
        logger.d('Document ${documentInfo.metadata.id} is still processing.');
        return false;
      } else if (remoteJobData.status == RemoteJobStatus.completed) {
        await _documentJobRepository.updateStatus(
            documentInfo.firstJob!.id, DocumentJobStatus.completed);
      }

      return true;
    }

    return false;
  }

  Future<DocumentInfo> getDocumentInfo(int documentId) async {
    final document = await _documentMetadataRepository.findById(documentId);
    final job = await _documentJobRepository.findByDocumentId(documentId);

    if (document == null) {
      throw NotFoundException('Document not found');
    }

    return DocumentInfo(metadata: document, firstJob: job);
  }

  Future<List<DocumentInfo>> getDocumentInfos(
      {int offset = 0, int limit = 20}) async {
    final documentMetadatas = await _documentMetadataRepository.findAll(
      offset: offset,
      limit: limit,
    );
    final documentIds =
        documentMetadatas.map((document) => document.id).toList();
    final jobs = await _documentJobRepository.findByDocumentIdsIn(documentIds);

    final documentInfos = documentMetadatas.map((document) {
      final job =
          jobs.where((job) => job.documentId == document.id).firstOrNull;
      return DocumentInfo(metadata: document, firstJob: job);
    }).toList();
    return documentInfos;
  }

  Future<int> createEmptyDocument(DocumentType documentType) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${Config.documentUnderstandingApiUrl.value}/api/v1/document'),
    );

    var response = await request.send();
    logger.i('Create document response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      logger.e(
          'Create document failed: Status code: ${response.statusCode}, Response body: $responseBody');
      throw Exception(
          'Create document failed with status: ${response.statusCode}');
    }

    final responseBody = await response.stream.bytesToString();
    final jsonResponse = json.decode(responseBody);

    logger.i('Document created successfully, received response: $jsonResponse');

    final documentId = jsonResponse['documentId'];
    if (documentId is! int) {
      throw Exception(
          'Invalid document ID received from server: expected int, got ${documentId.runtimeType}');
    }

    await _documentMetadataRepository.create(documentId, documentType);

    return documentId;
  }
}
