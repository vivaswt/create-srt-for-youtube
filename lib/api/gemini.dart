import 'dart:convert';

import 'package:create_srt_for_youtube/model/word.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:http/http.dart' as http;

/// Fetches and parses the word transcription from a video URL.
Future<List<Word>> getWordsTranscription(String videoUrl, String apiKey) =>
    fetchWordsTranscription(videoUrl, apiKey).then(parseWordsTranscription);

/// Calls the Gemini API to get the raw transcription string for a video.
Future<String> fetchWordsTranscription(String videoUrl, String apiKey) async {
  const String url =
      //'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent';

  final Map<String, String> headers = {
    'x-goog-api-key': apiKey,
    'Content-Type': 'application/json',
  };

  final body = {
    "contents": [
      {
        "parts": [
          {"text": wordsTranscriptPrompt},
          {
            "file_data": {"file_uri": videoUrl},
          },
        ],
      },
    ],
  };

  final res = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (res.statusCode == 200) {
    return res.body;
  } else {
    throw Exception(
      'Failed to fetch words transcription. Status Code = ${res.statusCode}, Message = ${res.body}',
    );
  }
}

/// The prompt sent to the Gemini API to request a word-level transcription.
const String wordsTranscriptPrompt = '''
Transcribe the spoken dialogue from the attached YouTube video.
Do not include any on-screen text, descriptions, or visual information.
The transcription should include appropriate punctuation,
such as commas, periods, question marks, and exclamation points,
to reflect the natural pauses and intonation of the speaker.
Ensure the timestamps are accurately aligned with the spoken words throughout the entire video,
with minimal drift, especially for long-form content.
Return the transcription as a list of words with their start and end timestamps in milliseconds.
The output should be in the following format: word text|start|end

For example:
Pathfinder|60949|61359
Quest|61359|61649
is|61649|61799
entirely|61939|62259
self-guided|62459|63039
and|63039|63159
cooperative.|63299|63929
''';

/// Extracts the Gemini API's JSON response and extracts the transcription text.
String extractGeminiResponse(String responseBody) {
  final json = jsonDecode(responseBody);
  final resultText = pick(
    json,
    'candidates',
    0,
    'content',
    'parts',
    0,
    'text',
  ).asStringOrNull();

  if (resultText == null) {
    final blockReason = pick(
      json,
      'promptFeedback',
      'blockReason',
    ).asStringOrNull();
    throw Exception('Fail to get Gemini response text - reason: $blockReason');
  }

  return resultText;
}

Word wordFromString(String value) {
  final parts = value.split('|');
  return Word(
    text: parts[0],
    start: int.parse(parts[1]),
    end: int.parse(parts[2]),
  );
}

/// Parses the raw transcription string into a list of [Word] objects.
List<Word> parseWordsTranscription(String responseBody) =>
    extractGeminiResponse(
      responseBody,
    ).split('\n').where((line) => line.isNotEmpty).map(wordFromString).toList();
