import 'package:dart_markdown/dart_markdown.dart';

class LogseqCodeBlock {
  String? language;
  late List<String> lines;

  LogseqCodeBlock({this.language, required this.lines});

  LogseqCodeBlock.fromFencedCodeBlock(BlockElement block) {
    this.language = block.markers[0].text.replaceAll('```', '');
    this.lines =
        block.children.cast<Text>().map((Text line) => line.text).toList();
  }

  String toMarkdown() {
    final codeLines = this.lines.join();
    final language = this.language ?? '';
    return '```${language}\n${codeLines}```\n';
  }
}
