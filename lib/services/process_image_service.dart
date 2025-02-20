import 'dart:io';
import 'package:image/image.dart' as img;

class ProcessImageService {
  Future<File> processImage(File inputImage) async {
    try {
      // Read the image
      final bytes = await inputImage.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      
      if (image == null) throw Exception('Failed to decode image');

      // 1. Convert to grayscale
      image = img.grayscale(image);
      
      // 3. Adjust brightness, contrast, and apply convolution for sharpening
      image = img.adjustColor(
        image,
        brightness: 0.1,
        contrast: 1.2,
      );
      
      const sharpenFilter = [ 0, -1,  0,
                      -1,  5, -1,
                       0, -1,  0 ];

      // 4. Apply convolution filter for sharpening
      image = img.convolution(
        image,
        filter: sharpenFilter,
        div: 1,
      );
      

      // Convert back to bytes
      final processedBytes = img.encodeJpg(image, quality: 90);
      
      // Save the processed image
      final tempDir = Directory.systemTemp;
      final processedFile = File('${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await processedFile.writeAsBytes(processedBytes);

      return processedFile;
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }
}
