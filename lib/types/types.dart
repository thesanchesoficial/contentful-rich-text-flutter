import 'package:contentful_rich_text/types/blocks.dart';
import 'package:contentful_rich_text/types/inlines.dart';
import 'package:contentful_rich_text/types/schema_constraints.dart';
import 'package:flutter/material.dart';

abstract class Node<T> {
  late T _nodeType;
  Map<dynamic, dynamic>? data;
  T get nodeType => _nodeType;
}

abstract class Block<T> extends Node<BLOCKS> {
  late BLOCKS _nodeType;
  List<T>? content;
}

abstract class Inline<T> extends Node<INLINES> {
  late INLINES _nodeType;
  List<T>? content;
}

abstract class TopLevelBlock extends Node<TopLevelBlockEnum> {
  late TopLevelBlockEnum _nodeType;
}

class Document extends Node<BLOCKS> {
  final BLOCKS _nodeType;
  final List<dynamic> content;

  Document({
    required this.content,
    required String nodeType,
    required Map<dynamic, dynamic> data,
  }) : _nodeType = BLOCKS.fromValue(nodeType) ?? BLOCKS.DOCUMENT {
    this.data = data;
  }

  static Document? fromJson(dynamic richTextJson) {
    if (richTextJson == null) {
      return null;
    }
    return Document(
      content: richTextJson['content'],
      nodeType: richTextJson['nodeType'],
      data: richTextJson['data'],
    );
  }
}

class TextNode extends Node<String> {
  final String _nodeType;
  final String value;
  final List<Mark> marks;

  TextNode(dynamic node)
      : value = node['value'] ?? '',
        _nodeType = node['nodeType'] ?? '',
        marks = (node['marks'] as List?)
                ?.map((mark) => Mark(mark['type']))
                .toList() ??
            <Mark>[];
}

class Mark {
  final String type;

  Mark(this.type);
}

// Helper types for Rich Text Rendering
typedef Next = dynamic Function(dynamic nodes);
typedef NodeRenderer = dynamic Function(dynamic node, Next next);

/// Converte o resultado do next() em uma lista de widgets de forma segura
List<Widget> toWidgetList(dynamic content) {
  if (content == null) return [];
  if (content is List<Widget>) return content;
  if (content is List) return content.whereType<Widget>().toList();
  if (content is Widget) return [content];
  return [];
}

class RenderNode<T> {
  final Map<T, NodeRenderer> renderNodes;
  RenderNode(this.renderNodes);
}

class RenderMark<T> {
  final Map<T, TextStyle> renderMarks;
  RenderMark(this.renderMarks);
}

/// Estilos padrão para cada tipo de texto
class TextStyles {
  final TextStyle? paragraph;
  final TextStyle? heading1;
  final TextStyle? heading2;
  final TextStyle? heading3;
  final TextStyle? heading4;
  final TextStyle? heading5;
  final TextStyle? heading6;
  final TextStyle? listItem;
  final TextStyle? quote;
  final TextStyle? hyperlink;

  const TextStyles({
    this.paragraph,
    this.heading1,
    this.heading2,
    this.heading3,
    this.heading4,
    this.heading5,
    this.heading6,
    this.listItem,
    this.quote,
    this.hyperlink,
  });

  /// Estilos padrão
  static TextStyles get defaults => TextStyles(
    paragraph: const TextStyle(fontSize: 16.0, height: 1.5),
    heading1: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, height: 1.3),
    heading2: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, height: 1.3),
    heading3: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, height: 1.3),
    heading4: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.3),
    heading5: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, height: 1.3),
    heading6: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, height: 1.3),
    listItem: const TextStyle(fontSize: 16.0, height: 1.5),
    quote: const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, height: 1.5),
    hyperlink: TextStyle(
      fontSize: 16.0,
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
  );

  /// Mescla os estilos atuais com outros estilos
  TextStyles merge(TextStyles? other) {
    if (other == null) return this;
    return TextStyles(
      paragraph: other.paragraph ?? paragraph,
      heading1: other.heading1 ?? heading1,
      heading2: other.heading2 ?? heading2,
      heading3: other.heading3 ?? heading3,
      heading4: other.heading4 ?? heading4,
      heading5: other.heading5 ?? heading5,
      heading6: other.heading6 ?? heading6,
      listItem: other.listItem ?? listItem,
      quote: other.quote ?? quote,
      hyperlink: other.hyperlink ?? hyperlink,
    );
  }
}

class Options {
  /// Node renderers
  final RenderNode renderNode;

  /// Mark renderers
  final RenderMark? renderMark;

  /// Estilos de texto personalizados
  final TextStyles? textStyles;

  const Options({
    required this.renderNode,
    this.renderMark,
    this.textStyles,
  });

  /// Obtém os estilos de texto mesclados com os padrões
  TextStyles get styles => TextStyles.defaults.merge(textStyles);
}
