import 'package:contentful_rich_text/types/custom_blocks.dart';
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
            // Ícone de citação
            Icon(
              Icons.format_quote,
              color: accentColor.withOpacity(0.3),
              size: 40.0,
            ),
            const SizedBox(height: 16.0),
            // Conteúdo da citação
            if (node['content'] != null) ...[
              DefaultTextStyle.merge(
                style: quoteStyle ??
                    TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: next(node['content']),
                ),
              ),
            ],
            // Autor da citação
            if (node['data']?['author'] != null) ...[
              const SizedBox(height: 16.0),
              Text(
                '— ${node['data']['author']}',
                style: authorStyle ??
                    TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (node['data']?['source'] != null)
                Text(
                  node['data']['source'],
                  style: authorStyle?.copyWith(
                        fontSize: (authorStyle.fontSize ?? 16.0) - 2,
                      ) ??
                      TextStyle(
                        fontSize: 14.0,
                        color: Colors.black45,
                      ),
                ),
            ],
          ],
        ),
      ),
    );
  }
} 