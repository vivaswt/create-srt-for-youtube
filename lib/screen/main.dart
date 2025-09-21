import 'dart:io';

import 'package:create_srt_for_youtube/batch/create_srt.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final batch = CreateSrtBatch();
  final TextEditingController _urlController = TextEditingController();

  void _onTranscribePressed() {
    final url = _urlController.text.trim();

    batch.run(url, Platform.environment['GEMINI_API_KEY']!, 'data/');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'YouTube Video URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTranscribePressed,
                  child: const Text('Transcribe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
