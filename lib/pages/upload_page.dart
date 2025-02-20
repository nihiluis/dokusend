import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/file_upload_service.dart';
import '../utils/logger.dart';
import '../components/button.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late FileUploadService _uploadService;
  FilePickerResult? selectedFile;
  bool isUploading = false;
  String selectedDocumentType = 'image';

  @override
  void initState() {
    super.initState();
    _uploadService = ImageUploadService();
  }

  void _updateService(String type) {
    setState(() {
      selectedDocumentType = type;
      selectedFile = null; // Clear selected file when changing type
      _uploadService =
          type == 'image' ? ImageUploadService() : TextFileUploadService();
    });
  }

  Future<void> pickFile() async {
    try {
      final result = await _uploadService.pickFile();
      if (result != null) {
        setState(() {
          selectedFile = result;
        });
      }
    } catch (e) {
      _showAlert('Error', 'Failed to pick file: $e');
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) {
      _showAlert('Error', 'Please select a file first');
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      await _uploadService.uploadFile(selectedFile!);
      _showAlert('Success', 'File uploaded successfully');
      setState(() {
        selectedFile = null;
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
              selectedFile == null
                  ? FileSelectionView(
                      selectedDocumentType: selectedDocumentType,
                      onUpdateService: _updateService,
                      onPickFile: pickFile,
                    )
                  : FilePreviewView(
                      file: selectedFile!,
                      onDelete: () => setState(() => selectedFile = null),
                      onProcess: uploadFile,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileSelectionView extends StatelessWidget {
  final String selectedDocumentType;
  final void Function(String) onUpdateService;
  final VoidCallback onPickFile;

  const FileSelectionView({
    super.key,
    required this.selectedDocumentType,
    required this.onUpdateService,
    required this.onPickFile,
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
          variant: ButtonVariant.primary,
        ),
      ],
    );
  }
}

class FilePreviewView extends StatelessWidget {
  final FilePickerResult file;
  final VoidCallback onDelete;
  final VoidCallback onProcess;

  const FilePreviewView({
    super.key,
    required this.file,
    required this.onDelete,
    required this.onProcess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          text: 'Process',
          onPressed: onProcess,
          variant: ButtonVariant.primary,
        ),
      ],
    );
  }
}
