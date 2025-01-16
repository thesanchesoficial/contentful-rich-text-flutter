import 'package:contentful_rich_text/contentful_rich_text.dart';
import 'package:contentful_rich_text/types/blocks.dart';
import 'package:contentful_rich_text/types/inlines.dart';
import 'package:contentful_rich_text/types/node_type_mapper.dart';
import 'package:contentful_rich_text/widgets/type_mapping_manager.dart';
import 'package:flutter/material.dart';

void main() {
  // Configuração inicial de mapeamentos
  NodeTypeMapper.addBlockMappings({
    'titulo-principal': BLOCKS.HEADING_1.value,
    'subtitulo': BLOCKS.HEADING_2.value,
    'texto': BLOCKS.PARAGRAPH.value,
    'lista-topicos': BLOCKS.UL_LIST.value,
    'topico': BLOCKS.LIST_ITEM.value,
  });

  NodeTypeMapper.addInlineMappings({
    'link-externo': INLINES.HYPERLINK.value,
    'link-entrada': INLINES.ENTRY_HYPERLINK.value,
    'link-arquivo': INLINES.ASSET_HYPERLINK.value,
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const AdvancedMappingExample(),
    );
  }
}

class AdvancedMappingExample extends StatefulWidget {
  const AdvancedMappingExample({Key? key}) : super(key: key);

  @override
  State<AdvancedMappingExample> createState() => _AdvancedMappingExampleState();
}

class _AdvancedMappingExampleState extends State<AdvancedMappingExample> {
  // Exemplo de JSON usando tipos customizados
  final richTextJson = {
    "nodeType": "document",
    "data": {},
    "content": [
      {
        "nodeType": "titulo-principal",
        "content": [
          {
            "nodeType": "text",
            "value": "Sistema de Mapeamento Avançado",
            "marks": []
          }
        ]
      },
      {
        "nodeType": "texto",
        "content": [
          {
            "nodeType": "text",
            "value": "Este é um exemplo de como usar o sistema de mapeamento avançado. ",
            "marks": []
          },
          {
            "nodeType": "link-externo",
            "data": {
              "uri": "https://flutter.dev"
            },
            "content": [
              {
                "nodeType": "text",
                "value": "Clique aqui",
                "marks": []
              }
            ]
          },
          {
            "nodeType": "text",
            "value": " para mais informações.",
            "marks": []
          }
        ]
      },
      {
        "nodeType": "subtitulo",
        "content": [
          {
            "nodeType": "text",
            "value": "Recursos Disponíveis",
            "marks": []
          }
        ]
      },
      {
        "nodeType": "lista-topicos",
        "content": [
          {
            "nodeType": "topico",
            "content": [
              {
                "nodeType": "text",
                "value": "Mapeamento bidirecional de tipos",
                "marks": []
              }
            ]
          },
          {
            "nodeType": "topico",
            "content": [
              {
                "nodeType": "text",
                "value": "Persistência de configurações",
                "marks": []
              }
            ]
          },
          {
            "nodeType": "topico",
            "content": [
              {
                "nodeType": "text",
                "value": "Interface de gerenciamento",
                "marks": []
              }
            ]
          },
          {
            "nodeType": "topico",
            "content": [
              {
                "nodeType": "text",
                "value": "Importação e exportação",
                "marks": []
              }
            ]
          }
        ]
      }
    ]
  };

  bool _showManager = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo de Mapeamento Avançado'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showManager ? Icons.close : Icons.settings),
            onPressed: () {
              setState(() {
                _showManager = !_showManager;
              });
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ContentfulRichText(richTextJson).documentToWidgetTree,
            ),
          ),
          if (_showManager)
            SizedBox(
              width: 400,
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: const TypeMappingManager(),
              ),
            ),
        ],
      ),
    );
  }
} 