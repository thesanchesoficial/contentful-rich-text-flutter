import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Classe responsável por persistir os mapeamentos de tipos
class NodeTypeStorage {
  static const String _blockMappingsKey = 'contentful_block_mappings';
  static const String _inlineMappingsKey = 'contentful_inline_mappings';

  /// Salva os mapeamentos de blocos
  static Future<void> saveBlockMappings(Map<String, String> mappings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_blockMappingsKey, jsonEncode(mappings));
  }

  /// Salva os mapeamentos de inlines
  static Future<void> saveInlineMappings(Map<String, String> mappings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inlineMappingsKey, jsonEncode(mappings));
  }

  /// Carrega os mapeamentos de blocos
  static Future<Map<String, String>> loadBlockMappings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(_blockMappingsKey);
    if (json == null) return {};

    final Map<String, dynamic> data = jsonDecode(json);
    return data.map((key, value) => MapEntry(key, value.toString()));
  }

  /// Carrega os mapeamentos de inlines
  static Future<Map<String, String>> loadInlineMappings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(_inlineMappingsKey);
    if (json == null) return {};

    final Map<String, dynamic> data = jsonDecode(json);
    return data.map((key, value) => MapEntry(key, value.toString()));
  }

  /// Limpa todos os mapeamentos salvos
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_blockMappingsKey);
    await prefs.remove(_inlineMappingsKey);
  }

  /// Exporta todos os mapeamentos como JSON
  static Future<String> exportMappings() async {
    final blockMappings = await loadBlockMappings();
    final inlineMappings = await loadInlineMappings();

    return jsonEncode({
      'blocks': blockMappings,
      'inlines': inlineMappings,
    });
  }

  /// Importa mapeamentos de um JSON
  static Future<void> importMappings(String json) async {
    final Map<String, dynamic> data = jsonDecode(json);
    
    if (data['blocks'] != null) {
      final Map<String, dynamic> blocks = data['blocks'];
      await saveBlockMappings(
        blocks.map((key, value) => MapEntry(key, value.toString())),
      );
    }

    if (data['inlines'] != null) {
      final Map<String, dynamic> inlines = data['inlines'];
      await saveInlineMappings(
        inlines.map((key, value) => MapEntry(key, value.toString())),
      );
    }
  }
} 