// ignore_for_file: unused_local_variable, prefer_function_declarations_over_variables

import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path_lib;

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
  final arguments = [
    '-f',
    formatOption,
    '--force-overwrites',
    '-P',
    folder,
    '-o',
    '$baseName.%(ext)s',
    videoUrl,
  ];

  final result = await Process.run('yt-dlp', arguments);
  if (result.exitCode != 0) {
    throw Exception('Error downloading video: ${result.stderr}');
  }

  final fileName = extractFileNameFromLog(
    result.stdout,
    pattern: r'Destination: (.+)\n',
  );
  if (fileName == null) {
    throw Exception('Error donloading video: cannot find file name');
  }

  return File(fileName);
}

String? extractFileNameFromLog(String logText, {required String pattern}) {
  final result = RegExp(pattern).firstMatch(logText)?.groups([1]);
  return result?.first;
}

Future<String> getSubTitleContents(
  String videoUrl, {
  required String format,
  required String folder,
  required String baseName,
}) async {
  final arguments = [
    '--force-overwrites',
    '--write-auto-subs',
    '--sub-format',
    format,
    '--skip-download',
    '-o',
    'subtitle:$baseName.%(ext)s',
    '-P',
    folder,
    videoUrl,
  ];

  final result = await Process.run('yt-dlp', arguments);
  if (result.exitCode != 0) {
    throw Exception('Error downloading subtitle: ${result.stderr}');
  }

  final fileName = extractFileNameFromLog(
    result.stdout,
    pattern: r'\[MoveFiles\] Moving file ".+?" to "(.+?)"',
  );
  if (fileName == null) {
    throw Exception('Error downloading subtitle: cannot find file name');
  }

  if (path_lib.extension(fileName) != '.$format') {
    throw Exception('Error downloading subtitle: $format not found');
  }

  final file = File(fileName);
  final contents = await file.readAsString();
  await file.delete();

  return contents;
}
