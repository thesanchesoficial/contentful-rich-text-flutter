import 'package:contentful_rich_text/types/blocks.dart';
import 'package:contentful_rich_text/types/inlines.dart';

/// Classe responsável por validar tipos de nós
class NodeTypeValidator {
  /// Verifica se um tipo de bloco é válido
  static bool isValidBlockType(String type) {
    return BLOCKS.items.any((block) => block.value == type);
  }

  /// Verifica se um tipo inline é válido
  static bool isValidInlineType(String type) {
    return INLINES.items.any((inline) => inline.value == type);
  }

  /// Obtém o tipo de bloco correspondente, se existir
  static BLOCKS? getBlockType(String type) {
    return BLOCKS.fromValue(type);
  }

  /// Obtém o tipo inline correspondente, se existir
  static INLINES? getInlineType(String type) {
    return INLINES.fromValue(type);
  }

  /// Verifica se um tipo customizado é válido para mapeamento de bloco
  static bool isValidCustomBlockType(String type) {
    // Tipos customizados não podem ter o mesmo nome que tipos padrão
    if (isValidBlockType(type) || isValidInlineType(type)) {
      return false;
    }

    // Tipos customizados devem seguir um padrão válido
    final RegExp validPattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9\-_]*$');
    return validPattern.hasMatch(type);
  }

  /// Verifica se um tipo customizado é válido para mapeamento inline
  static bool isValidCustomInlineType(String type) {
    // Tipos customizados não podem ter o mesmo nome que tipos padrão
    if (isValidBlockType(type) || isValidInlineType(type)) {
      return false;
    }

    // Tipos customizados devem seguir um padrão válido
    final RegExp validPattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9\-_]*$');
    return validPattern.hasMatch(type);
  }

  /// Obtém uma descrição do erro de validação, se houver
  static String? getValidationError(String customType, String contentfulType) {
    if (!isValidCustomBlockType(customType) && !isValidCustomInlineType(customType)) {
      return 'Tipo customizado inválido: $customType. Use apenas letras, números, hífen e underscore, começando com uma letra.';
    }

    if (!isValidBlockType(contentfulType) && !isValidInlineType(contentfulType)) {
      return 'Tipo Contentful inválido: $contentfulType';
    }

    return null;
  }
} 