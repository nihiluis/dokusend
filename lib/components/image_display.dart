import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDisplay extends StatelessWidget {
  final Uint8List imageBytes;
  final double previewHeight;
  final double previewWidth;

  const ImageDisplay({
    super.key,
    required this.imageBytes,
    this.previewHeight = 200,
    this.previewWidth = 200,
  });

  Future<void> _openJpgInNativeViewer() async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/preview.jpg';
      
      // Save image to temporary file
      File tempFile = File(tempPath);
      await tempFile.writeAsBytes(imageBytes);

      // Open file with native viewer
      final uri = Uri.file(tempPath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint('Could not launch native viewer');
      }
    } catch (e) {
      debugPrint('Error opening image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openJpgInNativeViewer,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            imageBytes,
            height: previewHeight,
            width: previewWidth,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
