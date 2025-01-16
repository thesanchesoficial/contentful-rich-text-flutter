import 'package:contentful_rich_text/contentful_rich_text.dart';
import 'package:contentful_rich_text/types/custom_blocks.dart';
import 'package:flutter/material.dart';

void main() {
  // Registra um bloco customizado chamado 'arroz'
  CustomContentRegistry.registerBlock(
    'arroz',
    (node, next) => Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.amber),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bloco de Arroz',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.amber[900],
            ),
          ),
          if (node['content'] != null)
            ...(next(node['content']) as List<Widget>? ?? []),
        ],
      ),
    ),
  );

  // Registra um inline customizado chamado 'destaque'
  CustomContentRegistry.registerInline(
    'destaque',
    (node, next) => TextSpan(
      children: next(node['content']),
      style: TextStyle(
        backgroundColor: Colors.yellow,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemplo de JSON com um bloco customizado e um inline customizado
    final richTextJson = {
      "nodeType": "document",
      "data": {},
      "content": [
        {
          "nodeType": "paragraph",
          "data": {},
          "content": [
            {
              "nodeType": "text",
              "value": "Este é um parágrafo normal com um ",
              "marks": [],
              "data": {}
            },
            {
              "nodeType": "destaque",
              "data": {},
              "content": [
                {
                  "nodeType": "text",
                  "value": "texto destacado",
                  "marks": [],
                  "data": {}
                }
              ]
            },
            {
              "nodeType": "text",
              "value": ".",
              "marks": [],
              "data": {}
            }
          ]
        },
        {
          "nodeType": "arroz",
          "data": {},
          "content": [
            {
              "nodeType": "paragraph",
              "data": {},
              "content": [
                {
                  "nodeType": "text",
                  "value": "Este é um conteúdo dentro do bloco de arroz com ",
                  "marks": [],
                  "data": {}
                },
                {
                  "nodeType": "destaque",
                  "data": {},
                  "content": [
                    {
                      "nodeType": "text",
                      "value": "texto destacado também",
                      "marks": [],
                      "data": {}
                    }
                  ]
                },
                {
                  "nodeType": "text",
                  "value": "!",
                  "marks": [],
                  "data": {}
                }
              ]
            }
          ]
        }
      ]
    };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exemplo de Conteúdo Customizado'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ContentfulRichText(richTextJson).documentToWidgetTree,
        ),
      ),
    );
  }
} 