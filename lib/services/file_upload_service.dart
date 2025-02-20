import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../utils/logger.dart';

abstract class FileUploadService {
  Future<FilePickerResult?> pickFile();
  Future<void> uploadFile(FilePickerResult result);
}

class ImageUploadService extends FileUploadService {
  @override
  Future<FilePickerResult?> pickFile() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
  }

  @override
  Future<void> uploadFile(FilePickerResult result) async {
    logger.i('Starting image upload: ${result.files.first.name}');
    
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Config.documentUnderstandingApiUrl.value}/image'),
    );
    
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        result.files.first.path!,
      ),
    );

    var response = await request.send();
    logger.i('Upload response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      logger.e('Image upload failed: Status code: ${response.statusCode}');
      throw UploadException('Upload failed with status: ${response.statusCode}');
    }
    
    logger.i('Image uploaded successfully');
  }
}

class TextFileUploadService extends FileUploadService {
  @override
  Future<FilePickerResult?> pickFile() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'doc', 'docx', 'pdf'],
    );
  }

  @override
  Future<void> uploadFile(FilePickerResult result) async {
    logger.i('Starting text file upload: ${result.files.first.name}');
    
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Config.documentUnderstandingApiUrl.value}/text'),
    );
    
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        result.files.first.path!,
      ),
    );

    var response = await request.send();
    logger.i('Upload response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      logger.e('Text file upload failed: Status code: ${response.statusCode}');
      throw UploadException('Upload failed with status: ${response.statusCode}');
    }
    
    logger.i('Text file uploaded successfully');
  }
}

class UploadException implements Exception {
  final String message;
  UploadException(this.message);

  @override
  String toString() => message;
} 