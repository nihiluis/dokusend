import 'dart:io';
import 'dart:typed_data';

import 'package:dokusend/services/process_image_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/file_upload_service.dart';
import '../utils/logger.dart';
import '../components/button.dart';
import '../components/image_display.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late FileUploadService _uploadService;
  late ProcessImageService _processService;

  FilePickerResult? pickedFileData;
  Uint8List? processedFileBytes;
  int currentStep = 0;

  bool isUploading = false;
  bool isProcessing = false;
  String selectedDocumentType = 'image';

  @override
  void initState() {
    super.initState();
    _uploadService = ImageUploadService();
    _processService = ProcessImageService();
  }

  void _updateService(String type) {
    setState(() {
      selectedDocumentType = type;
      pickedFileData = null; // Clear selected file when changing type
      _uploadService =
          type == 'image' ? ImageUploadService() : TextFileUploadService();
    });
  }

  Future<void> pickFile() async {
    try {
      final result = await _uploadService.pickFile();
      if (result != null) {
        setState(() {
          pickedFileData = result;
        });
      }

      await processFile();
    } catch (e) {
      _showAlert('Error', 'Failed to pick file: $e');
    }
  }

  Future<void> processFile() async {
    if (pickedFileData == null) {
      _showAlert('Error', 'Please select a file first');
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      final inputFilePath = pickedFileData!.files.first.path!;
      final result = await _processService.processImageAsync(inputFilePath);

      setState(() {
        processedFileBytes = result;
      });
    } catch (e) {
      _showAlert('Error', 'Failed to process file: $e');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> uploadFile() async {
    if (pickedFileData == null) {
      _showAlert('Error', 'Please select a file first');
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      await _uploadService.uploadFile(pickedFileData!);
      _showAlert('Success', 'File uploaded successfully');
      setState(() {
        pickedFileData = null;
      });
    } catch (e) {
      logger.e('Upload error $e');
      _showAlert('Error', 'Failed to upload file: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCurrentStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return FileSelectionView(
          selectedDocumentType: selectedDocumentType,
          onUpdateService: _updateService,
          onPickFile: () {
            pickFile().then((_) {
              if (pickedFileData != null) {
                setState(() => currentStep = 1);
              }
            });
          },
          isLoading: isProcessing,
        );
      case 1:
        return FilePreviewView(
          file: pickedFileData!,
          onDelete: () => setState(() {
            pickedFileData = null;
            processedFileBytes = null;
            currentStep = 0;
          }),
          onUpload: uploadFile,
          processedFileBytes: processedFileBytes!,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class FileSelectionView extends StatelessWidget {
  final String selectedDocumentType;
  final void Function(String) onUpdateService;
  final VoidCallback onPickFile;
  final bool isLoading;

  const FileSelectionView({
    super.key,
    required this.selectedDocumentType,
    required this.onUpdateService,
    required this.onPickFile,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Select a file to scan',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<String>(
              value: 'image',
              groupValue: selectedDocumentType,
              onChanged: (value) => onUpdateService(value!),
            ),
            const Text('Image'),
            const SizedBox(width: 20),
            Radio<String>(
              value: 'text',
              toggleable: false,
              groupValue: selectedDocumentType,
              onChanged: null,
            ),
            const Text('Docx/Pdf'),
          ],
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Pick',
          onPressed: onPickFile,
          isLoading: isLoading,
          variant: ButtonVariant.primary,
        ),
      ],
    );
  }
}

class FilePreviewView extends StatelessWidget {
  final FilePickerResult file;
  final Uint8List processedFileBytes;
  final VoidCallback onDelete;
  final VoidCallback onUpload;

  const FilePreviewView({
    super.key,
    required this.file,
    required this.processedFileBytes,
    required this.onDelete,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ImageDisplay(
          imageBytes: processedFileBytes,
          previewHeight: 300,
          previewWidth: 300,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                file.files.first.name,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Upload',
          onPressed: onUpload,
          variant: ButtonVariant.primary,
        ),
      ],
    );
  }
}
