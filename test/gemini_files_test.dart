import 'dart:io';
import 'dart:math';

import 'package:create_srt_for_youtube/api/gemini_files.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('initiateFileUpload', () {
    test('should initiate file upload', () async {
      const fileName =
          'data\\Final Fantasy Tactics_ The Ivalice Chronicles - Everything To Know.mp4';
      final result = await initiateFileUpload(
        fileName,
        Platform.environment['GEMINI_API_KEY']!,
      );
      expect(result, isNotEmpty);
    });
  });

  group('uploadFile', () {
    test('should upload file', () async {
      const fileName =
          'data\\Final Fantasy Tactics_ The Ivalice Chronicles - Everything To Know.mp4';
      const url =
          'https://generativelanguage.googleapis.com/upload/v1beta/files'
          '?upload_id=AAwnv3IXGpBQADqYrJQvZ6GNV2_f7qoM5iCvbngPNxnYNoJ0qtT1yl88uwI6foEO2cjVDWv'
          '-z5XxLurE7rC7LBHM04h2OsJ5n3iIEjtO7Lr9hQ&upload_protocol=resumable';
      final result = await uploadFile(
        fileName,
        url,
        Platform.environment['GEMINI_API_KEY']!,
      );
      print(result);
      expect(result.uri, isNotEmpty);
    });
  });

  group('getFileState', () {
    test('should get file state', () async {
      const fileName = 'files/g1m1yl3o96z4';
      final result = await getFileState(
        fileName,
        Platform.environment['GEMINI_API_KEY']!,
      );
      print(result);
      expect(result, isA<FileState>());
    });
  });
}
