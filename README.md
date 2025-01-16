# Contentful Rich Text Flutter

A Rich Text renderer that converts Contentful Rich Text JSON objects into Flutter widgets.

[English](#english) | [Português](#português)

## English

### Features

- Renders all Contentful node types
- Custom renderer support
- Type mapping system
- Multiple configuration management
- Visual interface for mapping management

### Installation

```yaml
dependencies:
  contentful_rich_text: ^latest_version
```

### Basic Usage

```dart
ContentfulRichText(richTextJson).documentToWidgetTree
```

### Type Mapping System

The mapping system allows you to use custom names for Contentful node types. For example, you can use `main-title` instead of `heading-1`.

#### Setting Up Mappings

```dart
// Map block types
NodeTypeMapper.mapBlock('main-title', BLOCKS.HEADING_1.value);
NodeTypeMapper.mapBlock('text', BLOCKS.PARAGRAPH.value);
NodeTypeMapper.mapBlock('topic-list', BLOCKS.UL_LIST.value);
NodeTypeMapper.mapBlock('topic', BLOCKS.LIST_ITEM.value);
NodeTypeMapper.mapBlock('quote', BLOCKS.QUOTE.value);

// Map inline types
NodeTypeMapper.mapInline('external-link', INLINES.HYPERLINK.value);
NodeTypeMapper.mapInline('entry-link', INLINES.ENTRY_HYPERLINK.value);
NodeTypeMapper.mapInline('asset-link', INLINES.ASSET_HYPERLINK.value);
```

#### Examples for Each Type

##### Headings
```dart
{
  'nodeType': 'main-title',
  'content': [
    {
      'nodeType': 'text',
      'value': 'Welcome to My App',
      'marks': []
    }
  ]
}
```

##### Paragraph with Link
```dart
{
  'nodeType': 'text',
  'content': [
    {
      'nodeType': 'text',
      'value': 'Check out our ',
      'marks': []
    },
    {
      'nodeType': 'external-link',
      'data': {
        'uri': 'https://example.com'
      },
      'content': [
        {
          'nodeType': 'text',
          'value': 'website',
          'marks': []
        }
      ]
    }
  ]
}
```

##### List
```dart
{
  'nodeType': 'topic-list',
  'content': [
    {
      'nodeType': 'topic',
      'content': [
        {
          'nodeType': 'text',
          'value': 'First item',
          'marks': []
        }
      ]
    },
    {
      'nodeType': 'topic',
      'content': [
        {
          'nodeType': 'text',
          'value': 'Second item',
          'marks': []
        }
      ]
    }
  ]
}
```

#### Configuration Management

The package includes a visual interface for managing mappings:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TypeMappingManager(),
  ),
);
```

##### Creating a Configuration
```dart
final config = await MappingConfigManager.createFromCurrent(
  name: 'Blog Config',
  description: 'Mappings for blog content',
  blockMappings: {
    'main-title': BLOCKS.HEADING_1.value,
    'text': BLOCKS.PARAGRAPH.value,
  },
  inlineMappings: {
    'external-link': INLINES.HYPERLINK.value,
  },
);
```

##### Activating a Configuration
```dart
await MappingConfigManager.setActiveConfig(config.name);
```

##### Exporting/Importing
```dart
// Export
final json = await MappingConfigManager.exportConfigs();
await Clipboard.setData(ClipboardData(text: json));

// Import
final data = await Clipboard.getData('text/plain');
if (data?.text != null) {
  await MappingConfigManager.importConfigs(data!.text!);
}
```

### Supported Types

#### Blocks
- PARAGRAPH
- HEADING_1 to HEADING_6
- UL_LIST
- OL_LIST
- LIST_ITEM
- HR
- QUOTE
- EMBEDDED_ENTRY
- EMBEDDED_ASSET

#### Inline
- HYPERLINK
- ENTRY_HYPERLINK
- ASSET_HYPERLINK
- EMBEDDED_ENTRY

## Português

### Recursos

- Renderiza todos os tipos de nós do Contentful
- Suporte a renderizadores customizados
- Sistema de mapeamento de tipos
- Gerenciamento de múltiplas configurações
- Interface visual para gerenciar mapeamentos

### Instalação

```yaml
dependencies:
  contentful_rich_text: ^latest_version
```

### Uso Básico

```dart
ContentfulRichText(richTextJson).documentToWidgetTree
```

### Sistema de Mapeamento de Tipos

O sistema de mapeamento permite usar nomes personalizados para os tipos de nós do Contentful. Por exemplo, você pode usar `titulo-principal` em vez de `heading-1`.

#### Configurando Mapeamentos

```dart
// Mapeia tipos de bloco
NodeTypeMapper.mapBlock('titulo-principal', BLOCKS.HEADING_1.value);
NodeTypeMapper.mapBlock('texto', BLOCKS.PARAGRAPH.value);
NodeTypeMapper.mapBlock('lista-topicos', BLOCKS.UL_LIST.value);
NodeTypeMapper.mapBlock('topico', BLOCKS.LIST_ITEM.value);
NodeTypeMapper.mapBlock('citacao', BLOCKS.QUOTE.value);

// Mapeia tipos inline
NodeTypeMapper.mapInline('link-externo', INLINES.HYPERLINK.value);
NodeTypeMapper.mapInline('link-entrada', INLINES.ENTRY_HYPERLINK.value);
NodeTypeMapper.mapInline('link-asset', INLINES.ASSET_HYPERLINK.value);
```

#### Exemplos para Cada Tipo

##### Títulos
```dart
{
  'nodeType': 'titulo-principal',
  'content': [
    {
      'nodeType': 'text',
      'value': 'Bem-vindo ao Meu App',
      'marks': []
    }
  ]
}
```

##### Parágrafo com Link
```dart
{
  'nodeType': 'texto',
  'content': [
    {
      'nodeType': 'text',
      'value': 'Visite nosso ',
      'marks': []
    },
    {
      'nodeType': 'link-externo',
      'data': {
        'uri': 'https://exemplo.com'
      },
      'content': [
        {
          'nodeType': 'text',
          'value': 'site',
          'marks': []
        }
      ]
    }
  ]
}
```

##### Lista
```dart
{
  'nodeType': 'lista-topicos',
  'content': [
    {
      'nodeType': 'topico',
      'content': [
        {
          'nodeType': 'text',
          'value': 'Primeiro item',
          'marks': []
        }
      ]
    },
    {
      'nodeType': 'topico',
      'content': [
        {
          'nodeType': 'text',
          'value': 'Segundo item',
          'marks': []
        }
      ]
    }
  ]
}
```

#### Gerenciamento de Configurações

O pacote inclui uma interface visual para gerenciar mapeamentos:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TypeMappingManager(),
  ),
);
```

##### Criando uma Configuração
```dart
final config = await MappingConfigManager.createFromCurrent(
  name: 'Config Blog',
  description: 'Mapeamentos para conteúdo do blog',
  blockMappings: {
    'titulo-principal': BLOCKS.HEADING_1.value,
    'texto': BLOCKS.PARAGRAPH.value,
  },
  inlineMappings: {
    'link-externo': INLINES.HYPERLINK.value,
  },
);
```

##### Ativando uma Configuração
```dart
await MappingConfigManager.setActiveConfig(config.name);
```

##### Exportando/Importando
```dart
// Exportar
final json = await MappingConfigManager.exportConfigs();
await Clipboard.setData(ClipboardData(text: json));

// Importar
final data = await Clipboard.getData('text/plain');
if (data?.text != null) {
  await MappingConfigManager.importConfigs(data!.text!);
}
```

### Tipos Suportados

#### Blocos
- PARAGRAPH
- HEADING_1 a HEADING_6
- UL_LIST
- OL_LIST
- LIST_ITEM
- HR
- QUOTE
- EMBEDDED_ENTRY
- EMBEDDED_ASSET

#### Inline
- HYPERLINK
- ENTRY_HYPERLINK
- ASSET_HYPERLINK
- EMBEDDED_ENTRY

## Contributing | Contribuindo

Contributions are welcome! Please read our contribution guidelines before submitting a PR.

Contribuições são bem-vindas! Por favor, leia nossas diretrizes de contribuição antes de enviar um PR.

## License | Licença

MIT License - see the LICENSE file for details.

MIT License - veja o arquivo LICENSE para detalhes.
