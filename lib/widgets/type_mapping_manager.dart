import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contentful_rich_text/types/mapping_config.dart';
import 'package:contentful_rich_text/types/mapping_config_manager.dart';
import 'package:contentful_rich_text/types/node_type_mapper.dart';

class TypeMappingManager extends StatefulWidget {
  const TypeMappingManager({super.key});

  @override
  State<TypeMappingManager> createState() => _TypeMappingManagerState();
}

class _TypeMappingManagerState extends State<TypeMappingManager> {
  final _formKey = GlobalKey<FormState>();
  final _configNameController = TextEditingController();
  final _configDescController = TextEditingController();
  final _customTypeController = TextEditingController();
  final _contentfulTypeController = TextEditingController();

  List<MappingConfig> _configs = [];
  MappingConfig? _activeConfig;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    final configs = await MappingConfigManager.listConfigs();
    final activeConfig = await MappingConfigManager.getActiveConfig();
    
    setState(() {
      _configs = configs;
      _activeConfig = activeConfig;
    });
  }

  Future<void> _createConfig() async {
    if (!_formKey.currentState!.validate()) return;

    final config = await MappingConfigManager.createFromCurrent(
      name: _configNameController.text,
      description: _configDescController.text,
      blockMappings: NodeTypeMapper.getBlockMappings(),
      inlineMappings: NodeTypeMapper.getInlineMappings(),
    );

    await MappingConfigManager.setActiveConfig(config.name);
    _configNameController.clear();
    _configDescController.clear();
    await _loadConfigs();
  }

  Future<void> _activateConfig(MappingConfig config) async {
    await MappingConfigManager.setActiveConfig(config.name);
    NodeTypeMapper.clearMappings();
    
    for (final entry in config.blockMappings.entries) {
      NodeTypeMapper.mapBlock(entry.key, entry.value);
    }
    for (final entry in config.inlineMappings.entries) {
      NodeTypeMapper.mapInline(entry.key, entry.value);
    }

    await _loadConfigs();
  }

  Future<void> _deleteConfig(MappingConfig config) async {
    await MappingConfigManager.deleteConfig(config.name);
    await _loadConfigs();
  }

  Future<void> _exportConfigs() async {
    final json = await MappingConfigManager.exportConfigs();
    await Clipboard.setData(ClipboardData(text: json));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configurações exportadas para a área de transferência')),
    );
  }

  Future<void> _importConfigs() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum dado encontrado na área de transferência')),
      );
      return;
    }

    try {
      await MappingConfigManager.importConfigs(data!.text!);
      await _loadConfigs();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configurações importadas com sucesso')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao importar configurações: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerenciador de Mapeamentos'),
          bottom: TabBar(
            onTap: (index) => setState(() => _selectedTabIndex = index),
            tabs: const [
              Tab(text: 'Configurações'),
              Tab(text: 'Mapeamentos'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_upload),
              onPressed: _exportConfigs,
              tooltip: 'Exportar configurações',
            ),
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: _importConfigs,
              tooltip: 'Importar configurações',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildConfigsTab(),
            _buildMappingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _configNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da configuração',
                    hintText: 'Ex: Blog',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _configDescController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Ex: Mapeamentos para o blog',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createConfig,
                  child: const Text('Criar Nova Configuração'),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: _configs.length,
            itemBuilder: (context, index) {
              final config = _configs[index];
              final isActive = _activeConfig?.name == config.name;
              
              return ListTile(
                title: Text(config.name),
                subtitle: Text(config.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isActive)
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => _activateConfig(config),
                        tooltip: 'Ativar configuração',
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteConfig(config),
                      tooltip: 'Excluir configuração',
                    ),
                  ],
                ),
                selected: isActive,
                leading: isActive
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.radio_button_unchecked),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMappingsTab() {
    final blockMappings = NodeTypeMapper.getBlockMappings().entries.toList();
    final inlineMappings = NodeTypeMapper.getInlineMappings().entries.toList();

    return ListView(
      children: [
        ExpansionTile(
          title: const Text('Mapeamentos de Blocos'),
          initiallyExpanded: true,
          children: [
            for (final entry in blockMappings)
              ListTile(
                title: Text(entry.key),
                subtitle: Text('→ ${entry.value}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    NodeTypeMapper.unmapBlock(entry.key);
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
        ExpansionTile(
          title: const Text('Mapeamentos Inline'),
          initiallyExpanded: true,
          children: [
            for (final entry in inlineMappings)
              ListTile(
                title: Text(entry.key),
                subtitle: Text('→ ${entry.value}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    NodeTypeMapper.unmapInline(entry.key);
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _configNameController.dispose();
    _configDescController.dispose();
    _customTypeController.dispose();
    _contentfulTypeController.dispose();
    super.dispose();
  }
} 