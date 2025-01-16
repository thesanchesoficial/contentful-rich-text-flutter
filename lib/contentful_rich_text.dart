library contentful_rich_text;

import 'package:contentful_rich_text/state/renderers.dart';
import 'package:contentful_rich_text/types/blocks.dart';
import 'package:contentful_rich_text/types/custom_blocks.dart';
import 'package:contentful_rich_text/types/helpers.dart';
import 'package:contentful_rich_text/types/inlines.dart';
import 'package:contentful_rich_text/types/marks.dart';
import 'package:contentful_rich_text/types/node_type_mapper.dart';
import 'package:contentful_rich_text/types/types.dart';
import 'package:contentful_rich_text/widgets/asset_hyperlink.dart';
import 'package:contentful_rich_text/widgets/embedded_asset.dart';
import 'package:contentful_rich_text/widgets/embedded_entry.dart';
import 'package:contentful_rich_text/widgets/entry_hyperlink.dart';
import 'package:contentful_rich_text/widgets/heading.dart';
import 'package:contentful_rich_text/widgets/hr.dart';
import 'package:contentful_rich_text/widgets/hyperlink.dart';
import 'package:contentful_rich_text/widgets/inline_embedded_entry.dart';
import 'package:contentful_rich_text/widgets/list_item.dart';
import 'package:contentful_rich_text/widgets/ordered_list.dart';
import 'package:contentful_rich_text/widgets/paragraph.dart';
import 'package:contentful_rich_text/widgets/quote.dart';
import 'package:contentful_rich_text/widgets/unordered_list.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';

/// Contentful Rich Text widget
class ContentfulRichText {
  RenderNode defaultNodeRenderers = RenderNode({
    BLOCKS.PARAGRAPH.value: (node, next) => Paragraph(node, next),
    BLOCKS.HEADING_1.value: (node, next) => Heading(
      level: BLOCKS.HEADING_1,
      text: node['value'] ?? '',
      content: node['content'] ?? '',
      next: next,
    ),
    BLOCKS.HEADING_2.value: (node, next) => Heading(
      level: BLOCKS.HEADING_2,
      text: node['value'] ?? '',
      content: node['content'] ?? '',
      next: next,
    ),
    BLOCKS.HEADING_3.value: (node, next) => Heading(
      level: BLOCKS.HEADING_3,
      text: node['value'] ?? '',
      content: node['content'] ?? '',
      next: next,
    ),
    BLOCKS.HEADING_4.value: (node, next) => Heading(
      level: BLOCKS.HEADING_4,
      text: node['value'] ?? '',
      content: node['content'] ?? '',
      next: next,
    ),
    BLOCKS.HEADING_5.value: (node, next) => Heading(
      level: BLOCKS.HEADING_5,
      text: node['value'] ?? '',
      content: node['content'] ?? '',
      next: next,
    ),
    BLOCKS.HEADING_6.value: (node, next) => Heading(
      level: BLOCKS.HEADING_6,
      text: node['value'] ?? '',
      content: node['content'] ?? '',
      next: next,
    ),
    BLOCKS.EMBEDDED_ENTRY.value: (node, next) => EmbeddedEntry(node, next),
    BLOCKS.EMBEDDED_ASSET.value: (node, next) => EmbeddedAsset(node, next),
    BLOCKS.UL_LIST.value: (node, next) =>
        UnorderedList(node['content'] ?? '', next),
    BLOCKS.OL_LIST.value: (node, next) =>
        OrderedList(node['content'] ?? '', next),
    BLOCKS.LIST_ITEM.value: (node, next) => ListItem(
      text: node.value,
      type: node.nodeType == BLOCKS.OL_LIST.value
          ? ListItemType.ordered
          : ListItemType.unordered,
      children: node['content'] ?? '',
    ),
    BLOCKS.QUOTE.value: (node, next) => Quote(node, next),
    BLOCKS.HR.value: (node, next) => Hr(),
    INLINES.ASSET_HYPERLINK.value: (node, next) =>
        AssetHyperlink(node as Inline, next),
    INLINES.ENTRY_HYPERLINK.value: (node, next) =>
        EntryHyperlink(node as Inline, next),
    INLINES.EMBEDDED_ENTRY.value: (node, next) =>
        InlineEmbeddedEntry(node, next),
    INLINES.HYPERLINK.value: (node, next) => Hyperlink(node, next),
  });

  dynamic richTextJson;
  Options? options;
  Document? richTextDocument;

  ContentfulRichText(this.richTextJson, {this.options});

  /// This is the main entry point for ContentfulRichText. To render
  /// Flutter widgets, in your app instantiate ContentfulRichText with
  /// the JSON data, as well as any (optional) Renderer or Mark options,
  /// and then get documentToWidgetTree:
  /// ContentfulRichText(json, options: {...}).documentToWidgetTree
  Widget get documentToWidgetTree {
    if (richTextJson != null && richTextJson['content'] != null) {
      // parse richTextData to a Document from JSON form
      richTextDocument = _parseRichTextJson();

      singletonRenderers.renderNode = Map.from(
        defaultNodeRenderers.renderNodes,
      );
      if (options?.renderNode.renderNodes != null) {
        singletonRenderers.renderNode.addAll(options!.renderNode.renderNodes);
      }
      singletonRenderers.renderMark = MARKS.renderMarks(
        options?.renderMark?.renderMarks,
      );

      return Container(
        child: nodeListToWidget(richTextDocument?.content ?? []),
      );
    }
    return Container();
  }

  /// nodeListToWidget renders the Widget tree from the data nodes
  Widget nodeListToWidget(List<dynamic>? nodes) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nodes?.map<Widget>((node) => nodeToWidget(node)).toList() ?? [],
    );
  }

  /// nodeToWidget handles converting a node into a Widget, as well as handling
  /// any custom logic needed to accommodate different node types
  Widget nodeToWidget(dynamic node) {
    String nodeType = node['nodeType'] ?? '';
    
    // Converte o tipo do nó se houver mapeamento
    nodeType = NodeTypeMapper.convertBlockType(nodeType);
    
    if (Helpers.isText(node)) {
      return Text.rich(TextSpan(
        text: _processInlineNode(node),
        style: options?.styles.paragraph,
      ));
    } else if (Helpers.isParagraph(node)) {
      return Text.rich(TextSpan(
        children: List<TextSpan>.from(
          node['content']?.map(
            (node) => _processInlineNode(node),
          ) ?? [],
        ),
        style: options?.styles.paragraph,
      ));
    } else if (Helpers.isHeader(node)) {
      TextStyle? style;
      switch (nodeType) {
        case 'heading-1':
          style = options?.styles.heading1;
          break;
        case 'heading-2':
          style = options?.styles.heading2;
          break;
        case 'heading-3':
          style = options?.styles.heading3;
          break;
        case 'heading-4':
          style = options?.styles.heading4;
          break;
        case 'heading-5':
          style = options?.styles.heading5;
          break;
        case 'heading-6':
          style = options?.styles.heading6;
          break;
      }
      return Text.rich(TextSpan(
        children: List<TextSpan>.from(
          node['content']?.map(
            (node) => _processInlineNode(node),
          ) ?? [],
        ),
        style: style,
      ));
    } else {
      Next nextNode = (nodes) => nodeListToWidget(nodes);

      // Primeiro verifica se existe um renderizador customizado
      if (CustomContentRegistry.hasBlockRenderer(nodeType)) {
        return CustomContentRegistry.getBlockRenderer(nodeType)!(node, nextNode);
      }

      // Se não houver renderizador customizado, usa o padrão
      if (singletonRenderers.renderNode[nodeType] == null) {
        return Container();
      }
      return singletonRenderers.renderNode[nodeType]!(node, nextNode);
    }
  }

  /// _processInlineNode handle converting nodes into (potentially
  /// nested) TextSpans, typically coming from Paragraph, Heading and
  /// Hyperlink nodes
  dynamic _processInlineNode(
    node, {
    String? uri,
  }) {
    String nodeType = node['nodeType'] ?? '';
    
    // Converte o tipo do nó se houver mapeamento
    nodeType = NodeTypeMapper.convertInlineType(nodeType);

    // Verifica primeiro se é um inline customizado
    if (CustomContentRegistry.hasInlineRenderer(nodeType)) {
      return CustomContentRegistry.getInlineRenderer(nodeType)!(
        node,
        (nodes) => nodes
            ?.map<TextSpan>(
              (node) => _processInlineNode(node) as TextSpan,
            )
            .toList(),
      );
    }

    if (nodeType == 'hyperlink' || uri?.isNotEmpty == true) {
      // Note: Hyperlinks are nested in other blocs like Paragraphs/Headers
      String link = uri ?? node['data']['uri'];
      if (uri?.isNotEmpty == true && nodeType == 'text') {
        // ensure Hyperlink is used for text blocks with uris
        nodeType = 'hyperlink';
        // pass uri for Hyperlink on text nodes for TapRecognizer
        node['data'] = {'uri': link};
      }
      return singletonRenderers.renderNode[nodeType]!(
        node,
        (nodes) =>
            nodes
                ?.map<TextSpan>(
                  (node) => _processInlineNode(
                    node,
                    uri: link,
                  ) as TextSpan,
                )
                ?.toList() ??
            <InlineSpan>[],
      );
    }

    // for links to entries only process the child-nodes
    if (nodeType == 'entry-hyperlink') {
      return TextSpan(
        children: (node['content'] ?? '')
            .map<TextSpan>((subNode) => _processInlineNode(subNode) as TextSpan)
            .toList(),
      );
    }

    if (nodeType == 'embedded-entry-inline') {
      return singletonRenderers.renderNode[nodeType]!(
        node,
        (nodes) =>
            nodes
                ?.map<TextSpan>(
                  (node) => _processInlineNode(
                    node,
                  ) as TextSpan,
                )
                ?.toList() ??
            <InlineSpan>[],
      );
    }

    // If not a hyperlink, process as text node
    TextNode textNode = TextNode(node);
    String nodeValue = HtmlUnescape().convert(textNode.value);
    if (textNode.marks.isNotEmpty) {
      return TextSpan(
        text: nodeValue,
        style: MARKS.getMarksTextStyles(
          textNode.marks,
          singletonRenderers.renderMark,
        ),
      );
    }
    return TextSpan(text: nodeValue);
  }

  Document? _parseRichTextJson() {
    if (richTextJson == null || richTextJson['nodeType'] != 'document') {
      return null;
    }
    return Document.fromJson(richTextJson);
  }
}
