import 'package:contentful_rich_text/contentful_rich_text.dart';
import 'package:contentful_rich_text/presets/presets.dart';
import 'package:flutter/material.dart';

void main() {
  // Registra os presets com configurações personalizadas
  ContentCardPreset.register(
    nodeType: 'card',
    backgroundColor: Colors.white,
    elevation: 4.0,
  );

  AlertBoxPreset.register(
    nodeType: 'alert',
  );

  CodeBlockPreset.register(
    nodeType: 'code',
    backgroundColor: const Color(0xFF1E1E1E),
  );

  CalloutPreset.register(
    nodeType: 'quote',
    accentColor: Colors.purple,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemplo de JSON usando todos os presets
    final richTextJson = {
      "nodeType": "document",
      "data": {},
      "content": [
        {
          "nodeType": "card",
          "data": {
            "title": "Usando Presets",
            "subtitle": "Exemplo de uso dos widgets pré-construídos"
          },
          "content": [
            {
              "nodeType": "paragraph",
              "content": [
                {
                  "nodeType": "text",
                  "value": "Este é um exemplo de como usar os widgets pré-construídos do pacote.",
                  "marks": []
                }
              ]
            }
          ]
        },
        {
          "nodeType": "alert",
          "data": {
            "type": "info",
            "title": "Informação Importante"
          },
          "content": [
            {
              "nodeType": "paragraph",
              "content": [
                {
                  "nodeType": "text",
                  "value": "Os presets tornam mais fácil criar layouts comuns.",
                  "marks": []
                }
              ]
            }
          ]
        },
        {
          "nodeType": "code",
          "data": {
            "language": "dart",
            "code": """void main() {
  print('Hello, World!');
}"""
          },
          "content": []
        },
        {
          "nodeType": "quote",
          "data": {
            "author": "Albert Einstein",
            "source": "Sobre a Teoria da Relatividade"
          },
          "content": [
            {
              "nodeType": "paragraph",
              "content": [
                {
                  "nodeType": "text",
                  "value": "A imaginação é mais importante que o conhecimento.",
                  "marks": []
                }
              ]
            }
          ]
        }
      ]
    };

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemplo de Presets'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ContentfulRichText(richTextJson).documentToWidgetTree,
        ),
      ),
    );
  }
} 