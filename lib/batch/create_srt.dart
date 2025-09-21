import 'dart:io';

import 'package:create_srt_for_youtube/api/gemini.dart';
import 'package:create_srt_for_youtube/api/youtube.dart';
import 'package:create_srt_for_youtube/model/sentence_segment.dart';
import 'package:create_srt_for_youtube/model/srt.dart';
import 'package:create_srt_for_youtube/others/io_util.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

enum BatchStatus { init, processing, editing, failed }

class CreateSrtBatch extends ChangeNotifier {
  BatchStatus state = BatchStatus.init;
  String? errorMessage;
  String? processName;

  CreateSrtBatch();

  Future<void> run(String videoUrl, String apiKey, String saveFolder) async {
    if (state == BatchStatus.processing) {
      throw StateError('batch is processing');
    }

    try {
      processName = 'transcribing';
      errorMessage = null;
      changeState(BatchStatus.processing);

      final title = await getVideoTitle(videoUrl);
      final fileName = p.joinAll([
        saveFolder,
        sanitizeFileName(title) + '.srt',
      ]);

      final srtTxts = await getSrtFromYoutube(videoUrl, apiKey);

      await File(fileName).writeAsString(srtTxts.join('\n'));
    } catch (e) {
      errorMessage = e.toString();
      changeState(BatchStatus.failed);
    }

    processName = null;
    changeState(BatchStatus.editing);
  }

  void changeState(BatchStatus newState) {
    state = newState;
    notifyListeners();
  }
}

Future<List<String>> getSrtFromYoutube(String videoUrl, String apiKey) async =>
    getWordsTranscription(
      videoUrl,
      apiKey,
    ).then(splitBySentence).then(toSrtRecords).then(srtRecordsToStrings);
