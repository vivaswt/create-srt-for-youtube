import 'dart:io';

import 'package:create_srt_for_youtube/api/gemini_translate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('basic', () {
    test('normal', () async {
      final srts = File(
        'data/An Easy Way to Write a TTRPG Adventure!.srt',
      ).readAsStringSync().split('\n');

      final result = await requestForTranslation(
        srts,
        Platform.environment['GEMINI_API_KEY']!,
      ).then(extractGeminiResponse);

      File(
        'data/An Easy Way to Write a TTRPG Adventure!_Japanese.srt',
      ).writeAsStringSync(result);
    }, timeout: Timeout(Duration(minutes: 10)));
  });
}
