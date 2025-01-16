import 'package:contentful_rich_text/types/custom_blocks.dart';
import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

/// Um widget de callout pré-construído para destacar citações ou
/// trechos importantes do texto.
class CalloutPreset {
  /// Registra o bloco de callout
  static void register({
    String nodeType = 'callout',
    Color backgroundColor = const Color(0xFFF5F5F5),
    Color accentColor = Colors.blue,
    double borderWidth = 4.0,
    EdgeInsets padding = const EdgeInsets.all(24.0),
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 16.0),
    TextStyle? quoteStyle,
    TextStyle? authorStyle,
  }) {
    CustomContentRegistry.registerBlock(
      nodeType,
      (node, next) => Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            left: BorderSide(
              color: accentColor,
              width: borderWidth,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              color: accentColor.withOpacity(0.3),
              size: 40.0,
            ),
            const SizedBox(height: 16.0),
            ...toWidgetList(node['content'] != null ? next(node['content']) : null),
            if (node['data']?['author'] != null)
              Text(
                '- ${node['data']['author']}',
                style: authorStyle,
              ),
          ],
        ),
      ),
    );
  }
} 