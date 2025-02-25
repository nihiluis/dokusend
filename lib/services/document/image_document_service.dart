import 'dart:typed_data';

import 'package:dokusend/database/document_image.dart';
import 'package:dokusend/database/document_metadata.dart';
import 'package:dokusend/database/document_job.dart';
import 'package:dokusend/services/file_utils.dart';
import 'package:dokusend/utils/dedent.dart';
import 'package:dokusend/utils/exceptions.dart';
import 'package:dokusend/utils/markdown.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../utils/logger.dart';
import 'document_file_service.dart';
import 'dart:convert';

class AnalyzeImageResponseBody {
  final int documentId;
  final int imageId;
  final String jobId;

  AnalyzeImageResponseBody({
    required this.documentId,
    required this.imageId,
    required this.jobId,
  });
}

class ImageDataResponseBody {
  final int imageId;
  final int documentId;
  final String? jobId;
  final dynamic representation;
  final String? formattedText;
  final List<String> tags;
  final String? title;
  final String? caption;
  final String? slug;

  ImageDataResponseBody({
    required this.imageId,
    required this.documentId,
    this.jobId,
    this.representation,
    this.formattedText,
    this.tags = const [],
    this.title,
    this.caption,
    this.slug,
  });

  factory ImageDataResponseBody.fromJson(Map<String, dynamic> json) {
    final imageText = json['imageText'] as Map<String, dynamic>;
    return ImageDataResponseBody(
      imageId: json['imageId'],
      documentId: json['documentId'],
      jobId: imageText['jobId'],
      representation: imageText['representation'],
      formattedText: imageText['formattedText'],
      tags: List<String>.from(imageText['tags'] ?? []),
      title: imageText['title'],
      caption: imageText['caption'],
      slug: imageText['slug'],
    );
  }
}

class ImageDocumentService {
  final DocumentMetadataRepository _documentMetadataRepository;
  final DocumentJobRepository _documentJobRepository;
  final DocumentImageRepository _documentImageRepository;

  ImageDocumentService()
      : _documentMetadataRepository = DocumentMetadataRepository(),
        _documentJobRepository = DocumentJobRepository(),
        _documentImageRepository = DocumentImageRepository();

  Future<int> getDocumentImageIdOrThrow(int documentId) async {
    final documentImage =
        await _documentImageRepository.findByDocumentId(documentId);
    if (documentImage == null) {
      throw NotFoundException('Document image not found');
    }
    return documentImage.id;
  }

  /// @return whether the image data was updated.
  Future<bool> checkImageData(int documentId, int imageId) async {
    var documentImage =
        await _documentImageRepository.findByDocumentId(documentId);
    documentImage ??= await _documentImageRepository.create(
        imageId, documentId, DocumentImageStatus.empty);

    if (documentImage.status == DocumentImageStatus.completed) {
      return false;
    }

    final job = await _documentJobRepository.findByDocumentId(documentId);
    if (job == null) {
      throw NotFoundException('Document job not found');
    }
    if (job.status != DocumentJobStatus.completed) {
      throw Exception('Document job is not completed yet');
    }

    final imageData = await apiGetImageData(imageId);
    if (imageData.jobId != job.id) {
      throw Exception('Image job id does not match document job id');
    }

    await _writeImageData(documentId, imageId, imageData);
    return true;
  }

  Future<void> _writeImageData(
      int documentId, int imageId, ImageDataResponseBody imageData) async {
    final documentImage =
        await _documentImageRepository.findByDocumentId(documentId);
    if (documentImage == null) {
      throw NotFoundException('Document image not found');
    }

    await _documentMetadataRepository.updateTitle(
        documentId, imageData.title ?? 'Untitled');
    await _documentMetadataRepository.updateCaption(
        documentId, imageData.caption ?? '');

    final documentPath = await DocumentFileService.getDocumentPath(documentId);
    final formattedText = imageData.formattedText ?? '';
    final slug = imageData.slug ??
        imageData.title?.toLowerCase().replaceAll(' ', '-') ??
        'untitled';
    var markdownHeaders = {
      'title': imageData.title,
      'caption': imageData.caption,
      'slug': slug,
      'tags': imageData.tags.join(', '),
      'documentId': documentId,
      'imageId': imageId,
      'imageCreatedAt': documentImage.createdAt,
    };
    var markdownText =
        createMarkdownHeader(markdownHeaders) + dedent(formattedText);
    await FileUtils.writeToFile(documentPath, '$slug.md', markdownText);

    if (imageData.representation != null) {
      await FileUtils.writeToFile(
          documentPath, '$slug.json', json.encode(imageData.representation));
    }
  }

  Future<AnalyzeImageResponseBody> apiAnalyzeImage(
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

    await _documentJobRepository.create(
        jobId, documentId, DocumentJobStatus.pending);

    await DocumentFileService.initDocument(documentId);
    await DocumentFileService.copyFileToDocument(
        documentId, originalFilename, filepath);
    await DocumentFileService.saveFileToDocument(
        documentId, processedFilename, fileBytes);

    await _documentImageRepository.create(
        imageId, documentId, DocumentImageStatus.empty);

    return AnalyzeImageResponseBody(
      documentId: documentId,
      imageId: imageId,
      jobId: jobId,
    );
  }

  Future<ImageDataResponseBody> apiGetImageData(int imageId) async {
    final response = await http.get(
      Uri.parse(
          '${Config.documentUnderstandingApiUrl.value}/api/v1/image/$imageId'),
    );

    logger.i('Get image data response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      final responseBody = response.body;
      logger.e(
          'Get image data failed: Status code: ${response.statusCode}, Response body: $responseBody');
      throw Exception('Failed to get image data: ${response.statusCode}');
    }

    final jsonResponse = json.decode(response.body);
    logger.i('Image data retrieved successfully');

    return ImageDataResponseBody.fromJson(jsonResponse);
  }
}
