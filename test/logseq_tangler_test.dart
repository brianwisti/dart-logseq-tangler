import 'package:logseq_tangler/logseq_tangler.dart';
import 'package:test/test.dart';

void main() {
  group('CodeBlock', () {
    final List<String> emptyLines = [];

    group('toMarkdown()', () {
      test('no lines with no language', () {
        final block = CodeBlock(lines: emptyLines);
        final expectedMD = '```\n```\n';

        expect(block.toMarkdown(), expectedMD);
      });

      test('text, no lines', () {
        final language = 'text';
        final block = CodeBlock(language: language, lines: emptyLines);

        expect(block.toMarkdown(), '```text\n```\n');
      });

      test('python, hello world', () {
        final block =
            CodeBlock(language: 'python', lines: ['print("Hello World!")\n']);

        expect(block.toMarkdown(), '```python\nprint("Hello World!")\n```\n');
      });

      test('dart, hello world', () {
        final lines = [
          'void main() {\n',
          '  print(\'Hello World!\');\n',
          '}\n',
        ];
        final block = CodeBlock(language: 'dart', lines: lines);

        expect(block.toMarkdown(), '```dart\n${lines.join()}```\n');
      });
    });
  });
}
