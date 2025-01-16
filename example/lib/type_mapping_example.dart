import 'package:flutter/material.dart';
import 'package:contentful_rich_text/contentful_rich_text.dart';
import 'package:contentful_rich_text/types/blocks.dart';
import 'package:contentful_rich_text/types/inlines.dart';
import 'package:contentful_rich_text/types/node_type_mapper.dart';
import 'package:contentful_rich_text/widgets/type_mapping_manager.dart';

void main() {
  // Configura os mapeamentos de tipos
  setupMappings();
  runApp(const TypeMappingExample());
}

void setupMappings() {
  // Mapeia tipos de bloco customizados
  NodeTypeMapper.mapBlock('titulo-principal', BLOCKS.HEADING_1.value);
  NodeTypeMapper.mapBlock('subtitulo', BLOCKS.HEADING_2.value);
  NodeTypeMapper.mapBlock('texto', BLOCKS.PARAGRAPH.value);
  NodeTypeMapper.mapBlock('lista-topicos', BLOCKS.UL_LIST.value);
  NodeTypeMapper.mapBlock('topico', BLOCKS.LIST_ITEM.value);
  NodeTypeMapper.mapBlock('citacao', BLOCKS.QUOTE.value);

  // Mapeia tipos inline customizados
  NodeTypeMapper.mapInline('link-externo', INLINES.HYPERLINK.value);
  NodeTypeMapper.mapInline('link-entrada', INLINES.ENTRY_HYPERLINK.value);
  NodeTypeMapper.mapInline('link-asset', INLINES.ASSET_HYPERLINK.value);
}

class TypeMappingExample extends StatelessWidget {
  const TypeMappingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Mapeamento de Tipos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo de Mapeamento de Tipos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TypeMappingManager(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ContentfulRichText(
          {
            'nodeType': 'document',
            'data': {},
            'content': [
              {
                'nodeType': 'titulo-principal',
                'data': {},
                'content': [
                  {
                    'nodeType': 'text',
                    'value': 'Bem-vindo ao Exemplo de Mapeamento',
                    'marks': [],
                    'data': {}
                  }
                ]
              },
              {
                'nodeType': 'texto',
                'data': {},
                'content': [
                  {
                    'nodeType': 'text',
                    'value': 'Este é um exemplo de como usar o sistema de mapeamento de tipos. ',
                    'marks': [],
                    'data': {}
                  },
                  {
                    'nodeType': 'text',
                    'value': 'Você pode usar nomes personalizados',
                    'marks': [],
                    'data': {}
                  },
                  {
                    'nodeType': 'text',
                    'value': ' para os tipos de conteúdo.',
                    'marks': [],
                    'data': {}
                  }
                ]
              },
              {
                'nodeType': 'subtitulo',
                'data': {},
                'content': [
                  {
                    'nodeType': 'text',
                    'value': 'Recursos Disponíveis',
                    'marks': [],
                    'data': {}
                  }
                ]
              },
              {
                'nodeType': 'lista-topicos',
                'data': {},
                'content': [
                  {
                    'nodeType': 'topico',
                    'data': {},
                    'content': [
                      {
                        'nodeType': 'text',
                        'value': 'Mapeamento de tipos de bloco',
                        'marks': [],
                        'data': {}
                      }
                    ]
                  },
                  {
                    'nodeType': 'topico',
                    'data': {},
                    'content': [
                      {
                        'nodeType': 'text',
                        'value': 'Mapeamento de tipos inline',
                        'marks': [],
                        'data': {}
                      }
                    ]
                  },
                  {
                    'nodeType': 'topico',
                    'data': {},
                    'content': [
                      {
                        'nodeType': 'text',
                        'value': 'Suporte a múltiplas configurações',
                        'marks': [],
                        'data': {}
                      }
                    ]
                  }
                ]
              },
              {
                'nodeType': 'citacao',
                'data': {},
                'content': [
                  {
                    'nodeType': 'text',
                    'value': 'O sistema de mapeamento permite usar nomes mais significativos para sua aplicação.',
                    'marks': [],
                    'data': {}
                  }
                ]
              },
              {
                'nodeType': 'texto',
                'data': {},
                'content': [
                  {
                    'nodeType': 'text',
                    'value': 'Para mais informações, consulte a ',
                    'marks': [],
                    'data': {}
                  },
                  {
                    'nodeType': 'link-externo',
                    'data': {
                      'uri': 'https://github.com/seu-usuario/contentful-rich-text-flutter'
                    },
                    'content': [
                      {
                        'nodeType': 'text',
                        'value': 'documentação',
                        'marks': [],
                        'data': {}
                      }
                    ]
                  },
                  {
                    'nodeType': 'text',
                    'value': '.',
                    'marks': [],
                    'data': {}
                  }
                ]
              }
            ]
          },
        ).documentToWidgetTree,
      ),
    );
  }
} 