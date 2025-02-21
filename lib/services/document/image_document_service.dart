import 'dart:typed_data';

import 'package:dokusend/services/file_utils.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../utils/logger.dart';
import 'document_file_service.dart';
import 'dart:convert';

class AnalyzeImageResult {
  final String documentId;
  final String imageId;
  final String jobId;

  AnalyzeImageResult({
    required this.documentId,
    required this.imageId,
    required this.jobId,
  });
}

class ImageDocumentService {
  Future<AnalyzeImageResult> analyzeImage(
      String filepath, Uint8List fileBytes) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Config.documentUnderstandingApiUrl.value}/api/v1/image'),
    );

    final filename = FileUtils.getFilename(filepath);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: filename,
      ),
    );

    var response = await request.send();
    logger.i('Upload response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      logger.e('Image upload failed: Status code: ${response.statusCode}');
      throw UploadException(
          'Upload failed with status: ${response.statusCode}');
    }

    final responseBody = await response.stream.bytesToString();
    final jsonResponse = json.decode(responseBody);

    logger.i('Image uploaded successfully');

    final documentId = jsonResponse['documentId'];
    final imageId = jsonResponse['imageId'];
    final jobId = jsonResponse['jobId'];


    final originalFilename = FileUtils.getFilename(filepath);
    final processedFilename =
        FileUtils.appendToFilename(originalFilename, '_processed');

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
