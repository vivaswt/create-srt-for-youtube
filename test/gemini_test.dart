import 'dart:io';

import 'package:create_srt_for_youtube/api/gemini.dart';
import 'package:create_srt_for_youtube/model/word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String mockSuccessResponse;

  // Load the mock JSON data before running the tests
  setUpAll(() async {
    mockSuccessResponse = await File(
      'data/words_transcription.json',
    ).readAsString();
  });

  group('fetchWordsTranscription', () {
    test('returns a string', () async {
      const videoUrl = 'https://youtu.be/fn49lmHxmqg?si=NK_5gvmln2KNAW73';
      final result = await fetchWordsTranscription(
        videoUrl,
        Platform.environment['GEMINI_API_KEY']!,
      );
      expect(result, isNotEmpty);
    });
  });

  group('extractGeminiResponse', () {
    test('should extract transcription text from a valid response', () {
      // Act
      final result = extractGeminiResponse(mockSuccessResponse);

      // Assert
      const expectedText =
          'Pathfinder|60949|61359\nQuest|61359|61649\nis|61649|61799\nentirely|61939|62259\nself-guided|62459|63039\nand|63039|63159\ncooperative.|63299|63929';
      expect(result, equals(expectedText));
    });

    test('should throw an exception for a response with no text', () {
      // Arrange
      const mockErrorResponse = '{"promptFeedback": {"blockReason": "SAFETY"}}';

      // Act & Assert
      expect(
        () => extractGeminiResponse(mockErrorResponse),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Fail to get Gemini response text - reason: SAFETY'),
          ),
        ),
      );
    });
  });

  group('parseWordsTranscription', () {
    test('should parse a valid response into a list of Word objects', () {
      // Act
      final result = parseWordsTranscription(mockSuccessResponse);

      // Assert
      expect(result, isA<List<Word>>());
      expect(result.length, 7);

      // Check the first and last words to confirm parsing is correct
      expect(result.first.text, 'Pathfinder');
      expect(result.first.start, 60949);
      expect(result.first.end, 61359);

      expect(result.last.text, 'cooperative.');
      expect(result.last.start, 63299);
      expect(result.last.end, 63929);
    });
  });
}
