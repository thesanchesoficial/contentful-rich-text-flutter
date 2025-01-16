library contentful_rich_text;

import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AssetHyperlink extends StatelessWidget {
  final Inline node;
  final Next next;

  AssetHyperlink(this.node, this.next);

  Future<void> _launchAsset() async {
    final data = node.data?['target'];
    if (data == null) return;

    final String? url = data['fields']?['file']?['url'];
    if (url == null) return;

    final Uri uri = Uri.parse('https:$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchAsset,
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