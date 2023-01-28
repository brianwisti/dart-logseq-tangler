import 'package:logseq_tangler/logseq_tangler.dart';
import 'package:test/test.dart';

void main() {
  group('LogseqCodeBlock', () {
    final List<String> emptyLines = [];

    group('toMarkdown()', () {
      test('no lines with no language', () {
        final block = LogseqCodeBlock(lines: emptyLines);
        final expectedMD = '```\n```\n';

        expect(block.toMarkdown(), expectedMD);
      });

      test('text, no lines', () {
        final language = 'text';
        final block = LogseqCodeBlock(language: language, lines: emptyLines);

        expect(block.toMarkdown(), '```text\n```\n');
      });

      test('python, hello world', () {
        final block = LogseqCodeBlock(
            language: 'python', lines: ['print("Hello World!")\n']);

        expect(block.toMarkdown(), '```python\nprint("Hello World!")\n```\n');
      });

      test('dart, hello world', () {
        final lines = [
          'void main() {\n',
          '  print(\'Hello World!\');\n',
          '}\n',
        ];
        final block = LogseqCodeBlock(language: 'dart', lines: lines);

        expect(block.toMarkdown(), '```dart\n${lines.join()}```\n');
      });
    });
  });
}
