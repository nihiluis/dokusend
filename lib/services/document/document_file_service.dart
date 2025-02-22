import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class DocumentFileService {
  static Future<FilePickerResult?> pickFile() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
  }

  static Future<String> getDocumentPath(int documentId) async {
    final directory = await getApplicationSupportDirectory();
    return path.join(directory.path, documentId.toString());
  }

  static Future<void> initDocument(int documentId) async {
    final documentPath = await getDocumentPath(documentId);
    await Directory(documentPath).create(recursive: true);
  }

  static Future<void> copyFileToDocument(
      int documentId, String fileName, String sourcePath) async {
    final documentPath = await getDocumentPath(documentId);
    final filePath = path.join(documentPath, fileName);
    await File(sourcePath).copy(filePath);
  }

  static Future<void> saveFileToDocument(
      int documentId, String fileName, Uint8List fileBytes) async {
    final documentPath = await getDocumentPath(documentId);
    final filePath = path.join(documentPath, fileName);
    await File(filePath).writeAsBytes(fileBytes);
  }
}

class UploadException implements Exception {
  final String message;
  UploadException(this.message);

  @override
  String toString() => message;
}
