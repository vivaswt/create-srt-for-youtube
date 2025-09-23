import 'dart:io';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<String> getVideoTitle(String videoUrl) async {
  final yt = YoutubeExplode();
  try {
    final video = await yt.videos.get(videoUrl);
    return video.title;
  } catch (e) {
    throw Exception('Error getting video title: $e');
  } finally {
    yt.close();
  }
}

Future<File> downloadVideo(
  String videoUrl, {
  required String folder,
  required String baseName,
}) async {
  const formatOption = 'bv*[vcodec=avc1]+ba[acodec=mp4a]/b[vcodec=avc1]/best';

  final result = await Process.run('yt-dlp', [
    '-f',
    formatOption,
    '--force-overwrites',
    '-P',
    folder,
    '-o',
    '$baseName.%(ext)s',
    videoUrl,
  ]);

  if (result.exitCode != 0) {
    throw Exception('Error downloading video: ${result.stderr}');
  }

  final fileName = extractFileNameFromLog(result.stdout);
  if (fileName == null) {
    throw Exception('Error donloading video: cannot find file name');
  }

  return File(fileName);
}

String? extractFileNameFromLog(String logText) {
  final result = RegExp(
    r'Destination: (.+)\n',
  ).firstMatch(logText)?.groups([1]);
  return result?.first;
}
