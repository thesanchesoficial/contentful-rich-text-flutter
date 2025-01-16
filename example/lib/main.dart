import 'package:contentful_rich_text/contentful_rich_text.dart';
import 'package:contentful_rich_text/types/types.dart';
import 'package:example/contentful_data.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contentful Rich Text Parser Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contentful Rich Text Parser Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SingleChildScrollView(
                child: ContentfulRichText(
                  ContentfulData.jsonData,
                  options: Options(
                    renderNode: RenderNode({}),
                    textStyles: TextStyles(
                      heading2: Theme.of(context).textTheme.titleLarge,
                      paragraph: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ).documentToWidgetTree,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(height: 4),
              ),
              const Text('JSON Data:'),
              const Expanded(
                child: SingleChildScrollView(
                  child: Text(ContentfulData.stringData),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Conversor/Adaptador para transformar o JSON de rich text da sua API
/// no formato esperado pelo package `contentful_rich_text`.
class ApiToContentfulConverter {
  static Map<String, dynamic> convertDocument(Map<String, dynamic> apiJson) {
    final nodes = apiJson['nodes'] as List<dynamic>? ?? [];

    final contentfulContent = nodes
        .map((node) => _convertNode(node as Map<String, dynamic>))
        .whereType<Map<String, dynamic>>()
        .toList();

    return {
      'nodeType': 'document',
      'data': {},
      'content': contentfulContent,
    };
  }

  static Map<String, dynamic>? _convertNode(Map<String, dynamic> node) {
    final type = node['type'] as String?;

    switch (type) {
      case 'PARAGRAPH':
        return _convertParagraph(node);
      case 'HEADING':
        return _convertHeading(node);
      case 'BLOCKQUOTE':
        return _convertBlockquote(node);
      case 'quote':
        return _convertBlockquote(node);
      case 'TEXT':
        return _convertTextNode(node);
      default:
        return null;
    }
  }

  static Map<String, dynamic> _convertParagraph(Map<String, dynamic> node) {
    final childNodes = node['nodes'] as List<dynamic>? ?? [];
    final contentfulChildren = childNodes
        .map((child) => _convertNode(child as Map<String, dynamic>))
        .whereType<Map<String, dynamic>>()
        .toList();

    final paragraphData = node['paragraphData'] as Map<String, dynamic>? ?? {};
    final textStyle = paragraphData['textStyle'] as Map<String, dynamic>? ?? {};
    final alignment = textStyle['textAlignment'] as String?;
    final indentation = paragraphData['indentation'];

    return {
      'nodeType': 'paragraph',
      'data': {
        'indentation': indentation,
        'textAlignment': alignment,
      },
      'content': contentfulChildren,
    };
  }

  static Map<String, dynamic> _convertHeading(Map<String, dynamic> node) {
    final headingData = node['headingData'] as Map<String, dynamic>? ?? {};
    final level = headingData['level'] as int? ?? 2;

    final textStyle = headingData['textStyle'] as Map<String, dynamic>? ?? {};
    final alignment = textStyle['textAlignment'] as String?;

    final childNodes = node['nodes'] as List<dynamic>? ?? [];
    final contentfulChildren = childNodes
        .map((child) => _convertNode(child as Map<String, dynamic>))
        .whereType<Map<String, dynamic>>()
        .toList();

    final nodeType = 'heading-$level';

    return {
      'nodeType': nodeType,
      'data': {
        'textAlignment': alignment,
      },
      'content': contentfulChildren,
    };
  }

  /// Aqui está o “pulo do gato”: trocamos "BLOCKQUOTE" -> `"quote"`.
  static Map<String, dynamic> _convertBlockquote(Map<String, dynamic> node) {
    print(node);
    final childNodes = node['nodes'] as List<dynamic>? ?? [];
    final contentfulChildren = childNodes
        .map((child) => _convertNode(child as Map<String, dynamic>))
        .whereType<Map<String, dynamic>>()
        .toList();

    final blockquoteData = node['blockquoteData'] as Map<String, dynamic>? ?? {};
    final indentation = blockquoteData['indentation'];

    return {
      'nodeType': 'BLOCKQUOTE',
      'data': {
        'indentation': indentation,
      },
      'content': contentfulChildren,
    };
  }

  static Map<String, dynamic> _convertTextNode(Map<String, dynamic> node) {
    final textData = node['textData'] as Map<String, dynamic>? ?? {};
    final textValue = textData['text'] as String? ?? '';
    final decorations = textData['decorations'] as List<dynamic>? ?? [];

    final marks = decorations
        .map(_convertDecorationToMark)
        .whereType<Map<String, dynamic>>()
        .toList();

    return {
      'nodeType': 'text',
      'value': textValue,
      'marks': marks,
      'data': {},
    };
  }

  static Map<String, dynamic>? _convertDecorationToMark(dynamic decoration) {
    if (decoration is! Map<String, dynamic>) return null;

    final type = decoration['type'] as String?;
    if (type == null) return null;

    switch (type) {
      case 'BOLD':
        return {'type': 'bold'};
      case 'ITALIC':
        return {'type': 'italic'};
      case 'UNDERLINE':
        return {'type': 'underline'};
      default:
        return null;
    }
  }
}
