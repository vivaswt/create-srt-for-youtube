import 'package:flutter_test/flutter_test.dart';
import 'package:create_srt_for_youtube/model/srv2_parser.dart';

void main() {
  group('parseSrv2', () {
    test('normal case', () {
      final result = parseSrv2(srv2Data1);
      expect(result.length, 3);
      expect(result[0].text, 'We');
      expect(result[1].text, 'are');
      expect(result[2].text, '');

      expect(result[0].start, 4160);
      expect(result[1].start, 4400);
      expect(result[2].start, 6150);

      expect(result[0].end, 4400);
      expect(result[1].end, 6150);
      expect(result[2].end, 6150 + 2170);
    });
  });
}

const srv2Data1 = '''
<?xml version="1.0" encoding="utf-8" ?>
<timedtext>
    <window id="1" t="0" op="define" ap="6" ah="20" av="100" rc="2" cc="40" sd="1" ju="0"/>
    <text t="4160" d="4160" w="1" r="15" c="1">We</text>
    <text t="4400" d="3920" w="1" append="1"> are</text>
    <text w="1" t="6150" d="2170" append="1">
    </text>
</timedtext>
''';
