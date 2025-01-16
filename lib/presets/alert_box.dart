import 'package:contentful_rich_text/types/custom_blocks.dart';
import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

/// Tipos de alerta disponíveis
enum AlertType {
  info,
  success,
  warning,
  error,
}

/// Um widget de alerta pré-construído para exibir mensagens importantes
/// com diferentes tipos e estilos.
class AlertBoxPreset {
  /// Obtém a cor de fundo baseada no tipo de alerta
  static Color _getBackgroundColor(AlertType type) {
    switch (type) {
      case AlertType.info:
        return Colors.blue[50]!;
      case AlertType.success:
        return Colors.green[50]!;
      case AlertType.warning:
        return Colors.orange[50]!;
      case AlertType.error:
        return Colors.red[50]!;
    }
  }

  /// Obtém a cor da borda baseada no tipo de alerta
  static Color _getBorderColor(AlertType type) {
    switch (type) {
      case AlertType.info:
        return Colors.blue[300]!;
      case AlertType.success:
        return Colors.green[300]!;
      case AlertType.warning:
        return Colors.orange[300]!;
      case AlertType.error:
        return Colors.red[300]!;
    }
  }

  /// Obtém o ícone baseado no tipo de alerta
  static IconData _getIcon(AlertType type) {
    switch (type) {
      case AlertType.info:
        return Icons.info_outline;
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
    }
  }

  /// Registra o bloco de alerta
  static void register({
    String nodeType = 'alert',
  }) {
    CustomContentRegistry.registerBlock(
      nodeType,
      (node, next) {
        final AlertType type = AlertType.values.firstWhere(
          (t) => t.toString().split('.').last == (node['data']?['type'] ?? 'info'),
          orElse: () => AlertType.info,
        );

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: _getBackgroundColor(type),
            border: Border.all(
              color: _getBorderColor(type),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _getIcon(type),
                color: _getBorderColor(type),
                size: 24.0,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (node['data']?['title'] != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          node['data']['title'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: _getBorderColor(type),
                          ),
                        ),
                      ),
                    ...toWidgetList(node['content'] != null ? next(node['content']) : null),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 