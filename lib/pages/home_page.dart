import 'package:flutter/material.dart';
import '../services/file_utils.dart';
import 'settings_page.dart';
import 'upload_page.dart';
import '../views/document_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DocumentListState> _documentListKey =
      GlobalKey<DocumentListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              _documentListKey.currentState?.refreshDocuments();
            },
          ),
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () {
              FileUtils.openDocumentDirectory();
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UploadPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: DocumentList(key: _documentListKey),
            ),
          ],
        ),
      ),
    );
  }
}
