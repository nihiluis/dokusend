import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/logger.dart';

class ProcessImageService {
  /// Service class for processing images with various filters and adjustments
  ///
  /// This service provides methods to process images asynchronously using isolates.
  /// The processing includes:
  /// - Converting to grayscale
  /// - Adjusting brightness and contrast
  /// - Applying sharpening filter
  /// 
  /// Usage:
  /// ```dart
  /// final processor = ProcessImageService();
  /// final processedBytes = await processor.processImageAsync('path/to/image.jpg');
  /// ```
  ///
  /// The [processImageAsync] method takes a file path and returns processed image bytes.
  /// Processing is done in a separate isolate to avoid blocking the main thread.
  ///
  /// Throws an [Exception] if image processing fails.

  /// Internal method that handles the actual image processing in an isolate
  /// 
  /// Takes a [File] input and returns processed [Uint8List] bytes.
  /// Applies the following processing steps:
  /// - Resizing to max 900px width
  /// - Grayscale conversion
  /// - Brightness adjustment
  /// - Contrast adjustment 
  /// - JPEG encoding at 90% quality
  ///
  /// Throws if image decoding or processing fails.
  static Future<Uint8List> _processImageIsolate(File inputImage) async {
    try {
      final stopwatch = Stopwatch()..start();
      
      final bytes = await inputImage.readAsBytes();
      logger.d('Reading bytes took: ${stopwatch.elapsedMilliseconds}ms');

      stopwatch.reset();
      img.Image? image = img.decodeImage(bytes);
      
      logger.d('Decoding image took: ${stopwatch.elapsedMilliseconds}ms');
      
      if (image == null) throw Exception('Failed to decode image');

      // Add resize logic
      stopwatch.reset();
      if (image.width > 900) {
        image = img.copyResize(image, width: 900);
        logger.d('Resizing image took: ${stopwatch.elapsedMilliseconds}ms');
      }

      stopwatch.reset();
      image = img.grayscale(image);
      logger.d('Grayscale conversion took: ${stopwatch.elapsedMilliseconds}ms');
      
      stopwatch.reset();
      image = img.adjustColor(
        image,
        brightness: 1.3,
        contrast: 1.7,
      );
      logger.d('Color adjustment took: ${stopwatch.elapsedMilliseconds}ms');

      stopwatch.reset();
      final processedBytes = img.encodeJpg(image, quality: 90);
      logger.d('JPEG encoding took: ${stopwatch.elapsedMilliseconds}ms');
      
      stopwatch.stop();
      return processedBytes;
    } catch (e) {
      logger.e('Failed to process image', error: e);
      throw Exception('Failed to process image: $e');
    }
  }

  Future<Uint8List> processImageAsync(String path) async {
    return compute(_processImageIsolate, File(path));
  }
}
