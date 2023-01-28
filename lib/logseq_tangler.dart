import 'package:dart_markdown/dart_markdown.dart';
import 'package:contextual_logging/contextual_logging.dart';

const codeBlockType = 'fencedCodeBlock';

class WrongBlockElementType implements Exception {
  String error() => 'BlockElement must be a fenced code block';
}

class CodeBlock with ContextualLogger {
  String? language;
  late List<String> lines;

  CodeBlock({this.language, required this.lines});

  CodeBlock.fromFencedCodeBlock(BlockElement block) {
    log.d('block.type is "${block.type}"');

    if (block.type != codeBlockType) {
      log.e('block.type "${block.type}" is not "$codeBlockType"');
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

List<CodeBlock> codeBlocksFromMarkdownNode(Node node) {
  List<CodeBlock> codeBlocks = [];

  if (node is BlockElement) {
    if (node.type == codeBlockType) {
      codeBlocks.add(CodeBlock.fromFencedCodeBlock(node));
    } else {
      for (var childNode in node.children) {
        codeBlocks.addAll(codeBlocksFromMarkdownNode(childNode));
      }
    }
  }

  return codeBlocks;
}

List<CodeBlock> codeBlocksFromMarkdownText(String rawText) {
  List<CodeBlock> codeBlocks = [];
  final markdown = Markdown();
  final nodes = markdown.parse(rawText);

  for (var node in nodes) {
    codeBlocks.addAll(codeBlocksFromMarkdownNode(node));
  }

  return codeBlocks;
}

/// Only cares about the Markdown, not the file context.
/// Also, keep in mind that we're not yet building a full LogseqNode AST.
/// We only care about the code in a given LogseqNode.
class LogseqNode {
  String text;
  late List<CodeBlock> codeBlocks;

  LogseqNode({required this.text});

  LogseqNode.fromString({required this.text}) {
    codeBlocks = codeBlocksFromMarkdownText(text);
  }
}
