import 'dart:typed_data';

import 'package:dokusend/database/document_metadata.dart';
import 'package:dokusend/services/document/document_service.dart';
import 'package:dokusend/services/document/image_document_service.dart';
import 'package:dokusend/services/process_image_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/logger.dart';
import '../components/button.dart';
import '../components/image_display.dart';
import '../services/document/document_file_service.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late ProcessImageService _processService;
  late ImageDocumentService _imageDocumentService;

  FilePickerResult? pickedFileData;
  Uint8List? processedFileBytes;
  int currentStep = 0;

  bool isUploading = false;
  bool isProcessing = false;
  String selectedDocumentType = 'image';

  @override
  void initState() {
    super.initState();
    _processService = ProcessImageService();
    _imageDocumentService = ImageDocumentService();
  }

  void _updateService(String type) {
    setState(() {
      selectedDocumentType = type;
      pickedFileData = null;
      _imageDocumentService = ImageDocumentService();
    });
  }

  void resetState() {
    setState(() {
      pickedFileData = null;
      processedFileBytes = null;
      currentStep = 0;
      isUploading = false;
      isProcessing = false;
    });
  }

  Future<void> pickFile() async {
    try {
      final result = await DocumentFileService.pickFile();
      if (result != null) {
        setState(() {
          pickedFileData = result;
        });
      }

      await processFile();
    } catch (e, stackTrace) {
      logger.e('Failed to pick and process file',
          error: e, stackTrace: stackTrace);
      _showAlert('Error', 'Failed to pick file.');
    }
  }

  Future<void> processFile() async {
    if (pickedFileData == null) {
      _showAlert('Error', 'Please select a file.');
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
    } catch (e, stackTrace) {
      logger.e('Process file error', error: e, stackTrace: stackTrace);
      _showAlert('Error', 'Failed to process file.');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  /// Currently always creates a new document, not possible to append to existing document.
  Future<void> analyzeDocument() async {
    if (pickedFileData == null) {
      _showAlert('Error', 'Please select a file.');
      return;
    }

    final documentId = await DocumentService().createEmptyDocument(
        selectedDocumentType == 'image' ? DocumentType.image : DocumentType.textFile);

    if (selectedDocumentType == 'image') {
      await analyzeImage(documentId);
    } else {
      await analyzeDocument();
    }
  }

  Future<void> analyzeImage(documentId) async {
    if (pickedFileData == null || processedFileBytes == null) {
      _showAlert('Error', 'Please select a file.');
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      await _imageDocumentService.apiAnalyzeImage(
          documentId, pickedFileData!.files.first.path!, processedFileBytes!);

      _finalizeUpload();
    } catch (e, stackTrace) {
      logger.e('Analyze image error', error: e, stackTrace: stackTrace);
      _showAlert('Error', 'Failed to analyze image.');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void _finalizeUpload() {
    resetState();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
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
          onUpload: analyzeDocument,
          processedFileBytes: processedFileBytes!,
          isUploading: isUploading,
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
  final bool isUploading;

  const FilePreviewView({
    super.key,
    required this.file,
    required this.processedFileBytes,
    required this.onDelete,
    required this.onUpload,
    required this.isUploading,
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
          isLoading: isUploading,
        ),
      ],
    );
  }
}
