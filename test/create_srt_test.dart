import 'dart:io';

import 'package:create_srt_for_youtube/batch/create_srt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreateSrtBatch', () {
    test('should have done batch.', () async {
      final videoUrl = 'https://youtu.be/x94tJV1NTso?si=kLHTV2yBz1bFz1Lm';
      final batch = CreateSrtBatch();
      await batch.run(
        videoUrl,
        Platform.environment['GEMINI_API_KEY']!,
        'data/',
      );
      expect(batch.state, BatchStatus.editing);
    }, timeout: Timeout(Duration(minutes: 10)));
  });
}
