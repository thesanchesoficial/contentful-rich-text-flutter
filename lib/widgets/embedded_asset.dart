library contentful_rich_text;

import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

class EmbeddedAsset extends StatelessWidget {
  final dynamic node;
  final Next next;

  EmbeddedAsset(this.node, this.next);

  @override
  Widget build(BuildContext context) {
    final data = node['data']?['target'];
    if (data == null) return Container();

    final String? url = data['fields']?['file']?['url'];
    final String? title = data['fields']?['title'];
    final String? description = data['fields']?['description'];

    if (url == null) return Container();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https:$url',
            fit: BoxFit.cover,
          ),
          if (title != null)
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          if (description != null)
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(description),
            ),
        ],
      ),
    );
  }
} 