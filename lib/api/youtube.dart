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

Future<void> downloadVideo(String videoUrl, String fileName) async {
  final yt = YoutubeExplode();

  try {
    final manifest = await yt.videos.streamsClient.getManifest(videoUrl);
    final streamInfo = manifest.muxed.withHighestBitrate();
    final stream = yt.videos.streamsClient.get(streamInfo);
    final fileStream = File(fileName).openWrite();

    await stream.pipe(fileStream).whenComplete(() async {
      await fileStream.flush();
      await fileStream.close();
    });
  } catch (e) {
    throw Exception('Error downloading video: $e');
  } finally {
    yt.close();
  }
}
