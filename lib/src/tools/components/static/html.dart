import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class HtmlPageWidget extends StatelessWidget {
  final String content;
  const HtmlPageWidget({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      content,
    );
  }
}
