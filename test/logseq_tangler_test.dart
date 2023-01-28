import 'package:logseq_tangler/logseq_tangler.dart';
import 'package:test/test.dart';
import 'package:dart_markdown/dart_markdown.dart';

final markdown = Markdown();

void main() {
  group('CodeBlock', () {
    final List<String> emptyLines = [];

    group('fromFencedCodeBlock()', () {
      BlockElement extractFirstBlock(String rawText) =>
          markdown.parse(rawText)[0] as BlockElement;

      test('python, hello world', () {
        final rawText = '```python\nprint("Hello World!")\n```';
        final fencedCodeBlock = extractFirstBlock(rawText);
        final block = CodeBlock.fromFencedCodeBlock(fencedCodeBlock);

        expect(block.language, 'python');
        expect(block.lines, ['print("Hello World!")\n']);
      });

      test('not a code block', () {
        final rawText = '*Hello* World!';
        final block = extractFirstBlock(rawText);

        expect(() => CodeBlock.fromFencedCodeBlock(block),
            throwsA(isA<WrongBlockElementType>()));
      });
    });

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

  group('Getting CodeBlocks from Markdown', () {
    test('with no code blocks', () {
      final rawText = 'Hello World!';
      final codeBlocks = codeBlocksFromMarkdownText(rawText);

      expect(codeBlocks.isEmpty, true);
    });

    test('Code block at the top level', () {
      final rawText = '```python\nprint("Hello World!")\n```\n';
      final codeBlocks = codeBlocksFromMarkdownText(rawText);
      expect(codeBlocks.length, 1);
      expect(codeBlocks[0].toMarkdown(), rawText);
    });

    test('Code block in top-level list item', () {
      final rawText = '- ```python\n  print("Hello World!")\n  ```\n';
      final codeBlocks = codeBlocksFromMarkdownText(rawText);

      expect(codeBlocks.length, 1);

      // Check that code block ignores indentation from bullet list
      final asFencedCode = codeBlocks[0].toMarkdown();
      expect(asFencedCode.contains('\nprint("Hello World!")\n'), true);
    });
  });

  group('LogseqNode', () {
    test('fromString()', () {
      final rawText = '-';
      final logseqNode = LogseqNode.fromString(text: rawText);

      expect(logseqNode.text, rawText);
      expect(logseqNode.codeBlocks.isEmpty, true);
    });

    group('codeBlocks', () {
      test('with a single fenced code block', () {
        final rawText = '''- ```python
  print("Hello, World!")
  ```
''';
        final logseqNode = LogseqNode.fromString(text: rawText);
        expect(logseqNode.codeBlocks.length, 1);
      });
    });
  });
}
