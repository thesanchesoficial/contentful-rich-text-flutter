import 'package:contentful_rich_text/types/types.dart';

/// Registry for custom blocks and inlines
class CustomContentRegistry {
  static final Map<String, NodeRenderer> _customBlocks = {};
  static final Map<String, NodeRenderer> _customInlines = {};

  /// Register a custom block renderer
  static void registerBlock(String nodeType, NodeRenderer renderer) {
    _customBlocks[nodeType] = renderer;
  }

  /// Register a custom inline renderer
  static void registerInline(String nodeType, NodeRenderer renderer) {
    _customInlines[nodeType] = renderer;
  }

  /// Unregister a custom block
  static void unregisterBlock(String nodeType) {
    _customBlocks.remove(nodeType);
  }

  /// Unregister a custom inline
  static void unregisterInline(String nodeType) {
    _customInlines.remove(nodeType);
  }

  /// Get a block renderer by nodeType
  static NodeRenderer? getBlockRenderer(String nodeType) {
    return _customBlocks[nodeType];
  }

  /// Get an inline renderer by nodeType
  static NodeRenderer? getInlineRenderer(String nodeType) {
    return _customInlines[nodeType];
  }

  /// Check if a block renderer exists
  static bool hasBlockRenderer(String nodeType) {
    return _customBlocks.containsKey(nodeType);
  }

  /// Check if an inline renderer exists
  static bool hasInlineRenderer(String nodeType) {
    return _customInlines.containsKey(nodeType);
  }

  /// Clear all custom blocks and inlines
  static void clear() {
    _customBlocks.clear();
    _customInlines.clear();
  }

  /// Get all registered custom blocks
  static Map<String, NodeRenderer> get blocks => Map.unmodifiable(_customBlocks);

  /// Get all registered custom inlines
  static Map<String, NodeRenderer> get inlines => Map.unmodifiable(_customInlines);
} 