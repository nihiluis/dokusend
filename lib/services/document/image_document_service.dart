import 'dart:typed_data';

import 'package:dokusend/database/document.dart';
import 'package:dokusend/services/file_utils.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../utils/logger.dart';
import 'document_file_service.dart';
import 'dart:convert';

class AnalyzeImageResult {
  final int documentId;
  final int imageId;
  final String jobId;

  AnalyzeImageResult({
    required this.documentId,
    required this.imageId,
    required this.jobId,
  });
}

class ImageDocumentService {
  final DocumentMetadataRepository documentMetadataRepository;
  final DocumentJobRepository documentJobRepository;

  ImageDocumentService()
      : documentMetadataRepository = DocumentMetadataRepository(),
        documentJobRepository = DocumentJobRepository();

  Future<AnalyzeImageResult> analyzeImage(
      int documentId, String filepath, Uint8List fileBytes) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${Config.documentUnderstandingApiUrl.value}/api/v1/document/$documentId/image'),
    );

    final filename = FileUtils.getFilename(filepath);

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        fileBytes,
        filename: filename,
      ),
    );

    var response = await request.send();
    logger.i('Upload response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      logger.e(
          'Image upload failed: Status code: ${response.statusCode}, Response body: $responseBody');
      throw UploadException(
          'Upload failed with status: ${response.statusCode}');
    }

    final responseBody = await response.stream.bytesToString();
    final jsonResponse = json.decode(responseBody);

    logger.i('Image uploaded successfully, received response: $jsonResponse');

    final imageId = jsonResponse['imageId'];
    String jobId = jsonResponse['jobId'];

    final originalFilename = FileUtils.getFilename(filepath);
    final processedFilename =
        FileUtils.appendToFilename(originalFilename, '_processed');

    await documentJobRepository.create(jobId, documentId);

    await DocumentFileService.initDocument(documentId);
    await DocumentFileService.copyFileToDocument(
        documentId, originalFilename, filepath);
    await DocumentFileService.saveFileToDocument(
        documentId, processedFilename, fileBytes);

    return AnalyzeImageResult(
      documentId: documentId,
      imageId: imageId,
      jobId: jobId,
    );
  }
}
