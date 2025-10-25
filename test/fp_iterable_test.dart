import 'package:create_srt_for_youtube/extension/fp_iterable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FpIterableExtensions', () {
    group('zipWith', () {
      test('should zip two iterables of the same length', () {
        final list1 = [1, 2, 3];
        final list2 = ['a', 'b', 'c'];
        final result = list1.zipWith(list2, (i, s) => '$i$s').toList();
        expect(result, ['1a', '2b', '3c']);
      });

      test('should stop when the first iterable is shorter', () {
        final list1 = [1, 2];
        final list2 = ['a', 'b', 'c'];
        final result = list1.zipWith(list2, (i, s) => '$i$s').toList();
        expect(result, ['1a', '2b']);
      });

      test('should stop when the second iterable is shorter', () {
        final list1 = [1, 2, 3];
        final list2 = ['a', 'b'];
        final result = list1.zipWith(list2, (i, s) => '$i$s').toList();
        expect(result, ['1a', '2b']);
      });

      test(
        'should return an empty iterable if the first iterable is empty',
        () {
          final list1 = <int>[];
          final list2 = ['a', 'b', 'c'];
          final result = list1.zipWith(list2, (i, s) => '$i$s').toList();
          expect(result, isEmpty);
        },
      );

      test(
        'should return an empty iterable if the second iterable is empty',
        () {
          final list1 = [1, 2, 3];
          final list2 = <String>[];
          final result = list1.zipWith(list2, (i, s) => '$i$s').toList();
          expect(result, isEmpty);
        },
      );

      test('should return an empty iterable if both iterables are empty', () {
        final list1 = <int>[];
        final list2 = <String>[];
        final result = list1.zipWith(list2, (i, s) => '$i$s').toList();
        expect(result, isEmpty);
      });
    });

    group('zipAllWith', () {
      test('should behave like zipWith for iterables of the same length', () {
        final list1 = [1, 2, 3];
        final list2 = ['a', 'b', 'c'];
        final result = list1
            .zipAllWith(
              list2,
              (i, s) => '$i$s',
              ifLonger: (i) => i.toString(),
              ifShorter: (s) => s,
            )
            .toList();
        expect(result, ['1a', '2b', '3c']);
      });

      test('should use ifLonger for remaining elements', () {
        final list1 = [1, 2, 3, 4];
        final list2 = ['a', 'b'];
        final result = list1
            .zipAllWith(list2, (i, s) => '$i$s', ifLonger: (i) => 'L$i')
            .toList();
        expect(result, ['1a', '2b', 'L3', 'L4']);
      });

      test('should use ifShorter for remaining elements', () {
        final list1 = [1, 2];
        final list2 = ['a', 'b', 'c', 'd'];
        final result = list1
            .zipAllWith(list2, (i, s) => '$i$s', ifShorter: (s) => 'S$s')
            .toList();
        expect(result, ['1a', '2b', 'Sc', 'Sd']);
      });

      test('should handle both ifLonger and ifShorter', () {
        final list1 = [1, 2, 3];
        final list2 = ['a'];
        final result = list1
            .zipAllWith(
              list2,
              (i, s) => '$i$s',
              ifLonger: (i) => 'L$i',
              ifShorter: (s) => 'S$s', // This should not be called
            )
            .toList();
        expect(result, ['1a', 'L2', 'L3']);
      });

      test('should truncate if ifLonger is not provided', () {
        final list1 = [1, 2, 3];
        final list2 = ['a', 'b'];
        final result = list1.zipAllWith(list2, (i, s) => '$i$s').toList();
        expect(result, ['1a', '2b']);
      });
    });
  });
}
