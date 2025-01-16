library contentful_rich_text;

import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

class EmbeddedEntry extends StatelessWidget {
  final dynamic node;
  final Next next;

  EmbeddedEntry(this.node, this.next);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: toWidgetList(node['content'] != null ? next(node['content']) : null),
      ),
    );
  }
}