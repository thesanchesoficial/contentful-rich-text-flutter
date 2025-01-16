import 'package:contentful_rich_text/types/custom_blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Um widget de bloco de código pré-construído para exibir código fonte
/// com sintaxe destacada e botão de copiar.
class CodeBlockPreset {
  /// Registra o bloco de código
  static void register({
    String nodeType = 'code-block',
    Color backgroundColor = const Color(0xFF2B2B2B),
    Color textColor = Colors.white,
    Color borderColor = const Color(0xFF444444),
    double borderRadius = 8.0,
    EdgeInsets padding = const EdgeInsets.all(16.0),
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 8.0),
  }) {
    CustomContentRegistry.registerBlock(
      nodeType,
      (node, next) => Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra superior com linguagem e botão de copiar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Linguagem
                  if (node['data']?['language'] != null)
                    Text(
                      node['data']['language'].toUpperCase(),
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 12.0,
                      ),
                    ),
                  // Botão de copiar
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      color: textColor.withOpacity(0.7),
                      size: 20.0,
                    ),
                    onPressed: () {
                      final code = node['data']?['code'] ?? '';
                      Clipboard.setData(ClipboardData(text: code));
                    },
                    tooltip: 'Copiar código',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Código
            Container(
              padding: padding,
              child: SelectableText(
                node['data']?['code'] ?? '',
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'monospace',
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 