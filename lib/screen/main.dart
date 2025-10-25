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

  @override
  void initState() {
    super.initState();
    batch.addListener(_onBatchUpdate);
  }

  @override
  void dispose() {
    batch.removeListener(_onBatchUpdate);
    super.dispose();
  }

  void _onBatchUpdate() {
    setState(() {});
  }

  void _onTranscribePressed() {
    final url = _urlController.text.trim();

    batch.run(url, 'G:\\マイドライブ\\Movie\\');
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
                  enabled: batch.state != BatchStatus.processing,
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'YouTube Video URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: batch.state == BatchStatus.processing
                      ? null
                      : _onTranscribePressed,
                  child: const Text('Transcribe'),
                ),
                const SizedBox(height: 16),
                if (batch.state == BatchStatus.processing)
                  Column(
                    children: [
                      const CircularProgressIndicator(),
                      if (batch.processName != null) ...[
                        const SizedBox(height: 8),
                        Text(batch.processName!),
                      ],
                    ],
                  ),
                if (batch.errorMessage != null)
                  Text(
                    batch.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
