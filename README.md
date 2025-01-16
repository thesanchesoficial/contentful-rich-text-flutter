# Contentful Rich Text Flutter Renderer

A Flutter package to render Contentful Rich Text JSON data into Flutter widgets.

## Features

- Renders all standard Contentful Rich Text nodes
- Supports custom blocks and inline elements
- Customizable text styles for all text elements
- Type mapping system for custom node types
- Built-in default styles

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  contentful_rich_text: ^latest_version
```

## Usage

### Basic Usage

```dart
ContentfulRichText(richTextJson).documentToWidgetTree
```

### Custom Text Styles

You can customize text styles for different text elements:

```dart
ContentfulRichText(
  richTextJson,
  options: Options(
    renderNode: RenderNode({}),
    textStyles: TextStyles(
      paragraph: TextStyle(
        fontSize: 18.0,
        height: 1.6,
        color: Colors.grey[800],
      ),
      heading1: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w900,
        color: Colors.blue[900],
      ),
      quote: TextStyle(
        fontSize: 16.0,
        fontStyle: FontStyle.italic,
        color: Colors.grey[600],
      ),
    ),
  ),
).documentToWidgetTree
```

Available style properties:
- `paragraph`
- `heading1` to `heading6`
- `listItem`
- `quote`
- `hyperlink`

### Custom Blocks

You can create custom blocks for specific content types:

```dart
// Define your custom block widget
class RiceBlock extends StatelessWidget {
  final dynamic node;
  final Next next;

  const RiceBlock(this.node, this.next);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.rice_bowl, size: 32),
          if (node['content'] != null)
            ...toWidgetList(next(node['content'])),
        ],
      ),
    );
  }
}

// Register your custom block
void main() {
  CustomContentRegistry.registerBlockRenderer(
    'rice',
    (node, next) => RiceBlock(node, next),
  );
  
  runApp(MyApp());
}

// Use with type mapping
ContentfulRichText(
  richTextJson,
  options: Options(
    renderNode: RenderNode({}),
  ),
).documentToWidgetTree
```

---

# Contentful Rich Text Flutter Renderer (Português)

Um pacote Flutter para renderizar dados JSON do Contentful Rich Text em widgets Flutter.

## Funcionalidades

- Renderiza todos os nós padrão do Contentful Rich Text
- Suporta blocos e elementos inline personalizados
- Estilos de texto personalizáveis para todos os elementos
- Sistema de mapeamento de tipos para nós personalizados
- Estilos padrão incluídos

## Instalação

Adicione ao arquivo `pubspec.yaml` do seu projeto:

```yaml
dependencies:
  contentful_rich_text: ^última_versão
```

## Uso

### Uso Básico

```dart
ContentfulRichText(richTextJson).documentToWidgetTree
```

### Estilos de Texto Personalizados

Você pode personalizar os estilos de texto para diferentes elementos:

```dart
ContentfulRichText(
  richTextJson,
  options: Options(
    renderNode: RenderNode({}),
    textStyles: TextStyles(
      paragraph: TextStyle(
        fontSize: 18.0,
        height: 1.6,
        color: Colors.grey[800],
      ),
      heading1: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w900,
        color: Colors.blue[900],
      ),
      quote: TextStyle(
        fontSize: 16.0,
        fontStyle: FontStyle.italic,
        color: Colors.grey[600],
      ),
    ),
  ),
).documentToWidgetTree
```

Propriedades de estilo disponíveis:
- `paragraph` (parágrafo)
- `heading1` a `heading6` (títulos)
- `listItem` (item de lista)
- `quote` (citação)
- `hyperlink` (link)

### Blocos Personalizados

Você pode criar blocos personalizados para tipos específicos de conteúdo:

```dart
// Defina seu widget de bloco personalizado
class BlocoArroz extends StatelessWidget {
  final dynamic node;
  final Next next;

  const BlocoArroz(this.node, this.next);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.rice_bowl, size: 32),
          if (node['content'] != null)
            ...toWidgetList(next(node['content'])),
        ],
      ),
    );
  }
}

// Registre seu bloco personalizado
void main() {
  CustomContentRegistry.registerBlockRenderer(
    'arroz',
    (node, next) => BlocoArroz(node, next),
  );
  
  runApp(MyApp());
}

// Use com mapeamento de tipos
ContentfulRichText(
  richTextJson,
  options: Options(
    renderNode: RenderNode({}),
  ),
).documentToWidgetTree
```

## Contributing | Contribuindo

Contributions are welcome! Please read our contribution guidelines before submitting a PR.

Contribuições são bem-vindas! Por favor, leia nossas diretrizes de contribuição antes de enviar um PR.

## License | Licença

MIT License - see the LICENSE file for details.

MIT License - veja o arquivo LICENSE para detalhes.
