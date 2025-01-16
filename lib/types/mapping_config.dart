
/// Representa uma configuração de mapeamento completa
class MappingConfig {
  /// Nome da configuração
  final String name;

  /// Descrição da configuração
  final String description;

  /// Data de criação
  final DateTime createdAt;

  /// Data da última modificação
  final DateTime updatedAt;

  /// Mapeamentos de blocos
  final Map<String, String> blockMappings;

  /// Mapeamentos de inlines
  final Map<String, String> inlineMappings;

  MappingConfig({
    required this.name,
    required this.description,
    required this.blockMappings,
    required this.inlineMappings,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Cria uma configuração a partir de um JSON
  factory MappingConfig.fromJson(Map<String, dynamic> json) {
    return MappingConfig(
      name: json['name'] as String,
      description: json['description'] as String,
      blockMappings: Map<String, String>.from(json['blockMappings']),
      inlineMappings: Map<String, String>.from(json['inlineMappings']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Converte a configuração para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'blockMappings': blockMappings,
      'inlineMappings': inlineMappings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Cria uma cópia da configuração com algumas alterações
  MappingConfig copyWith({
    String? name,
    String? description,
    Map<String, String>? blockMappings,
    Map<String, String>? inlineMappings,
  }) {
    return MappingConfig(
      name: name ?? this.name,
      description: description ?? this.description,
      blockMappings: blockMappings ?? Map.from(this.blockMappings),
      inlineMappings: inlineMappings ?? Map.from(this.inlineMappings),
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// Converte a configuração para uma string formatada
  @override
  String toString() {
    return 'MappingConfig(name: $name, description: $description, '
        'blockMappings: ${blockMappings.length} items, '
        'inlineMappings: ${inlineMappings.length} items)';
  }
} 