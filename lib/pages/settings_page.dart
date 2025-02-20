import 'package:flutter/material.dart';
import '../config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _apiUrlController;

  @override
  void initState() {
    super.initState();
    _apiUrlController = TextEditingController(text: Config.documentUnderstandingApiUrl.value);
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    super.dispose();
  }

  void _updateApiUrl() {
    if (_apiUrlController.text.isNotEmpty) {
      Config.documentUnderstandingApiUrl.value = _apiUrlController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API URL updated')),
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
                      controller: _apiUrlController,
                      decoration: const InputDecoration(
                        labelText: 'API URL',
                        hintText: 'Enter the API URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _updateApiUrl,
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