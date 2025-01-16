import 'package:contentful_rich_text/types/custom_blocks.dart';
import 'package:flutter/material.dart';

/// Um widget de card pré-construído para exibir conteúdo em um formato de cartão
/// com título, subtítulo e conteúdo.
class ContentCardPreset {
  /// Registra o bloco de card
  static void register({
    String nodeType = 'content-card',
    Color backgroundColor = Colors.white,
    Color borderColor = const Color(0xFFE0E0E0),
    double elevation = 2.0,
    EdgeInsets padding = const EdgeInsets.all(16.0),
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 8.0),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  }) {
    CustomContentRegistry.registerBlock(
      nodeType,
      (node, next) => Card(
        elevation: elevation,
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: borderColor),
        ),
        color: backgroundColor,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (node['data']?['title'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    node['data']['title'],
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (node['data']?['subtitle'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    node['data']['subtitle'],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              if (node['content'] != null) ...[
                ...next(node['content']),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 