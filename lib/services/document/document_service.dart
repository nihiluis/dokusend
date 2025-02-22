import 'package:dokusend/config.dart';
import 'package:dokusend/database/database.dart';
import 'package:dokusend/database/document.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dokusend/utils/logger.dart';

class DocumentService {
  final DocumentMetadataRepository documentMetadataRepository;
  final DocumentJobRepository documentJobRepository;

  DocumentService()
      : documentMetadataRepository = DocumentMetadataRepository(),
        documentJobRepository = DocumentJobRepository();

  Future<int> createEmptyDocument() async {
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
      throw Exception('Invalid document ID received from server: expected int, got ${documentId.runtimeType}');
    }

    await documentMetadataRepository.create(documentId);

    return documentId;
  }
}
