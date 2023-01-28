import 'package:dart_markdown/dart_markdown.dart';
import 'package:contextual_logging/contextual_logging.dart';

class WrongBlockElementType implements Exception {
  String error() => 'BlockElement must be a fenced code block';
}

class CodeBlock with ContextualLogger {
  String? language;
  late List<String> lines;

  CodeBlock({this.language, required this.lines});

  CodeBlock.fromFencedCodeBlock(BlockElement block) {
    log.d('block.type is "${block.type}"');

    if (block.type != "fencedCodeBlock") {
      log.e('block.type "${block.type}" is not "fencedCodeBlock"');
      throw WrongBlockElementType();
    }

    language = block.markers[0].text.replaceAll('```', '');
    lines = block.children.cast<Text>().map((Text line) => line.text).toList();
  }

  String toMarkdown() {
    final codeLines = lines.join();
    final language = this.language ?? '';
    return '```$language\n$codeLines```\n';
  }
}
