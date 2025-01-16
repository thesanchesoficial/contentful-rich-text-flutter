import 'dart:convert';
import 'package:contentful_rich_text/types/mapping_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gerencia múltiplas configurações de mapeamento
class MappingConfigManager {
  static const String _configsKey = 'contentful_mapping_configs';
  static const String _activeConfigKey = 'contentful_active_config';

  /// Lista todas as configurações salvas
  static Future<List<MappingConfig>> listConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(_configsKey);
    if (json == null) return [];

    final List<dynamic> data = jsonDecode(json);
    return data.map((item) => MappingConfig.fromJson(item)).toList();
  }

  /// Salva uma nova configuração
  static Future<void> saveConfig(MappingConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final configs = await listConfigs();

    // Remove configuração existente com o mesmo nome
    configs.removeWhere((c) => c.name == config.name);
    configs.add(config);

    await prefs.setString(_configsKey, jsonEncode(configs.map((c) => c.toJson()).toList()));
  }

  /// Remove uma configuração
  static Future<void> deleteConfig(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final configs = await listConfigs();

    configs.removeWhere((c) => c.name == name);
    await prefs.setString(_configsKey, jsonEncode(configs.map((c) => c.toJson()).toList()));

    // Se a configuração ativa foi removida, limpa a referência
    final activeConfig = await getActiveConfig();
    if (activeConfig?.name == name) {
      await setActiveConfig(null);
    }
  }

  /// Define a configuração ativa
  static Future<void> setActiveConfig(String? name) async {
    final prefs = await SharedPreferences.getInstance();
    if (name == null) {
      await prefs.remove(_activeConfigKey);
    } else {
      await prefs.setString(_activeConfigKey, name);
    }
  }

  /// Obtém a configuração ativa
  static Future<MappingConfig?> getActiveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final String? activeName = prefs.getString(_activeConfigKey);
    if (activeName == null) return null;

    final configs = await listConfigs();
    return configs.firstWhere(
      (c) => c.name == activeName,
      orElse: () => throw Exception('Configuração ativa não encontrada: $activeName'),
    );
  }

  /// Exporta todas as configurações como JSON
  static Future<String> exportConfigs() async {
    final configs = await listConfigs();
    final activeConfig = await getActiveConfig();

    return jsonEncode({
      'configs': configs.map((c) => c.toJson()).toList(),
      'activeConfig': activeConfig?.name,
    });
  }

  /// Importa configurações de um JSON
  static Future<void> importConfigs(String json) async {
    final Map<String, dynamic> data = jsonDecode(json);
    
    final List<dynamic> configsData = data['configs'];
    final configs = configsData.map((item) => MappingConfig.fromJson(item)).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_configsKey, jsonEncode(configs.map((c) => c.toJson()).toList()));

    if (data['activeConfig'] != null) {
      await setActiveConfig(data['activeConfig'] as String);
    }
  }

  /// Cria uma nova configuração a partir dos mapeamentos atuais
  static Future<MappingConfig> createFromCurrent({
    required String name,
    required String description,
    required Map<String, String> blockMappings,
    required Map<String, String> inlineMappings,
  }) async {
    final config = MappingConfig(
      name: name,
      description: description,
      blockMappings: blockMappings,
      inlineMappings: inlineMappings,
    );

    await saveConfig(config);
    return config;
  }

  /// Limpa todas as configurações
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_configsKey);
    await prefs.remove(_activeConfigKey);
  }
} 