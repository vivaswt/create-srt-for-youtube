import 'dart:io';

import 'package:create_srt_for_youtube/api/youtube.dart';
import 'package:create_srt_for_youtube/others/io_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getVideoTitle', () {
    // This is an integration test that makes a real network call to YouTube.
    test('should return the correct video title for a valid URL', () async {
      // Arrange
      const videoUrl = 'https://youtu.be/fn49lmHxmqg?si=ytOXDEbil9gyGTsL';
      const expectedTitle = 'Pathfinder Quest Official Campaign Trailer';

      // Act
      final result = await getVideoTitle(videoUrl);

      // Assert
      expect(result, expectedTitle);
    });
  });

  group('downloadVideo', () {
    test('should suceed to download video', () async {
      const videoUrl = 'https://youtu.be/Mk5dFqNsibU?si=DyeFUuBEeBBzwU10';

      final title = sanitizeFileName(await getVideoTitle(videoUrl));
      final result = await downloadVideo(
        videoUrl,
        baseName: title,
        folder: 'data/',
      );
      expect(result.existsSync(), isTrue);
    });
  });
}
