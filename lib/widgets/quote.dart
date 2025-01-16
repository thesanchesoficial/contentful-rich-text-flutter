library contentful_rich_text;

import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

class Quote extends StatelessWidget {
  final dynamic node;
  final Next next;

  Quote(this.node, this.next);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.grey[400]!,
            width: 4.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (node['content'] != null) ...[
            ...next(node['content']),
          ],
        ],
      ),
    );
  }
}