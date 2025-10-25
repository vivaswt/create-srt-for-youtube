import 'dart:io';

import 'package:create_srt_for_youtube/api/gemini_translate.dart';
import 'package:create_srt_for_youtube/api/youtube.dart';
import 'package:create_srt_for_youtube/extension/object.dart';
import 'package:create_srt_for_youtube/model/sentence_segment.dart';
import 'package:create_srt_for_youtube/model/srt.dart';
import 'package:create_srt_for_youtube/model/srv2_parser.dart';
import 'package:create_srt_for_youtube/others/io_util.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum BatchStatus { init, processing, editing, failed }

class CreateSrtBatch extends ChangeNotifier {
  BatchStatus state = BatchStatus.init;
  String? errorMessage;
  String? processName;

  CreateSrtBatch();

  Future<void> run(String videoUrl, String saveFolder) async {
    if (state == BatchStatus.processing) {
      throw StateError('batch is processing');
    }

    try {
      processName = 'getting video info';
      errorMessage = null;
      changeState(BatchStatus.processing);
      final title = await getVideoTitle(videoUrl);
      final baseName = sanitizeFileName(title);

      processName = 'downloading';
      notifyListeners();
      await downloadVideo(videoUrl, folder: saveFolder, baseName: baseName);

      processName = 'transcribing';
      notifyListeners();
      final srtFileName = p.joinAll([saveFolder, baseName + '.srt']);
      final srtTxts = await _getSrtFromYoutube(videoUrl);
      await File(srtFileName).writeAsString(srtTxts.join('\n'));

      processName = 'translating';
      notifyListeners();
      await _tranlateSrt(
        srtTxts,
        saveFolder: saveFolder,
        baseName: baseName,
        apiKey: Platform.environment['GEMINI_API_KEY']!,
      );

      processName = null;
      changeState(BatchStatus.editing);
    } catch (e) {
      errorMessage = e.toString();
      changeState(BatchStatus.failed);
    }
  }

  void changeState(BatchStatus newState) {
    state = newState;
    notifyListeners();
  }
}

Future<List<String>> _getSrtFromYoutube(String videoUrl) async {
  final tempFolder = await getTemporaryDirectory();
  final contents = await getSubTitleContents(
    videoUrl,
    format: 'srv2',
    folder: tempFolder.path,
    baseName: 'subtitle',
  );

  List<SentenceSegment> splitLongSentence(segment) =>
      splitLongSegment(segment, minTotalWords: 15, minPartWords: 5);

  return parseSrv2(contents)
      .pipe(splitBySentence)
      .expand(splitLongSentence)
      .toList()
      .pipe(toSrtRecords)
      .pipe(srtRecordsToStrings);
}

Future<void> _tranlateSrt(
  List<String> srtTexts, {
  required String saveFolder,
  required String baseName,
  required String apiKey,
}) async {
  final jpSrtTexts = await translateSrt(srtTexts, apiKey);
  final fileName = p.joinAll([saveFolder, baseName + '_jp.srt']);
  await File(fileName).writeAsString(jpSrtTexts.join('\n'));
}
