import 'package:create_srt_for_youtube/model/srt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
