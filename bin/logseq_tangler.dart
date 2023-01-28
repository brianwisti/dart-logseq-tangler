import 'dart:io';

import 'package:dart_markdown/dart_markdown.dart';
import 'package:logseq_tangler/logseq_tangler.dart' as logseq_tangler;

void showNodeBreakdown(Node node) {
  if (node is BlockElement) {
    if (node.type == "fencedCodeBlock") {
      print(node.type);
      final codeBlock = LogseqCodeBlock.fromFencedCodeBlock(node);
      print(codeBlock.toMarkdown());
    }

    node.children.forEach(showNodeBreakdown);
  } else {
    print(node.runtimeType);
  }
}

void main(List<String> arguments) async {
  final path = '/home/random/Documents/my-logseq-graph/pages/My Config.md';

  try {
    final file = File(path);
    final markdown = Markdown();
    final contents = await file.readAsString();
    final nodes = markdown.parse(contents);
    nodes.forEach(showNodeBreakdown);
  } catch (e) {
    stderr.writeln('failed to read file: \n${e}');
  }
}
