library contentful_rich_text;

import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

class EntryHyperlink extends StatelessWidget {
  final Inline node;
  final Next next;

  EntryHyperlink(this.node, this.next);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aqui você pode implementar a navegação para a entrada específica
        // usando node.data['target']
      },
      child: Text.rich(
        TextSpan(
          children: next(node.content),
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
} 