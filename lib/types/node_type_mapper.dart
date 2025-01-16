import 'package:contentful_rich_text/types/blocks.dart';
import 'package:contentful_rich_text/types/inlines.dart';
import 'package:contentful_rich_text/types/node_type_validator.dart';

/// Classe responsável por mapear tipos de nós customizados para tipos padrão do Contentful
class NodeTypeMapper {
  static final Map<String, String> _blockMappings = {};
  static final Map<String, String> _inlineMappings = {};

  /// Mapeia um tipo customizado de bloco para um tipo Contentful
  static void mapBlock(String customType, String contentfulType) {
    if (customType.isEmpty || contentfulType.isEmpty) {
      throw ArgumentError('Tipos não podem ser vazios');
    }
    _blockMappings[customType] = contentfulType;
  }

  /// Mapeia um tipo customizado inline para um tipo Contentful
  static void mapInline(String customType, String contentfulType) {
    if (customType.isEmpty || contentfulType.isEmpty) {
      throw ArgumentError('Tipos não podem ser vazios');
    }
    _inlineMappings[customType] = contentfulType;
  }

  /// Remove um mapeamento de bloco
  static void unmapBlock(String customType) {
    _blockMappings.remove(customType);
  }

  /// Remove um mapeamento inline
  static void unmapInline(String customType) {
    _inlineMappings.remove(customType);
  }

  /// Converte um tipo customizado de bloco para um tipo Contentful
  /// Se não houver mapeamento, retorna o tipo original
  static String convertBlockType(String customType) {
    return _blockMappings[customType] ?? customType;
  }

  /// Converte um tipo customizado inline para um tipo Contentful
  /// Se não houver mapeamento, retorna o tipo original
  static String convertInlineType(String customType) {
    return _inlineMappings[customType] ?? customType;
  }

  /// Retorna uma cópia dos mapeamentos de bloco atuais
  static Map<String, String> getBlockMappings() {
    return Map<String, String>.from(_blockMappings);
  }

  /// Retorna uma cópia dos mapeamentos inline atuais
  static Map<String, String> getInlineMappings() {
    return Map<String, String>.from(_inlineMappings);
  }

  /// Limpa todos os mapeamentos
  static void clearMappings() {
    _blockMappings.clear();
    _inlineMappings.clear();
  }

  /// Adiciona múltiplos mapeamentos de blocos
  static void addBlockMappings(Map<String, String> mappings) {
    mappings.forEach(mapBlock);
  }

  /// Adiciona múltiplos mapeamentos inline
  static void addInlineMappings(Map<String, String> mappings) {
    mappings.forEach(mapInline);
  }
} 