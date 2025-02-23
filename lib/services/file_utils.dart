import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FileUtils {
  /// Get the filename from
  /// - the path, e.g. /path/to/file.txt -> file.txt
  /// - a file name, e.g. file.txt -> file.txt
  static String getFilename(String inputPath) {
    return path.basename(inputPath);
  }

  static String getFilenameWithoutExtension(String inputPath) {
    return path.basenameWithoutExtension(inputPath);
  }

  static String appendToFilename(String filename, String suffix) {
    final extension = path.extension(filename);
    return '${getFilenameWithoutExtension(filename)}_$suffix$extension';
  }

  static Future<void> openDocumentDirectory() async {
    final path = await getApplicationSupportDirectory();
    await openDirectory(path.path);
  }

  static Future<void> openDirectory(String path) async {
    try {
      final Uri uri = Uri.directory(path);
      if (!await launchUrl(uri)) {
        throw DirectoryException('Could not open directory: $path');
      }
    } catch (e) {
      throw DirectoryException('Failed to open directory: $e');
    }
  }

  static Future<void> writeToFile(String dir, String filename, String content) async {
    final file = File(path.join(dir, filename));
    await file.writeAsString(content);
  }
}

class DirectoryException implements Exception {
  final String message;
  DirectoryException(this.message);
}
