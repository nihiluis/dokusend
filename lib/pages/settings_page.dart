import 'package:flutter/material.dart';
import '../config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _documentApiUrlController;
  late TextEditingController _jobApiUrlController;

  @override
  void initState() {
    super.initState();
    _documentApiUrlController =
        TextEditingController(text: Config.documentUnderstandingApiUrl.value);
    _jobApiUrlController = TextEditingController(text: Config.jobApiUrl.value);
  }

  @override
  void dispose() {
    _documentApiUrlController.dispose();
    super.dispose();
  }

  void _updateSettings() {
    if (_documentApiUrlController.text.isNotEmpty) {
      Config.documentUnderstandingApiUrl.value = _documentApiUrlController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API URL updated')),
      );
    }

    if (_jobApiUrlController.text.isNotEmpty) {
      Config.jobApiUrl.value = _jobApiUrlController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job API URL updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.developer_mode,
                  color: Config.devMode ? Colors.green : Colors.grey,
                ),
                title: const Text('Developer Mode'),
                subtitle: Text(
                  Config.devMode ? 'Enabled' : 'Disabled',
                  style: TextStyle(
                    color: Config.devMode ? Colors.green : Colors.grey,
                  ),
                ),
                trailing: Config.devMode
                    ? const Chip(
                        label: Text('DEV'),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Document Understanding API',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _documentApiUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Document API URL',
                        hintText: 'Enter the DocumentAPI URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Job API',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _jobApiUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Job API URL',
                        hintText: 'Enter the Job API URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _updateSettings,
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
