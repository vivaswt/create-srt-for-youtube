import 'dart:convert';
import 'dart:io';

import 'package:deep_pick/deep_pick.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';

Future<String> initiateFileUpload(String filePath, String apiKey) async {
  const String url =
      'https://generativelanguage.googleapis.com/upload/v1beta/files';

  final mediaFile = File(filePath);
  final mimeType = lookupMimeType(filePath);
  if (mimeType == null) {
    throw Exception('Could not determine MIME type for $filePath');
  }
  final fileLength = await mediaFile.length();

  final Map<String, String> headers = {
    'x-goog-api-key': apiKey,
    'X-Goog-Upload-Protocol': 'resumable',
    'X-Goog-Upload-Command': 'start',
    'X-Goog-Upload-Header-Content-Length': fileLength.toString(),
    'X-Goog-Upload-Header-Content-Type': mimeType,
    'Content-Type': 'application/json',
  };

  final body = {
    'file': {'display_name': p.basename(filePath)},
  };

  final res = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (res.statusCode == 200) {
    return res.headers['x-goog-upload-url']!;
  } else {
    throw Exception(
      'Failed to initiate uploading file. Status Code = ${res.statusCode}, Message = ${res.body}',
    );
  }
}

Future<UploadedFile> uploadFile(
  String filePath,
  String uploadUrl,
  String apiKey,
) async {
  final mediaFile = File(filePath);
  final fileLength = await mediaFile.length();

  final Map<String, String> headers = {
    'Content-Length': fileLength.toString(),
    'X-Goog-Upload-Offset': '0',
    'X-Goog-Upload-Command': 'upload, finalize',
  };

  final body = await mediaFile.readAsBytes();

  final res = await http.post(
    Uri.parse(uploadUrl),
    headers: headers,
    body: body,
  );

  if (res.statusCode == 200) {
    final json = jsonDecode(res.body);
    final pfile = pick(json, 'file');

    final name = pfile('name').asStringOrThrow();
    final uri = pfile('uri').asStringOrThrow();
    final state = FileState.fromString(pfile('state').asStringOrThrow());

    return UploadedFile(name: name, uri: uri, state: state);
  } else {
    throw Exception(
      'Failed to upload file. Status Code = ${res.statusCode}, Message = ${res.body}',
    );
  }
}

Future<FileState> getFileState(String fileName, String apiKey) async {
  final String url =
      'https://generativelanguage.googleapis.com/v1beta/$fileName';

  final Map<String, String> headers = {'x-goog-api-key': apiKey};

  final res = await http.get(Uri.parse(url), headers: headers);

  if (res.statusCode == 200) {
    final json = jsonDecode(res.body);
    final pfile = pick(json);
    final state = FileState.fromString(pfile('state').asStringOrThrow());

    return state;
  } else {
    throw Exception(
      'Failed to get file state. Status Code = ${res.statusCode}, Message = ${res.body}',
    );
  }
}

class UploadedFile {
  final String name;
  final String uri;
  final FileState state;

  UploadedFile({required this.name, required this.uri, required this.state});

  @override
  String toString() {
    return 'UploadedFile{name: $name, uri: $uri, state: $state}';
  }
}

enum FileState {
  stateUnspecified,
  processing,
  active,
  failed;

  static FileState fromString(String value) => switch (value) {
    'PROCESSING' => processing,
    'ACTIVE' => active,
    'FAILED' => failed,
    _ => stateUnspecified,
  };
}
