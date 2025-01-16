# Contentful Rich Text Flutter

Um renderizador de Rich Text que converte objetos JSON do Contentful Rich Text em widgets Flutter.

## Recursos

- Renderização de todos os tipos de nós do Contentful
- Suporte a renderizadores customizados
- Sistema de mapeamento de tipos
- Gerenciamento de múltiplas configurações
- Interface visual para gerenciar mapeamentos

## Instalação

```yaml
dependencies:
  contentful_rich_text: ^latest_version
```

## Uso Básico

```dart
ContentfulRichText(richTextJson).documentToWidgetTree
```

## Mapeamento de Tipos

O sistema de mapeamento permite usar nomes personalizados para os tipos de nós do Contentful. Por exemplo, você pode usar `titulo-principal` em vez de `heading-1`.

### Configuração de Mapeamentos

```dart
// Mapeia tipos de bloco
NodeTypeMapper.mapBlock('titulo-principal', BLOCKS.HEADING_1.value);
NodeTypeMapper.mapBlock('texto', BLOCKS.PARAGRAPH.value);
NodeTypeMapper.mapBlock('lista-topicos', BLOCKS.UL_LIST.value);

// Mapeia tipos inline
NodeTypeMapper.mapInline('link-externo', INLINES.HYPERLINK.value);
NodeTypeMapper.mapInline('link-entrada', INLINES.ENTRY_HYPERLINK.value);
```

### Uso com Tipos Customizados

```dart
{
  'nodeType': 'titulo-principal',
  'content': [
    {
      'nodeType': 'text',
      'value': 'Meu Título',
      'marks': []
    }
  ]
}
```

### Gerenciamento de Configurações

O pacote inclui uma interface visual para gerenciar mapeamentos:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TypeMappingManager(),
  ),
);
```

A interface permite:
- Criar múltiplas configurações de mapeamento
- Ativar/desativar configurações
- Exportar/importar configurações
- Gerenciar mapeamentos de blocos e inlines

### Exemplo Completo

Veja o arquivo `example/lib/type_mapping_example.dart` para um exemplo completo de uso do sistema de mapeamento.

## Tipos Suportados

### Blocos
- PARAGRAPH
- HEADING_1 a HEADING_6
- UL_LIST
- OL_LIST
- LIST_ITEM
- HR
- QUOTE
- EMBEDDED_ENTRY
- EMBEDDED_ASSET

### Inline
- HYPERLINK
- ENTRY_HYPERLINK
- ASSET_HYPERLINK
- EMBEDDED_ENTRY

## Contribuindo

Contribuições são bem-vindas! Por favor, leia nossas diretrizes de contribuição antes de enviar um PR.

## Licença

MIT License - veja o arquivo LICENSE para detalhes.
