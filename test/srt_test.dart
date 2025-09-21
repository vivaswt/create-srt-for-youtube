import 'package:create_srt_for_youtube/model/sentence_segment.dart';
import 'package:create_srt_for_youtube/model/srt.dart';
import 'package:create_srt_for_youtube/model/word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('splitBySentence', () {
    test('should return an empty list for empty input', () {
      final result = splitBySentence([]);
      expect(result, isEmpty);
    });

    test('should return a single segment for a single word', () {
      final words = [Word(text: 'Hello', start: 0, end: 100)];
      final result = splitBySentence(words);
      expect(result.length, 1);
      expect(result.first.words, words);
    });

    test('should split words into two sentences based on punctuation', () {
      final words = [
        Word(text: 'Hello', start: 0, end: 100),
        Word(text: 'world.', start: 101, end: 200),
        Word(text: 'This', start: 201, end: 300),
        Word(text: 'is', start: 301, end: 400),
        Word(text: 'a', start: 401, end: 500),
        Word(text: 'test.', start: 501, end: 600),
      ];

      final result = splitBySentence(words);

      expect(result.length, 2);
      expect(result[0].words.length, 2);
      expect(result[0].words.map((w) => w.text).join(' '), 'Hello world.');
      expect(result[0].start, 0);
      expect(result[0].end, 200);

      expect(result[1].words.length, 4);
      expect(result[1].words.map((w) => w.text).join(' '), 'This is a test.');
      expect(result[1].start, 201);
      expect(result[1].end, 600);
    });

    test('should handle multiple types of punctuation', () {
      final words = [
        Word(text: 'Is this a test?', start: 0, end: 100),
        Word(text: 'Yes!', start: 101, end: 200),
        Word(text: 'It is.', start: 201, end: 300),
      ];

      final result = splitBySentence(words);

      expect(result.length, 3);
      expect(result[0].words.map((w) => w.text).join(' '), 'Is this a test?');
      expect(result[1].words.map((w) => w.text).join(' '), 'Yes!');
      expect(result[2].words.map((w) => w.text).join(' '), 'It is.');
    });

    test('should handle a list that does not end with punctuation', () {
      final words = [
        Word(text: 'This', start: 0, end: 100),
        Word(text: 'is', start: 101, end: 200),
        Word(text: 'the end', start: 201, end: 300),
      ];

      final result = splitBySentence(words);

      expect(result.length, 1);
      expect(result.first.words.length, 3);
    });
  });

  group('srtRecordsToStrings', () {
    test('should return an empty list for empty input', () {
      final result = srtRecordsToStrings([]);
      expect(result, isEmpty);
    });

    test(
      'should convert a list of single SrtRecord to a flat list of string',
      () {
        // Arrange
        final records = [
          SrtRecord(id: 1, text: 'Hello world.', start: 101, end: 200),
        ];

        // Act
        final result = srtRecordsToStrings(records);

        // Assert
        expect(result, ['1', '00:00:00,101 --> 00:00:00,200', 'Hello world.']);
      },
    );
    test('should convert a list of SrtRecords to a flat list of strings', () {
      // Arrange
      final records = [
        SrtRecord(id: 1, text: 'Hello world.', start: 101, end: 200),
        SrtRecord(id: 2, text: 'This is a test.', start: 301, end: 600),
      ];

      // Act
      final result = srtRecordsToStrings(records);

      // Assert
      expect(result, [
        '1',
        '00:00:00,101 --> 00:00:00,200',
        'Hello world.',
        '',
        '2',
        '00:00:00,301 --> 00:00:00,600',
        'This is a test.',
        '',
      ]);
    });
  });
}
